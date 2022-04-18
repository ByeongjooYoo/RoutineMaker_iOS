//
//  EventListUseCase.swift
//  RoutineMaker
//
//  Created by ByeongJu Yu on 2022/04/16.
//

import Foundation

protocol EventListUseCase {
    func fetchEventList(completion: (EventList) -> Void)
    
    func updateIsCompletedOfEvent(to isCompleted: Bool, byID id: String, completion: () -> Void)
    func deleteEvent(byID id: String, completion: () -> Void)
}

class EventListUseCaseImpl: EventListUseCase {
    var eventList: [Event] = [
        Event(id: "1", title: "test1", description: "test1", isCompleted: false),
        Event(id: "2", title: "test2", description: "test1", isCompleted: false),
        Event(id: "3", title: "test3", description: "test1", isCompleted: false),
        Event(id: "4", title: "test4", description: "test1", isCompleted: false),
        Event(id: "5", title: "test5", description: "test1", isCompleted: true),
        Event(id: "6", title: "test6", description: "test1", isCompleted: true),
        Event(id: "7", title: "test7", description: "test1", isCompleted: true),
        Event(id: "8", title: "test8", description: "test1", isCompleted: true)
    ]
    
    func fetchEventList(completion: (EventList) -> Void) {
        let incompletedEventList = eventList.filter { $0.isCompleted == false }
        let completedEventList = eventList.filter { $0.isCompleted == true }
        completion((incompletedEventList, completedEventList))
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
