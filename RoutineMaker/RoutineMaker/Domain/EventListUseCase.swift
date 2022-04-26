//
//  EventListUseCase.swift
//  RoutineMaker
//
//  Created by ByeongJu Yu on 2022/04/16.
//

import Foundation

protocol EventListUseCase {
    func getEventList(completion: (EventList) -> Void)
    func fetchEventList(completion: @escaping (EventList) -> Void)
    func updateIsCompletedOfEvent(to isCompleted: Bool, byID id: String, completion: (EventList) -> Void)
    func deleteEvent(byID id: String, completion: (EventList) -> Void)
}

class EventListUseCaseImpl: EventListUseCase {
    
    let eventRepositoryUmpl = EventRepositoryImpl()
    
    func getEventList(completion: (EventList) -> Void){
        let eventList = eventRepositoryUmpl.eventList
        let incompletedEventList = eventList.filter { $0.isCompleted == false }
        let completedEventList = eventList.filter { $0.isCompleted == true }
        completion((incompletedEventList, completedEventList))
    }
    
    func addEvent(event: Event, completion: () -> Void) {
        eventRepositoryUmpl.postEvent(event: event) {
            completion()
        }
    }
    
    func fetchEventList(completion: @escaping (EventList) -> Void) {
        eventRepositoryUmpl.requestEvents { response in
            let eventList = response
            let incompletedEventList = eventList.filter { $0.isCompleted == false }
            let completedEventList = eventList.filter { $0.isCompleted == true }
            completion((incompletedEventList, completedEventList))
        }
//        let incompletedEventList = self.eventList.filter { $0.isCompleted == false }
//        let completedEventList = self.eventList.filter { $0.isCompleted == true }
//        completion((incompletedEventList, completedEventList))
    }
    
    func updateIsCompletedOfEvent(to isCompleted: Bool, byID id: String, completion: (EventList) -> Void) {
        eventRepositoryUmpl.updateIsCompletedOfEvent(to: isCompleted, byID: id, completion: { eventList in
            let eventList = eventList
            let incompletedEventList = eventList.filter { $0.isCompleted == false }
            let completedEventList = eventList.filter { $0.isCompleted == true }
            completion((incompletedEventList, completedEventList))
        })
    }
    
    func deleteEvent(byID id: String, completion: (EventList) -> Void) {
        eventRepositoryUmpl.deleteEvent(byID: id) { eventList in
            let eventList = eventList
            let incompletedEventList = eventList.filter { $0.isCompleted == false }
            let completedEventList = eventList.filter { $0.isCompleted == true }
            completion((incompletedEventList, completedEventList))
        }
    }
}
