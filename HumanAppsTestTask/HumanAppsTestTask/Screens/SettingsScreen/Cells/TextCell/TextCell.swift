//
//  TextCell.swift
//  HumanAppsTestTask
//
//  Created by lifetech on 5.02.2025.
//

import UIKit

class TextCell: UITableViewCell, ModelledCell {
    private var viewModel: TextCellViewModel?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupGesture()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setupGesture()
    }
    
    func define(viewModel: CellViewModelType) {
        self.viewModel = viewModel as? TextCellViewModel
        
        textLabel?.text = self.viewModel?.title
    }
    
    private func setupGesture() {
        contentView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTap)))
    }
    
    @objc private func didTap() {
        viewModel?.didTapAction?()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        textLabel?.text = nil
    }
}
