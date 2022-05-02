//
//  EventListUseCase.swift
//  RoutineMaker
//
//  Created by ByeongJu Yu on 2022/04/16.
//

import Foundation

protocol EventListUseCase {
    func countOfEvent(to isCompleted: Bool) -> Int
    func getEventList(completion: (EventList) -> Void)
    func addEvent(event: Event, completion: () -> Void)
    func fetchEventList(completion: @escaping () -> Void)
    func updateIsCompletedOfEvent(to isCompleted: Bool, byID id: String, completion: () -> Void)
    func deleteEvent(byID id: String, completion: () -> Void)
}

class EventListUseCaseImpl: EventListUseCase {
    
    private let eventRepository: EventRepository
    
    init(eventRepository: EventRepository) {
        self.eventRepository = eventRepository
    }
    
    func countOfEvent(to isCompleted: Bool) -> Int {
        let eventList = eventRepository.eventList
        return isCompleted ? eventList.filter { $0.isCompleted == true }.count : eventList.filter { $0.isCompleted == false }.count
    }
    
    func getEventList(completion: (EventList) -> Void) {
        let eventList = eventRepository.eventList
        let incompletedEventList = eventList.filter { $0.isCompleted == false }
        let completedEventList = eventList.filter { $0.isCompleted == true }
        completion((incompletedEventList, completedEventList))
    }
    
    func addEvent(event: Event, completion: () -> Void) {
        eventRepository.postEvent(event: event, completion: completion)
    }
    
    func fetchEventList(completion: @escaping () -> Void) {
        eventRepository.requestEvents(completion: completion)
    }
    
    func updateIsCompletedOfEvent(to isCompleted: Bool, byID id: String, completion: () -> Void) {
        eventRepository.updateIsCompletedOfEvent(to: isCompleted, byID: id, completion: completion)
    }
    
    func deleteEvent(byID id: String, completion: () -> Void) {
        eventRepository.deleteEvent(byID: id, completion: completion)
    }
}
