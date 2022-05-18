//
//  EventListUseCase.swift
//  RoutineMaker
//
//  Created by ByeongJu Yu on 2022/04/16.
//

import Foundation

@objc protocol EventListUseCaseDelegate: AnyObject {
    func evnetDidAdd()
}

protocol EventListUseCase {
    func addDelegate(delegate: EventListUseCaseDelegate)
    func removeDelegate(delegate: EventListUseCaseDelegate)
    func countOfEvent(to isCompleted: Bool) -> Int
    func getEventList(completion: (EventList) -> Void)
    func addEvent(event: Event, completion: () -> Void)
    func fetchEventList(completion: @escaping () -> Void)
    func updateIsCompletedOfEvent(to isCompleted: Bool, byID id: String, completion: () -> Void)
    func deleteEvent(byID id: String, completion: () -> Void)
}

class EventListUseCaseImpl: EventListUseCase {
    @Dependency
    private var eventRepository: EventRepository
    
    private var delegates = [EventListUseCaseDelegate]()
    
    func addDelegate(delegate: EventListUseCaseDelegate) {
        delegates.append(delegate)
    }

    func removeDelegate(delegate: EventListUseCaseDelegate) {
        guard let index = delegates.firstIndex(where: { $0 === delegate }) else { return }
        delegates.remove(at: index)
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
        eventRepository.postEvent(event: event) {
            delegates.forEach { $0.evnetDidAdd() }
            completion()
        }
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
