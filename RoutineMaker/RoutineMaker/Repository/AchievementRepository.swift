//
//  AchievementRepository.swift
//  RoutineMaker
//
//  Created by ByeongJu Yu on 2022/04/16.
//

import Foundation
import Firebase

protocol AchievementRepository {
//    var dayAchievement: DayAchievement { get }
    func postAchievement(dayAchievement: DayAchievement)
    func updateAchievement(dayAchievement: DayAchievement)
    func requestAchievement(by date: String, completion: @escaping (DayAchievement) -> Void)
}

class AchievementRepositoryImpl: AchievementRepository {
    private let reference: DatabaseReference = Database.database().reference()
//    var dayAchievement: DayAchievement?
    
    func postAchievement(dayAchievement: DayAchievement) {
        reference.child("user1").child("DayAchievementList").child(dayAchievement.date).setValue(dayAchievement.toDictionary)
    }
    
    func updateAchievement(dayAchievement: DayAchievement) {
        
    }
    
    func requestAchievement(by date: String, completion: @escaping (DayAchievement) -> Void) {
        reference.child("user1").child("DayAchievementList").child(date).observeSingleEvent(of: .value, with: { snapshot in
            guard let value = snapshot.value else {
                print("Firebase Data Empty")
                return
            }
            do {
                if value is NSNull {
                    print("RequestAchievement: Null!")
                } else {
                    let jsonData = try JSONSerialization.data(withJSONObject: value)
                    let achievement = try JSONDecoder().decode(DayAchievement.self, from: jsonData)
                    print("RequestAchievement\(achievement)")
                    completion(achievement)
                }
            }  catch let error {
                print("Error JSON parsing: \(error.localizedDescription)")
            }
        }) { error in
            print(error.localizedDescription)
        }
    }
    
    func getTodayDate() -> String {
        let formatter = ISO8601DateFormatter()
        formatter.timeZone = .autoupdatingCurrent
        formatter.formatOptions = [.withFullDate]
        return formatter.string(from: Date())
    }
}
