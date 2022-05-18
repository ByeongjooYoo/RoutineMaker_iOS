//
//  WeakRef.swift
//  RoutineMaker
//
//  Created by ByeongJu Yu on 2022/05/14.
//

import Foundation

class WeakRef<T: AnyObject> {
    private(set) weak var value: T?
    
    init(value: T) {
        self.value = value
    }
}

class WeakRefArray<T: AnyObject> {
    private var weakRefValues: [WeakRef<T>] = []

    func append(_ value: T) {
        weakRefValues.append(WeakRef(value: value))
    }
}

extension WeakRefArray {
    var values: [T] {
        let newWeakRefValues = weakRefValues.compactMap { $0.value != nil ? $0 : nil }
        weakRefValues = newWeakRefValues

        return newWeakRefValues.compactMap(\.value)
    }
}
