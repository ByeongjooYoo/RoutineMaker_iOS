//
//  AchievementUseCase.swift
//  RoutineMaker
//
//  Created by ByeongJu Yu on 2022/05/18.
//

import Foundation

protocol AchievementUseCase {
    func calculateAchievement(incompletedEventCount: Int, completedEventCount: Int) -> Double
    func getDayAchievement(completion: @escaping (DayAchievement) -> Void)
}

class AchievementUseCaseImpl: AchievementUseCase {
    
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
    
    func getDayAchievement(completion: @escaping (DayAchievement) -> Void) {
        achievementRepository.requestAchievement(by: getTodayDate(date: Date())) { dayAchievement in
            completion(dayAchievement)
        }
    }
    
    func getTodayDate(date: Date) -> String {
        let formatter = ISO8601DateFormatter()
        formatter.timeZone = .autoupdatingCurrent
        formatter.formatOptions = [.withFullDate]
        return formatter.string(from: date)
    }
}

extension AchievementUseCaseImpl : EventListUseCaseDelegate {
    func checkLauchApp(completion: @escaping (Bool) -> Void) {
        achievementRepository.checkDayAchievement(by: getTodayDate(date: Date())) { isLaunch in
            completion(isLaunch)
        }
    }
    
    func eventDidAdd() { }
    
    func eventDidUpdate(incompletedEventCount: Int, completedEventCount: Int) {
        let newAchievement = calculateAchievement(incompletedEventCount: incompletedEventCount, completedEventCount: completedEventCount)
        achievementRepository.postAchievement(dayAchievement: DayAchievement(dayAchivement: newAchievement, date: getTodayDate(date: Date())))
    }
}
