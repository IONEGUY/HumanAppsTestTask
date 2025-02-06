//
//  Collection+Ext.swift
//  HumanAppsTestTask
//
//  Created by lifetech on 5.02.2025.
//

extension Collection {
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
