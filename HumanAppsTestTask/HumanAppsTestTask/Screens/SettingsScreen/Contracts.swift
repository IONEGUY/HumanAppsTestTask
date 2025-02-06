//
//  Contracts.swift
//  HumanAppsTestTask
//
//  Created by lifetech on 5.02.2025.
//

import UIKit

protocol CellViewModelType {
    var reuseIdentifier: String { get }
    var cellViewClass: UITableViewCell.Type { get }
}

extension CellViewModelType {
    var reuseIdentifier: String { String(describing: self) }
}

protocol ModelledCell {
    func define(viewModel: CellViewModelType)
}
