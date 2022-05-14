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
