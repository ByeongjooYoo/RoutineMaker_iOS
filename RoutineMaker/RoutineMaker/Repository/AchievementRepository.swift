//
//  AchievementRepository.swift
//  RoutineMaker
//
//  Created by ByeongJu Yu on 2022/04/16.
//

import Foundation
import Firebase

protocol AchievementRepository {
    var dayAchievement: DayAchievement { get }
    func postAchievement(dayAchievement: DayAchievement)
    func updateAchievement(dayAchievement: DayAchievement)
    func requestAchievement(completion: () -> Void)
}

class AchievementRepositoryImpl: AchievementRepository {
    private let reference: DatabaseReference = Database.database().reference()

    var dayAchievement: DayAchievement = DayAchievement(dayAchivement: 0 , date: Date())
    
    func postAchievement(dayAchievement: DayAchievement) {
        let formatter = ISO8601DateFormatter()
        formatter.timeZone = .autoupdatingCurrent
        formatter.formatOptions = [.withFullDate]
        let date = formatter.string(from: dayAchievement.date)
        reference.child("user1").child("DayAchievementList").child(date).setValue(dayAchievement.dayAchivement)
    }
    
//    func getTodayDate() {
    //        let formatter = ISO8601DateFormatter()
    //        formatter.timeZone = .autoupdatingCurrent
    //        formatter.formatOptions = [.withFullDate]
    //        print(formatter.string(from: Date()))
    //    }
    
    func updateAchievement(dayAchievement: DayAchievement) {
        
    }
    
    func requestAchievement(completion: () -> Void) {
        
    }
}

class MockAchievementRepository: AchievementRepository {
    var dayAchievement: DayAchievement = DayAchievement(dayAchivement: 0 , date: Date())

    func postAchievement(dayAchievement: DayAchievement) {
        self.dayAchievement = dayAchievement
    }

    func updateAchievement(dayAchievement: DayAchievement) {
        self.dayAchievement = dayAchievement
    }

    func requestAchievement(completion: () -> Void) {
        completion()
    }
}


