//
//  DayEvent.swift
//  RoutineMaker
//
//  Created by ByeongJu Yu on 2022/02/15.
//

import Foundation

struct DayEventData: Codable {
    var todoEventList: [Event]
    var completionEventList: [Event]
    var todayAchivement: Double {
        if todoEventList.count + completionEventList.count == 0 {
            return 0.0
        }
        let result = Double(completionEventList.count) / (Double(todoEventList.count) + Double(completionEventList.count))
        return round(result * 100) / 100
    }
    
    var date: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY_MM_dd_EEEE"
        dateFormatter.locale = Locale(identifier: "ko_KR")
        let date = dateFormatter.string(from: Date())
        return date
    }
    
    var toDictionary: [String: Any] {
        let todoArray = todoEventList.map { $0.toDictionary }
        let completionArray = completionEventList.map { $0.toDictionary }
        let dict: [String: Any] = ["todoEventList": todoArray, "completionEventList": completionArray, "todayAchivement": todayAchivement,"date": date]
        return dict
    }
    
    static var id: Int = 0
}
