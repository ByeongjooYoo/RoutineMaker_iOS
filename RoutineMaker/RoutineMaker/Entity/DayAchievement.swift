//
//  DayAchievement.swift
//  RoutineMaker
//
//  Created by ByeongJu Yu on 2022/03/07.
//

import Foundation

struct DayAchievement: Codable {
    var dayAchivement: Double
    var date: String
    
    var toDictionary: [String: Any] {
        let dict: [String: Any] = ["dayAchivement": dayAchivement, "date": date]
        return dict
    }
}
