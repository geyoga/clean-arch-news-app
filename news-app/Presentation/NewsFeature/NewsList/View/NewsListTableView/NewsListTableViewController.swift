//
//  NewsListTableViewController.swift
//  news-app
//
//  Created by Georgius Yoga on 2/4/25.
//

import UIKit
import Combine

final class NewsListTableViewController: UITableViewController {

    // MARK: - Properties

    private enum Constants {
        static let numberOfLoadingShimmeringCells = 10
        static let generalSpacing = 16
    }

    private enum Section: Hashable {
        case main
    }

    private enum Cell: Hashable {
        case item(NewsListItemViewModel)
        case emptyData
        case loadingShimmer(index: Int)
        case loadingSpinner
    }

    private let viewModel: NewsListViewModel
    private let imageRepository: ImageRepository
    private var nextPageLoadingSpinner: UIActivityIndicatorView?
    private var registeredCellTypes: Set<String> = []
    private var cancellables = Set<AnyCancellable>()
    private var currentContent: NewsListContentViewModel = .emptyData
    private lazy var tableViewDataSource: UITableViewDiffableDataSource<Section, Cell> = {
        let dataSource = UITableViewDiffableDataSource<Section, Cell>(tableView: tableView) { [weak self] tableView, _, cellItem in
            guard let self = self else { return UITableViewCell() }
            return self.dequeueReusableCell(tableView, cell: cellItem)
        }

        return dataSource
    }()

    // MARK: - Life Cycles

    init(viewModel: NewsListViewModel,
         imageRepository: ImageRepository
    ) {
        self.viewModel = viewModel
        self.imageRepository = imageRepository
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupViews()
        self.setupBindings()
    }

    // MARK: - Helpers

    private func setupBindings() {
        self.viewModel.content
            .receive(on: DispatchQueue.main)
            .sink { [weak self] content in
                guard let self = self else { return }
                self.currentContent = content
                self.tableView.refreshControl?.endRefreshing()
                self.reload()
            }.store(in: &cancellables)
    }

    internal func reload() {
        self.updateSeparationStyle()
        self.updateItems()
    }

    private func updateSeparationStyle() {
        if case .items = self.currentContent {
            self.tableView.separatorStyle = .singleLine
        } else {
            self.tableView.separatorStyle = .none
        }
    }

    private func setupViews() {
        self.tableView.estimatedRowHeight = 80
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.contentInset = .init(top: CGFloat(Constants.generalSpacing), left: 0, bottom: 0, right: 0)
        self.refreshControl = UIRefreshControl()
        self.refreshControl?.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
    }

    internal func updateItems() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Cell>()

        snapshot.appendSections([.main])
        switch self.currentContent {
        case .items(let array):
            snapshot.appendItems(array.map({ .item($0) }), toSection: .main)
        case .emptyData:
            snapshot.appendItems([.emptyData], toSection: .main)
        case .loadingShimmer:
            let loadingItems: [Cell] = (0..<Constants.numberOfLoadingShimmeringCells).map {
                .loadingShimmer(index: $0)
            }
            snapshot.appendItems(loadingItems, toSection: .main)
        case .loadingSpinner:
            snapshot.appendItems([.loadingSpinner], toSection: .main)
        }

        self.tableViewDataSource.apply(snapshot, animatingDifferences: false)
    }

    @objc private func refresh(_ sender: Any) {
        self.viewModel.viewDidRefresh()
    }
}

// MARK: - Deque Reusable Cells

extension NewsListTableViewController {

    private func dequeueReusableCell(
        _ tableView: UITableView,
        cell: Cell
    ) -> UITableViewCell {
        switch cell {
        case .item(let item):
            let cell = tableView.dequeueReusableCell(
                NewsListItemCell.self,
                registeredCellTypes: &self.registeredCellTypes
            )
            cell.configure(
                with: item,
                imageRepository: imageRepository
            )
            return cell
        case .emptyData:
            return UITableViewCell()
        case .loadingShimmer:
            return UITableViewCell()
        case .loadingSpinner:
            return UITableViewCell()
        }
    }
}

// MARK: - Table View Delegate

extension NewsListTableViewController {

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if case .emptyData = self.currentContent {
            return tableView.frame.height * 0.8
        } else {
            return super.tableView(tableView, heightForRowAt: indexPath)
        }
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.viewModel.viewDidSelectItem(at: indexPath.row)
    }
}
