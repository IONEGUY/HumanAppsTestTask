//
//  Observable.swift
//  HumanAppsTestTask
//
//  Created by lifetech on 5.02.2025.
//

import Foundation

class Observable<T> {
    private var observers: [(T) -> Void] = []

    var value: T {
        didSet {
            DispatchQueue.main.async { [weak self] in
                self?.notifyObservers()
            }
        }
    }

    init(_ value: T) {
        self.value = value
    }

    func bind(observer: @escaping (T) -> Void) {
        observers.append(observer)
        observer(value)
    }

    func notifyObservers() {
        observers.forEach { $0(value) }
    }
}
