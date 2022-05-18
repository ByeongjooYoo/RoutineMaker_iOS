//
//  AchievementUseCase.swift
//  RoutineMaker
//
//  Created by ByeongJu Yu on 2022/05/18.
//

import Foundation

protocol AchievementUseCase {
    func calculateAchievement(incompletedEventCount: Int, completedEventCount: Int)
}

class AchievementUseCaseImpl: AchievementUseCase {
    
    
    func calculateAchievement(incompletedEventCount: Int, completedEventCount: Int){
        let achievement = incompletedEventCount + completedEventCount == 0 ? 0 : round(Double(completedEventCount) / (Double(incompletedEventCount) + Double(completedEventCount)) * 100) / 100
        print(achievement)
    }
}



//    func calculateAchievement() {
//        let incompletedEventCount = countOfEvent(isCompleted: false)
//        let completedEventCount = countOfEvent(isCompleted: true)
//        let achievement = incompletedEventCount + completedEventCount == 0 ? 0 : round(Double(completedEventCount) / (Double(incompletedEventCount) + Double(completedEventCount)) * 100) / 100
//        print(achievement)
//    }
//
//    func getTodayDate() {
//        let formatter = ISO8601DateFormatter()
//        formatter.timeZone = .autoupdatingCurrent
//        formatter.formatOptions = [.withFullDate]
//        print(formatter.string(from: Date()))
//    }
