//
//  ViewModel.swift
//  RoutineMaker
//
//  Created by ByeongJu Yu on 2022/05/14.
//

import Foundation

@propertyWrapper
class ViewModelState<T> {
    typealias WillUpdate = (T) -> Void
    typealias DidUpdate = (T) -> Void
    
    var willUpdate: WillUpdate?
    var didUpdate: DidUpdate?
    
    var wrappedValue: T {
        willSet {
            willUpdate?(newValue)
        }
        didSet {
            didUpdate?(wrappedValue)
        }
    }
    
    var projectedValue: ViewModelState<T> {
        self
    }
    
    init(wrappedValue initialValue: T) {
        wrappedValue = initialValue
    }
}
