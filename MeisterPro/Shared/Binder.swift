//
//  Binder.swift
//  MeisterPro
//
//  Created by Apple Macbook on 02/02/2023.
//

import Foundation

class Binder<T> {
    typealias Handler = (T) -> Void
    private var handlers:[Handler] = []
    
    var value: T {
        didSet {
            self.fire()
        }
    }
    
    init(_ value: T) {
        self.value = value
    }

    func bindAndFire(_ listener:@escaping Handler) {
        self.bind(listener)
        self.fire()
    }

    func bind(_ listener:@escaping Handler) {
        self.handlers.append(listener)
    }
    
    private func fire() {
        for handler in self.handlers {
            handler(value)
        }
    }
}

