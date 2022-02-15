//
//  DayEvent.swift
//  RoutineMaker
//
//  Created by ByeongJu Yu on 2022/02/15.
//

import Foundation

struct DayEventData {
    var todoEventList: [Event]
    var completionEventList: [Event]
    var todayAchivement: Double
    var date: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY.MM.dd EEEE"
        dateFormatter.locale = Locale(identifier: "ko_KR")
        let date = dateFormatter.string(from: Date())
        return date
    }
}
