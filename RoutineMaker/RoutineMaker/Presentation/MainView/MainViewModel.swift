//
//  MainViewModel.swift
//  RoutineMaker
//
//  Created by ByeongJu Yu on 2022/04/14.
//

import Foundation
import Firebase

/*
 todoEventList: [Event]
 completedEventList: [Event]
 dayAchievement: DayAchievement
 isRunToday: Bool
 
 성취도 계산하는 함수:
 체크박스 탭 이벤트 처리: didChangedEventCompletion
 
 firebase에 Event 데이터 쓰기: updateEventList
 firebase에서 Event 데이터 가지고 오기: fetchEventList
 
 firbase에 성취도 데이터 쓰기: updateAchievement
 firebase에서 성취도 데이터 가지고 오기: fetchAchievement
 
 */

class MainViewModel {
    var todoEventList: [Event] = [] {
        didSet {
            dayAchievement?.dayAchivement = computedAchivement()
            updateEventList()
        }
    }
    
    var completedEventList: [Event] = [] {
        didSet {
            dayAchievement?.dayAchivement = computedAchivement()
            updateEventList()
        }
    }
    
    var dayAchievement: DayAchievement? {
        didSet {
            updateAchievement()
        }
    }
    
    var ref: DatabaseReference!
    var isRunToday: Bool = true
    
    func didChangedEventState(_ done: Bool, _ index: Int) {
        if done {
            var event = todoEventList[index]
            event.completion = true
            todoEventList.remove(at: index)
            completedEventList.append(event)
        } else {
            var event = completedEventList[index]
            event.completion = false
            completedEventList.remove(at: index)
            todoEventList.append(event)
        }
    }
    
    func computedAchivement() -> Double {
        let todoEventCount = todoEventList.count
        let completioneventCount = completedEventList.count
        if todoEventCount + completioneventCount == 0 { return 0.0 }
        let result = Double(completioneventCount) / (Double(todoEventCount) + Double(completioneventCount))
        return round(result * 100) / 100
    }
    
    func updateEventList() {
        let eventList = (todoEventList + completedEventList).map { $0.toDictionary }
        ref = Database.database().reference()
        ref.child("user1").child("EventList").setValue(eventList)
    }
    
    func fetchEventList(completion: @escaping () -> Void) {
        ref = Database.database().reference()
        ref.child("user1").child("EventList").observeSingleEvent(of: .value, with: {[self] snapshot in
            guard let value = snapshot.value as? [Any] else { print("Firebase Data Empty")
                return }
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: value)
                let eventList = try JSONDecoder().decode([Event].self, from: jsonData)
                var todoEvent = Array<Event>()
                var completedEvent = Array<Event>()
                switch isRunToday {
                case true:
                    eventList.forEach { event in
                        if event.completion {
                            completedEvent.append(event)
                        } else {
                            todoEvent.append(event)
                        }
                    }
                case false:
                    eventList.forEach { event in
                        var event = event
                        event.completion = false
                        todoEvent.append(event)
                    }
                }
                todoEventList = todoEvent
                completedEventList = completedEvent
                completion()
            }  catch let error {
                print("Error JSON parsing: \(error.localizedDescription)")
            }
        }) { error in
          print(error.localizedDescription)
        }
    }
    
    func updateAchievement() {
        guard let dayAchievement = dayAchievement else { return }
        ref = Database.database().reference()
        ref.child("user1").child("AchievementList").child(dayAchievement.date).setValue(dayAchievement.toDictionary)
    }
    
    func fetchAchievement(completion: @escaping () -> Void) {
//        dayAchievement = DayAchievement(dayAchivement: 0.0, date: convertDateFormat(0, "YYYY_MM_dd_EEEE", .day))
        ref = Database.database().reference()
        ref.child("user1").child("AchievementList").child(convertDateFormat(0, "YYYY_MM_dd_EEEE", .day)).observeSingleEvent(of: .value, with: { [self] snapshot in
            if snapshot.value is NSNull {
                isRunToday = false
                fetchEventList { completion() }
                dayAchievement = DayAchievement(dayAchivement: 0.0, date: convertDateFormat(0, "YYYY_MM_dd_EEEE", .day))
                return
            } else {
                fetchEventList { completion() }
            }
            
            guard let value = snapshot.value else {
                return
            }
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: value, options: [])
                let loadData = try JSONDecoder().decode(DayAchievement.self, from: jsonData)
                dayAchievement = loadData
            }  catch let error {
                print("Error JSON parsing: \(error.localizedDescription)")
            }
            completion()
        }) { error in
            print(error.localizedDescription)
        }
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
