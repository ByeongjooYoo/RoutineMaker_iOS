//
//  EventListUseCase.swift
//  RoutineMaker
//
//  Created by ByeongJu Yu on 2022/04/16.
//

import Foundation

protocol EventListUseCase {
    func fetchEventList(completion: @escaping (EventList) -> Void)
    
    func updateIsCompletedOfEvent(to isCompleted: Bool, byID id: String, completion: () -> Void)
    func deleteEvent(byID id: String, completion: () -> Void)
}

class EventListUseCaseImpl: EventListUseCase {
    var eventList: [Event] = []
    
    let eventRepositoryUmpl = EventRepositoryImpl()
    
    func fetchEventList(completion: @escaping (EventList) -> Void) {
        eventRepositoryUmpl.requestEvents { eventList in
            self.eventList = eventList
            let incompletedEventList = self.eventList.filter { $0.isCompleted == false }
            let completedEventList = self.eventList.filter { $0.isCompleted == true }
            completion((incompletedEventList, completedEventList))
        }
//        let incompletedEventList = self.eventList.filter { $0.isCompleted == false }
//        let completedEventList = self.eventList.filter { $0.isCompleted == true }
//        completion((incompletedEventList, completedEventList))
    }
    
    func updateIsCompletedOfEvent(to isCompleted: Bool, byID id: String, completion: () -> Void) {
        if let index = eventList.firstIndex(where: { $0.id == id }) {
            eventList[index].isCompleted = isCompleted
        }
        completion()
    }
    
    func deleteEvent(byID id: String, completion: () -> Void) {
        if let index = eventList.firstIndex(where: { $0.id == id }) {
            eventList.remove(at: index)
        }
        completion()
    }
}
