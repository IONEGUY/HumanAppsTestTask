//
//  BaseViewModel.swift
//  HumanAppsTestTask
//
//  Created by lifetech on 5.02.2025.
//

import Foundation

class BaseViewModel {
    private(set) var alertMessage = Observable<(title: String?, description: String?)?>(nil)
}
