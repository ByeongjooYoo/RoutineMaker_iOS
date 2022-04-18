//
//  MainViewModel.swift
//  RoutineMaker
//
//  Created by ByeongJu Yu on 2022/04/14.
//

import Foundation
import Firebase

class MainViewModel {
    private let eventListUseCase: EventListUseCase
    
    // TODO: 개선필요
    var todoEventList: [Event] = [] {
        didSet {
//            dayAchievement?.dayAchivement = computedAchivement()
//            updateEventList()
//            print("mainViewModel.todoEventList")
        }
    }
    
    // TODO: 개선필요
    var completedEventList: [Event] = [] {
        didSet {
//            dayAchievement?.dayAchivement = computedAchivement()
//            updateEventList()
//            print("mainViewModel.completedEventList")

        }
    }
    
    var dayAchievement: DayAchievement? {
        didSet {
//            updateAchievement()
        }
    }
    
    var ref: DatabaseReference!
    var isRunToday: Bool = true
    
    init(eventListUseCase: EventListUseCase) {
        self.eventListUseCase = eventListUseCase
    }

    // TODO: 개선필요
    func didChangedEventState(_ done: Bool, _ index: Int, completion: @escaping () -> Void) {
//        if done {
//            var event = todoEventList[index]
//            event.isCompleted = true
//            todoEventList.remove(at: index)
//            completedEventList.append(event)
//        } else {
//            var event = completedEventList[index]
//            event.isCompleted = false
//            completedEventList.remove(at: index)
//            todoEventList.append(event)
//        }
        
        
        let event = done ? completedEventList[index] : todoEventList[index]
        let eventID = event.id
        eventListUseCase.updateIsCompletedOfEvent(to: !event.isCompleted, byID: eventID) {
            self.fetchEventList(completion: completion)
        }
        print("didChangedEventState")
    }
    
    func deleteEventButtonDidClick(section: Int, row: Int, completion: @escaping () -> Void) {
        let event = section == 0 ? todoEventList[row] : completedEventList[row]
        let eventID = event.id
        eventListUseCase.deleteEvent(byID: eventID) {
            self.fetchEventList(completion: completion)
        }
    }
    
    func computedAchivement() -> Double {
//        let todoEventCount = todoEventList.count
//        let completioneventCount = completedEventList.count
//        if todoEventCount + completioneventCount == 0 { return 0.0 }
//        let result = Double(completioneventCount) / (Double(todoEventCount) + Double(completioneventCount))
//        return round(result * 100) / 100
        return 0.0
    }
    
    func updateEventList() {
//        let eventList = (todoEventList + completedEventList).map { $0.toDictionary }
//        ref = Database.database().reference()
//        ref.child("user1").child("EventList").setValue(eventList)
    }
    
    func fetchEventList(completion: @escaping () -> Void) {
        eventListUseCase.fetchEventList { eventList in
            self.todoEventList = eventList.incompleted
            self.completedEventList = eventList.completed
            
            completion()
        }
        
        
//        ref = Database.database().reference()
//        ref.child("user1").child("EventList").observeSingleEvent(of: .value, with: {[self] snapshot in
//            guard let value = snapshot.value as? [Any] else { print("Firebase Data Empty")
//                return }
//            do {
//                let jsonData = try JSONSerialization.data(withJSONObject: value)
//                let eventList = try JSONDecoder().decode([Event].self, from: jsonData)
//                var todoEvent = Array<Event>()
//                var completedEvent = Array<Event>()
//                switch isRunToday {
//                case true:
//                    eventList.forEach { event in
//                        if event.isCompleted {
//                            completedEvent.append(event)
//                        } else {
//                            todoEvent.append(event)
//                        }
//                    }
//                case false:
//                    eventList.forEach { event in
//                        var event = event
//                        event.isCompleted = false
//                        todoEvent.append(event)
//                    }
//                }
//                todoEventList = todoEvent
//                completedEventList = completedEvent
//                completion()
//            }  catch let error {
//                print("Error JSON parsing: \(error.localizedDescription)")
//            }
//        }) { error in
//          print(error.localizedDescription)
//        }
    }
    
    func updateAchievement() {
//        guard let dayAchievement = dayAchievement else { return }
//        ref = Database.database().reference()
//        ref.child("user1").child("AchievementList").child(dayAchievement.date).setValue(dayAchievement.toDictionary)
    }
    
    func fetchAchievement(completion: @escaping () -> Void) {
//        ref = Database.database().reference()
//        ref.child("user1").child("AchievementList").child(convertDateFormat(0, "YYYY_MM_dd_EEEE", .day)).observeSingleEvent(of: .value, with: { [self] snapshot in
//            if snapshot.value is NSNull {
//                isRunToday = false
//                fetchEventList { completion() }
//                dayAchievement = DayAchievement(dayAchivement: 0.0, date: convertDateFormat(0, "YYYY_MM_dd_EEEE", .day))
//                return
//            } else {
//                fetchEventList { completion() }
//            }
//
//            guard let value = snapshot.value else {
//                return
//            }
//            do {
//                let jsonData = try JSONSerialization.data(withJSONObject: value, options: [])
//                let loadData = try JSONDecoder().decode(DayAchievement.self, from: jsonData)
//                dayAchievement = loadData
//            }  catch let error {
//                print("Error JSON parsing: \(error.localizedDescription)")
//            }
//            completion()
//        }) { error in
//            print(error.localizedDescription)
//        }
    }
    
//    func convertDateFormat(_ day: Int, _ format: String, _ component: Calendar.Component) -> String {
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = format
//        dateFormatter.locale = Locale(identifier: "ko_KR")
//        let date = Calendar.current.date(byAdding: component, value: -(day), to: Date())
//        let result = dateFormatter.string(from: date ?? Date())
//        return result
//    }
}
