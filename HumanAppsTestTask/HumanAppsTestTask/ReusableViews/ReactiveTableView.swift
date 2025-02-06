//
//  ReactiveTableView.swift
//  HumanAppsTestTask
//
//  Created by lifetech on 5.02.2025.
//

import UIKit

final class ReactiveTableView: UITableView {
    var items = Observable<[CellViewModelType]?>(nil)
    
    private var isCellsRegistered = false
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        backgroundColor = .clear
        delegate = self
        dataSource = self
        allowsSelection = false
        
        items.bind { [weak self] items in
            guard let self, let items else { return }
            
            registerCellsIfNeeded(items)
            reloadData()
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func registerCellsIfNeeded(_ items: [CellViewModelType]) {
        if isCellsRegistered { return }
        isCellsRegistered.toggle()
        
        items.forEach {
            if checkIfCellNotRegistered(with: $0.reuseIdentifier) {
                register($0.cellViewClass, forCellReuseIdentifier: $0.reuseIdentifier)
            }
        }
    }
}

extension ReactiveTableView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items.value?.count ?? .zero
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard isCellsRegistered, let cellViewModel = items.value?[safe: indexPath.row] else { return UITableViewCell() }
        
        let cell: any ModelledCell = tableView.dequeueReusableCell(reuseIdentifier: cellViewModel.reuseIdentifier, for: indexPath)
        cell.define(viewModel: cellViewModel)

        return (cell as? UITableViewCell) ?? UITableViewCell()
    }
}
