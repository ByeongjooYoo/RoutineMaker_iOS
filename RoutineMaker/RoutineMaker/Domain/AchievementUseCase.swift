//
//  AchievementUseCase.swift
//  RoutineMaker
//
//  Created by ByeongJu Yu on 2022/05/18.
//

import Foundation

protocol AchievementUseCase {
    func calculateAchievement(incompletedEventCount: Int, completedEventCount: Int) -> Double
    func getDayAchievement() -> DayAchievement
}

class AchievementUseCaseImpl: AchievementUseCase {
    var dayAchievement: DayAchievement = DayAchievement(dayAchivement: 0.0, date: Date())
    
    @Dependency
    private var eventListUseCase: EventListUseCase
    
    @Dependency
    private var achievementRepository: AchievementRepository
    
    init() {
        eventListUseCase.addDelegate(delegate: self)
    }
    
    func calculateAchievement(incompletedEventCount: Int, completedEventCount: Int) -> Double {
        let achievement = incompletedEventCount + completedEventCount == 0 ? 0 : round(Double(completedEventCount) / (Double(incompletedEventCount) + Double(completedEventCount)) * 100) / 100
        return achievement
    }
    
    func getDayAchievement() -> DayAchievement {
        achievementRepository.dayAchievement
    }
}

extension AchievementUseCaseImpl : EventListUseCaseDelegate {
    func eventDidAdd() { }
    
    func eventDidUpdate(incompletedEventCount: Int, completedEventCount: Int) {
        let newAchievement = calculateAchievement(incompletedEventCount: incompletedEventCount, completedEventCount: completedEventCount)
        achievementRepository.postAchievement(dayAchievement: DayAchievement(dayAchivement: newAchievement, date: Date()))
    }
}

//    func getTodayDate() {
//        let formatter = ISO8601DateFormatter()
//        formatter.timeZone = .autoupdatingCurrent
//        formatter.formatOptions = [.withFullDate]
//        print(formatter.string(from: Date()))
//    }
