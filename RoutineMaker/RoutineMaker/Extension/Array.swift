//
//  Array.swift
//  RoutineMaker
//
//  Created by ByeongJu Yu on 2022/05/11.
//

import Foundation

extension Array {
    public subscript(safe index: Int) -> Element? {
        0 <= index && index < endIndex ? self[index] : nil
    }
}
