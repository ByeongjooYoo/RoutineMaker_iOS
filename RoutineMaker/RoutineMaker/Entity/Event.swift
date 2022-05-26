//
//  Event.swift
//  RoutineMaker
//
//  Created by ByeongJu Yu on 2022/02/10.
//

import Foundation

struct Event: Codable, Equatable {
    var id: String
    var title: String
    var description: String
    var isCompleted: Bool
}

extension Event {
    var toDictionary: [String: Any] {
        return [
            "id": id,
            "title": title,
            "description": description,
            "isCompleted" : isCompleted
        ]
    }
}
