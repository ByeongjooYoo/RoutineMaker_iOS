//
//  MainViewModel.swift
//  RoutineMaker
//
//  Created by ByeongJu Yu on 2022/04/14.
//

import Foundation

class MainViewModel {
    private let eventListUseCase: EventListUseCase
    
    init(eventListUseCase: EventListUseCase) {
        self.eventListUseCase = eventListUseCase
    }
    
    func getIncompletedEventCount() -> Int {
        return eventListUseCase.countOfEvent(isCompleted: false)
    }
    
    func getCompletedEventCount() -> Int {
        return eventListUseCase.countOfEvent(isCompleted: true)
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

    func didChangedEventState(_ done: Bool, _ index: Int, completion: @escaping () -> Void) {
        guard let event = done ? getCompletedEvent(by: index) : getIncompletedEvent(by: index) else { return }
        let eventID = event.id
        eventListUseCase.updateIsCompletedOfEvent(to: !event.isCompleted, byID: eventID, completion: completion)
    }
    
    func deleteEventButtonDidClick(section: Int, index: Int, completion: @escaping () -> Void) {
        guard let event = section == 1 ? getCompletedEvent(by: index) : getIncompletedEvent(by: index) else { return }
        let eventID = event.id
        eventListUseCase.deleteEvent(byID: eventID, completion: completion)
    }
    
    //View가 로드 될떄 호출되어 eventlist 데이터를 전달하는 역할
    func fetchEventList(completion: @escaping () -> Void) {
        eventListUseCase.fetchEventList(completion: completion)
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
