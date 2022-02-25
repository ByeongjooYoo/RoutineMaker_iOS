//
//  DayEvent.swift
//  RoutineMaker
//
//  Created by ByeongJu Yu on 2022/02/15.
//

import Foundation

struct DayEventData: Codable {
    var eventList: [Event]
    
    var todayAchivement: Double
    
    var date: String
    
    var toDictionary: [String: Any] {
        let todoArray = eventList.map { $0.toDictionary }
        
        let dict: [String: Any] = ["eventList": todoArray, "todayAchivement": todayAchivement,"date": date]
        return dict
    }
    
    static var id: Int = 0
}
