//
//  SettingsScreenViewController.swift
//  HumanAppsTestTask
//
//  Created by lifetech on 5.02.2025.
//

import UIKit

final class SettingsViewController: BaseViewController<SettingsViewModel> {
    override var navBarTitle: String { GlobalConstants.settingsTabTitle }
    
    private lazy var tableView = ReactiveTableView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayout()
        setupNavigationBar()
    }
    
    override func setupBindings() {
        super.setupBindings()
        
        viewModel.cellViewModelsObservable.notifyObservers()
        
        viewModel.cellViewModelsObservable
            .bind { [weak self] in
                self?.tableView.items.value = $0
            }
    }
}

// MARK: - Private
private extension SettingsViewController {
    private func setupLayout() {
        view.addSubview(tableView)

        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
