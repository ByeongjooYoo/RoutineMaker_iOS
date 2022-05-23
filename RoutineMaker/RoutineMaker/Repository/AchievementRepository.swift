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
    
    @Dependency
    private var eventRepository: EventRepository
//    var dayAchievement: DayAchievement?
    init() {
        eventRepository.setDelegate(delegate: self)
    }
    
    
    func postAchievement(dayAchievement: DayAchievement) {
        reference.child("user1").child("DayAchievementList").child(dayAchievement.date).setValue(dayAchievement.toDictionary)
    }
    
//    func getTodayDate() {
    //        let formatter = ISO8601DateFormatter()
    //        formatter.timeZone = .autoupdatingCurrent
    //        formatter.formatOptions = [.withFullDate]
    //        print(formatter.string(from: Date()))
    //    }
    
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

extension AchievementRepositoryImpl: EventRepositoryDelegate {
    func isLaunchAppToday(completion: @escaping (Bool) -> Void) {
        reference.child("user1").child("DayAchievementList").child(getTodayDate()).observeSingleEvent(of: .value, with: { snapshot in
            guard let value = snapshot.value else {
                print("Firebase Data Empty")
                return
            }
            do {
                if value is NSNull {
                    completion(false)
                } else {
                    completion(true)
                }
            }  catch let error {
                print("Error JSON parsing: \(error.localizedDescription)")
            }
        }) { error in
            print(error.localizedDescription)
        }
    }
}
