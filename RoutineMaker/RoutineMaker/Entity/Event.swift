//
//  Event.swift
//  RoutineMaker
//
//  Created by ByeongJu Yu on 2022/02/10.
//

import Foundation

struct Event: Codable {
    var title: String
    var description: String
    var completion: Bool
    
    var toDictionary: [String: Any] {
        let dict: [String: Any] = ["title": title, "description": description, "completion" : completion]
        return dict
    }
}
