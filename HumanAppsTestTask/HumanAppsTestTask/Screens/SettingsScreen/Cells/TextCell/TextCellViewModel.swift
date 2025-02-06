//
//  TextCellViewModel.swift
//  HumanAppsTestTask
//
//  Created by lifetech on 5.02.2025.
//

import UIKit

final class TextCellViewModel {
    var title: String
    var didTapAction: (() -> Void)?
    
    init(title: String, didTapAction: (() -> Void)? = nil) {
        self.title = title
        self.didTapAction = didTapAction
    }
}

extension TextCellViewModel: CellViewModelType {
    var cellViewClass: UITableViewCell.Type { TextCell.self }
}
