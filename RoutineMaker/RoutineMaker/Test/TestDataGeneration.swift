//
//  TestDataGeneration.swift
//  RoutineMaker
//
//  Created by ByeongJu Yu on 2022/02/25.
//

import Foundation
import Firebase

class TestDataGeneration {
    
    var ref: DatabaseReference!
    var testcaseCount: Int
    
    init(testcaseCount: Int) {
        self.testcaseCount = testcaseCount
    }
    
    func addTestData() {
        for number in 1 ... testcaseCount {
            let data = makeRandomTestData(number: number)
            updateDayAchievementData(dayAchievement: data)
        }
    }
    
    // TODO: ReFactoring 필요
    func getDate(number: Int) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY_MM_dd_EEEE"
        dateFormatter.locale = Locale(identifier: "ko_KR")
        let date = Calendar.current.date(byAdding: .day, value: -(number), to: Date())
        let result = dateFormatter.string(from: date ?? Date())
        return result
    }

    func makeRandomTestData(number: Int) -> DayAchievement {
        let achievement = Double(Int.random(in: 0 ... 100))  / 100.0
        let date = getDate(number: number)
        return DayAchievement(dayAchivement: achievement, date: date)
    }
    
    func updateDayAchievementData(dayAchievement: DayAchievement) {
        ref = Database.database().reference()
        ref.child("user1").child("AchievementList").child(dayAchievement.date).setValue(dayAchievement.toDictionary)
    }
}
