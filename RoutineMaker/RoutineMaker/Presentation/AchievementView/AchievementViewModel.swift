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
    var dayAchievement: Float?
    
    var weekAchievement: [Double]?
    var weeks: [String] {
        var result: [String] = []
        for number in (0 ..< 7).reversed() {
            let day = convertDateFormat(number, "M/d(E)", .day)
            result.append(day)
        }
        return result
    }
    
    var monthAchievement: [Double]?
    var months: [String] {
        var result: [String] = []
        for number in (0 ..< 4).reversed() {
            let month = convertDateFormat(number, "YYYY_MM", .month)
            result.append(month)
        }
        return result
    }
    
    var ref: DatabaseReference!

    func fetchDayAchievement(completion: @escaping (Float) -> Void) {
        ref = Database.database().reference()
        ref.child("user1").child("AchievementList").child(convertDateFormat(0, "YYYY_MM_dd_EEEE", .day)).observeSingleEvent(of: .value, with: { [self] snapshot in
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
    
    func fetchWeekAchievement(completion: @escaping ([Double]) -> Void) {
        ref = Database.database().reference()
        ref.child("user1").child("AchievementList").observeSingleEvent(of: .value, with: { [self] snapshot in
            if snapshot.value is NSNull { return }
            guard let value = snapshot.value else {
                return
            }
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: value, options: [])
                let loadData = try JSONDecoder().decode([String: DayAchievement].self, from: jsonData)
                
                var dateArray: [String] = []
                var dataArray: [Double] = []
                for i in (0 ..< 7).reversed() {
                    dateArray.append(convertDateFormat(i, "YYYY_MM_dd_EEEE", .day))
                }
                for date in dateArray {
                    dataArray.append(loadData[date]?.dayAchivement ?? 0.0)
                }
                weekAchievement = dataArray
                completion(weekAchievement ?? [])
            }  catch let error {
                print("Error JSON parsing: \(error.localizedDescription)")
            }
        }) { error in
            print(error.localizedDescription)
        }
    }
    
    func fetchMonthAchievement(completion: @escaping (Float) -> Void) {
        
    }
    
    func calculateMonthAchievement() {
        
    }
    
    func convertDateFormat(_ day: Int, _ format: String, _ component: Calendar.Component) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.locale = Locale(identifier: "ko_KR")
        let date = Calendar.current.date(byAdding: component, value: -(day), to: Date())
        let result = dateFormatter.string(from: date ?? Date())
        return result
    }
}
