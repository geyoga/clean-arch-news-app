//
//  UITableView+DequeReusableCell.swift
//  news-app
//
//  Created by Georgius Yoga on 2/4/25.
//

import UIKit

extension UITableView {
    
    func dequeueReusableCell<Cell: UITableViewCell>(
        _ cellType: Cell.Type,
        registeredCellTypes: inout Set<String>
    ) -> Cell {
        let identifier = String(describing: cellType)
        if !registeredCellTypes.contains(identifier) {
            register(cellType, forCellReuseIdentifier: identifier)
            registeredCellTypes.insert(identifier)
        }
        let dequeuedCell = dequeueReusableCell(
            withIdentifier: identifier
        )
        guard let cell = dequeuedCell as? Cell else {
            assertionFailure(
                "Cannot dequeue reusable cell \(UITableViewCell.self) with reuseIdentifier: \(identifier)"
            )
            return Cell()
        }
        return cell
    }
}
