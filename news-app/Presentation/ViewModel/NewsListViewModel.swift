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
        loadData()
    }

    private func resetData() {
        items.removeAll()
        contentSubject.send(.emptyData)
    }

    private func loadData() {
        contentSubject.send(.loading)
        Task {
            await fetchData()
        }
    }
    
    private func fetchData() async {
        do {
            let items = try await newsListUsesCase.fetchNewsList()
            update(items)
        } catch {
            
        }
    }
    

    private func handleError(_ error: Error) {
        
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
