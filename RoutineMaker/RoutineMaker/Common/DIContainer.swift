//
//  DIContainer.swift
//  RoutineMaker
//
//  Created by ByeongJu Yu on 2022/05/11.
//

import Foundation

// MARK: - DIContainer
class DIContainer {
    static let instance = DIContainer()
    
    private var values: [String: Any] = [:]
    
    private init() {}
    
    func register<T>(value: T, type: T.Type) {
        let typeKey = String(describing: type)
        values[typeKey] = value
    }
    
    func get<T>(type: T.Type) -> T {
        let typeKey = String(describing: type)
        
        guard let value = values[typeKey] as? T else {
            fatalError("등록되지 않은 객체임")
        }
        
        return value
    }
}

// MARK: - Dependency
@propertyWrapper
struct Dependency<T> {
    private(set) var wrappedValue: T
    
    init() {
        wrappedValue = DIContainer.instance.get(type: T.self)
    }
}
