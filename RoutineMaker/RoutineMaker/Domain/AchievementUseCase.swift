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
    @Dependency
    private var eventListUseCase: EventListUseCase
    
    init() {
        eventListUseCase.addDelegate(delegate: self)
    }
    
    func calculateAchievement(incompletedEventCount: Int, completedEventCount: Int){
        let achievement = incompletedEventCount + completedEventCount == 0 ? 0 : round(Double(completedEventCount) / (Double(incompletedEventCount) + Double(completedEventCount)) * 100) / 100
        print(achievement)
    }
}

extension AchievementUseCaseImpl : EventListUseCaseDelegate {
    func eventDidAdd() { }
    
    func eventDidUpdate(incompletedEventCount: Int, completedEventCount: Int) {
        calculateAchievement(incompletedEventCount: incompletedEventCount, completedEventCount: completedEventCount)
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
