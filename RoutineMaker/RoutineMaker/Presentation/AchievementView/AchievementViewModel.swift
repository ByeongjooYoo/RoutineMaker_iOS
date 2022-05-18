//
//  AchievementViewModel.swift
//  RoutineMaker
//
//  Created by ByeongJu Yu on 2022/04/14.
//

import Foundation
import Firebase
/*
 todayAchievement: Double
 weekAchievement: [Double]
 week 날짜: [String]
 
 monthAchievement: [Double]
 month 날짜: [String]
 
 firebase에서 오늘 성취도 데이터를 받아오는 함수: fetchDayAchievement
 firebase에서 최근 한 주 데이터를 받아오는 함수: fetchWeekAchievement
 firebase에서 최근 4달 데이터를 받아오는 함수: fetchMonthAchievement
 
 한달 평균 성취도를 계산하는 함수: calculateMonthAchievement
 
 */

class AchievementViewModel {
    @Dependency
    private var achievementUseCase: AchievementUseCase
    
    var ref: DatabaseReference!
    var dayAchievement: Float?
    
    var weekAchievement: [Double]?
    var weeks: [String] {
        var result: [String] = []
        for number in (0 ..< 7).reversed() {
            let day = ""
            result.append(day)
        }
        return result
    }
    
    var monthAchievement: [Double]?
    var months: [String] {
        var result: [String] = []
        for number in (0 ..< 4).reversed() {
            let month = ""
            result.append(month)
        }
        return result
    }
    
    func fetchDayAchievement(completion: @escaping (Float) -> Void) {
        let achievement = Float(achievementUseCase.getDayAchievement().dayAchivement)
        completion(achievement)
    }
    
    func fetchWeekAchievement(completion: @escaping ([Double]) -> Void) {
        
    }
    
    func fetchMonthAchievement(completion: @escaping ([Double]) -> Void) {

    }
    
}
