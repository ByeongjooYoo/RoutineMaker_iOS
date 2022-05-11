//
//  AchievementRepository.swift
//  RoutineMaker
//
//  Created by ByeongJu Yu on 2022/04/16.
//

import Foundation

protocol AchievementRepository {
    var dayAchievement: DayAchievement { get }
    func postAchievement()
    func updateAchievement()
    func requestAchievement()
}

class AchievementRepositoryImpl: AchievementRepository {
    var dayAchievement: DayAchievement = DayAchievement(dayAchivement: 0 , date: Date())
    
    func postAchievement() {
        
    }
    
    func updateAchievement() {
        
    }
    
    func requestAchievement() {
        
    }
    
    
}
