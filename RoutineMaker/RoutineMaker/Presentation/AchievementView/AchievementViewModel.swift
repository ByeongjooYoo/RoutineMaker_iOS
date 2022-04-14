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
 
 firebase에서 오늘 성취도 데이터를 받아오는 함수: getDayAchievement
 firebase에서 최근 한 주 데이터를 받아오는 함수: getWeekAchievement
 firebase에서 최근 4달 데이터를 받아오는 함수: getMonthAchievement
 
 한달 평균 성취도를 계산하는 함수: calculateMonthAchievement
 오늘을 기준으로 일주일을 구하는 함수: getWeeks
 오늘을 기준으로 -3달을 구하는 함수: getMonths
 */

class AchievementViewModel {
    var dayAchievement: Float?
    
    var weekAchievement: [Double]?
    var weeks: [String]?
    
    var monthAchievement: [Double]?
    var months: [String]?
    
    var ref: DatabaseReference!

    func fectchDayAchievement(completion: @escaping (Float) -> Void) {
        ref = Database.database().reference()
        ref.child("user1").child("AchievementList").child(convertDateFormat(0)).observeSingleEvent(of: .value, with: { [self] snapshot in
            if snapshot.value is NSNull { return }
            guard let value = snapshot.value else {
                return
            }
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: value, options: [])
                let loadData = try JSONDecoder().decode(DayAchievement.self, from: jsonData)
                dayAchievement = Float(loadData.dayAchivement)
                completion(dayAchievement ?? 0.0)
                //print(dayAchievement)
            }  catch let error {
                print("Error JSON parsing: \(error.localizedDescription)")
            }
        }) { error in
            print(error.localizedDescription)
        }
    }
    
    func getWeekAchievement() {
        
    }
    
    func getMonthAchievement() {
        
    }
    
    func calculateMonthAchievement() {
        
    }
    
    func convertDateFormat(_ day: Int) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY_MM_dd_EEEE"
        dateFormatter.locale = Locale(identifier: "ko_KR")
        let date = Calendar.current.date(byAdding: .day, value: -(day), to: Date())
        let result = dateFormatter.string(from: date ?? Date())
        return result
    }
    
    func getWeeks() {
        
    }
    
    func getMonths() {
        
    }
}
