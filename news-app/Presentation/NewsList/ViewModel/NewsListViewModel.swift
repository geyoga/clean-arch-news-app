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

    // MARK: - Output

    private let contentSubject = CurrentValueSubject<NewsListContentViewModel, Never>(.emptyData)
    private let errorSubject = CurrentValueSubject<String, Never>("")

    var content: AnyPublisher<NewsListContentViewModel, Never> {
        contentSubject.eraseToAnyPublisher()
    }

    var error: AnyPublisher<String, Never> {
        errorSubject.eraseToAnyPublisher()
    }

    // MARK: - Init

    init(newsListUsesCase: NewsListUseCase) {
        self.newsListUsesCase = newsListUsesCase
    }

    // MARK: - Helpers

    private func reload() {
        resetData()
        Task { await loadData() }
    }

    private func resetData() {
        items.removeAll()
        contentSubject.send(.emptyData)
    }

    @MainActor
    private func loadData() {
        contentSubject.send(.loading)
        Task {
            do {
                let result = try await newsListUsesCase.fetchNewsList()
                update(result)
            } catch {
                handleError(error)
            }
        }
    }

    private func handleError(_ error: Error) {
        print(error.localizedDescription)
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
        reload()
    }
    
    func viewDidRefresh() {
        reload()
    }
    
    func viewDidSelectItem(at index: Int) {
        guard case .items = contentSubject.value else { return }
        var item = items[index]
        item.isExpanded.toggle()
        items[index] = item
        contentSubject.send(.items(items))
    }
}

final class MockNewsListViewModel: NewsListViewModel {

    // MARK: - Properties

    private let contentSubject = CurrentValueSubject<NewsListContentViewModel, Never>(.emptyData)
    private let errorSubject = CurrentValueSubject<String, Never>("")

    var content: AnyPublisher<NewsListContentViewModel, Never> {
        contentSubject.eraseToAnyPublisher()
    }

    var error: AnyPublisher<String, Never> {
        errorSubject.eraseToAnyPublisher()
    }

    private(set) var items: [NewsListItemViewModel] = []
    
    // MARK: - Methods
    
    func viewDidLoad() {
        loadMockData()
    }
    
    func viewDidRefresh() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
            self.loadMockData()
        })
    }
    
    func viewDidSelectItem(at index: Int) {
        guard index < items.count else { return }
        var item = items[index]
        item.isExpanded.toggle()
        items[index] = item
        print(items[index].news.title)
    }

    // MARK: - Mock Data

    private func loadMockData() {
        items = [
            NewsListItemViewModel(news: .init(id: 1, title: "Mock News 1", source: .init(name: "Mocker News ID"), description: "Hello World")),
            NewsListItemViewModel(news: .init(id: 2, title: "Mock News 2", source: .init(name: "Mocker News NA"), description: "Hello World Hello World Hello World Hello World")),
            NewsListItemViewModel(news: .init(id: 3, title: "Mock News 3", source: .init(name: "Mocker News SA"), description: "Hello World Hello World"))
        ]
        contentSubject.send(.items(items))
    }
}
