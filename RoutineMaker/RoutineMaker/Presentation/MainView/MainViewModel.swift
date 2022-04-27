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
    var todoEventList: [Event] = []
    
    
    // TODO: 개선필요
    var completedEventList: [Event] = []
    
    
    var dayAchievement: DayAchievement? {
        didSet {
//            updateAchievement()
        }
    }

    
    init(eventListUseCase: EventListUseCase) {
        self.eventListUseCase = eventListUseCase
    }
    
    func getIncompletedEvent(by index: Int) -> Event? {
        var event: Event?
        eventListUseCase.getEventList { eventList in
            event = eventList.incompleted[index]
        }
        return event
    }
    
    func getCompletedEvent(by index: Int) -> Event? {
        var event: Event?
        eventListUseCase.getEventList { eventList in
            event = eventList.completed[index]
        }
        return event
    }

    // TODO: 개선필요
    func didChangedEventState(_ done: Bool, _ index: Int, completion: @escaping () -> Void) {
        let event = done ? completedEventList[index] : todoEventList[index]
        let eventID = event.id
        eventListUseCase.updateIsCompletedOfEvent(to: !event.isCompleted, byID: eventID) { eventList in
            self.todoEventList = eventList.incompleted
            self.completedEventList = eventList.completed
            completion()
        }
    }
    
    func deleteEventButtonDidClick(section: Int, row: Int, completion: @escaping () -> Void) {
        let event = section == 0 ? todoEventList[row] : completedEventList[row]
        let eventID = event.id
        eventListUseCase.deleteEvent(byID: eventID) { eventList in
            self.todoEventList = eventList.incompleted
            self.completedEventList = eventList.completed
            completion()
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
    
    //View가 로드 될떄 호출되어 eventlist 데이터를 전달하는 역할
    func fetchEventList(completion: @escaping () -> Void) {
        eventListUseCase.fetchEventList { eventList in
            self.todoEventList = eventList.incompleted
            self.completedEventList = eventList.completed
            
            completion()
        }
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
