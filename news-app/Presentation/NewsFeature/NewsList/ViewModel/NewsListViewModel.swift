//
//  NewsListViewModel.swift
//  news-app
//
//  Created by Georgius Yoga on 28/3/25.
//

import Foundation
import Combine

protocol NewsListViewModelInput {
    func viewDidLoad()
    func viewDidRefresh()
    func viewDidSelectItem(at index: Int)
    func didSearch(query: String)
    func didLoadNextPage()
    func didCancelSearch()
}

protocol NewsListViewModelOutput {
    var content: AnyPublisher<NewsListContentViewModel, Never> { get }
    var error: AnyPublisher<String, Never> { get }
}

protocol NewsListViewModel: NewsListViewModelInput, NewsListViewModelOutput {}

final class DefaultNewsListViewModel: NewsListViewModel {

    // MARK: - Properties

    private let newsListUsesCase: NewsListUseCase
    private(set) var items: [NewsListItemViewModel] = []
    private var cancellables = Set<AnyCancellable>()
    private var currentPage: Int = 0
    private var totalPageCount: Int = 1
    private var hasMorePage: Bool { currentPage < totalPageCount }
    private var nextPage: Int { hasMorePage ? currentPage + 1 : currentPage }

    // MARK: - Output

    private let contentSubject = CurrentValueSubject<NewsListContentViewModel, Never>(.emptyData)
    private let errorSubject = CurrentValueSubject<String, Never>("")
    private let querySubject = CurrentValueSubject<String, Never>("")

    var content: AnyPublisher<NewsListContentViewModel, Never> {
        contentSubject.eraseToAnyPublisher()
    }

    var error: AnyPublisher<String, Never> {
        errorSubject.eraseToAnyPublisher()
    }

    // MARK: - Init

    init(newsListUsesCase: NewsListUseCase) {
        self.newsListUsesCase = newsListUsesCase
        self.setupBindings()
    }

    // MARK: - Helpers

    private func reload() {
        resetData()
    }

    private func resetData() {
        currentPage = 0
        totalPageCount = 1
        items.removeAll()
        contentSubject.send(.emptyData)
    }

    private func setupBindings() {
        querySubject
            .debounce(for: .milliseconds(500), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .sink { [weak self] query in
                guard let self = self, !query.isEmpty else { return }
                Task { await self.loadNewsListData(query: query)}
            }.store(in: &cancellables)
    }

    @MainActor
    private func loadNewsListData(query: String) {
        contentSubject.send(.loadingShimmer)
        querySubject.send(query)
        Task {
            do {
                let result = try await newsListUsesCase.fetchNewsList(
                    request: .init(query: query, page: nextPage)
                )
                update(result)
            } catch {
                handleError(error)
            }
        }
    }

    private func handleError(_ error: Error) {
        if let error = error as? NetworkError {
            self.errorSubject.send(error.description)
        } else {
            self.errorSubject.send(error.localizedDescription)
        }
    }

    private func update(_ news: NewsPage) {
        items = news.items.map({ NewsListItemViewModel(news: $0) })
        updateContent()
    }

    private func updateContent() {
        contentSubject.send(items.isEmpty ? .emptyData : .items(items))
    }
}

extension DefaultNewsListViewModel {

    func viewDidLoad() {

    }

    func viewDidRefresh() {

    }
    
    func viewDidSelectItem(at index: Int) {
        guard case .items = contentSubject.value else { return }
        var item = items[index]
        item.isExpanded.toggle()
        items[index] = item
        print(items[index].news.title)
    }

    func didSearch(query: String) {
        guard !query.isEmpty else { return }
        querySubject.send(query)
    }

    func didCancelSearch() {
        querySubject.send("")
        resetData()
    }

    func didLoadNextPage() {
        guard hasMorePage else { return }
        Task { await loadNewsListData(query: querySubject.value) }
    }
}
