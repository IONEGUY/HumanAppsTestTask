//
//  UITableView+Ext.swift
//  HumanAppsTestTask
//
//  Created by lifetech on 5.02.2025.
//

import UIKit

extension UITableView {
    func dequeueReusableCell(reuseIdentifier: String, for indexPath: IndexPath) -> any ModelledCell {
        guard let cell = dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as? any ModelledCell else {
            fatalError("Unable to Dequeue Cell of type \(reuseIdentifier)")
        }
        
        return cell
    }
    
    func checkIfCellNotRegistered(with identifier: String) -> Bool {
        dequeueReusableCell(withIdentifier: identifier) == nil
    }
}
