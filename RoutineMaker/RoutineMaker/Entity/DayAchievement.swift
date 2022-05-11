//
//  DayAchievement.swift
//  RoutineMaker
//
//  Created by ByeongJu Yu on 2022/03/07.
//

import Foundation

struct DayAchievement: Codable {
    var dayAchivement: Double
    var date: Date
}

extension DayAchievement {
    var toDictionary: [String: Any] {
        return [
            "dayAchivement": dayAchivement,
            "date": date
        ]
    }
}
