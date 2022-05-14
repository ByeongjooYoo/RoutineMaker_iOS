//
//  EventListUseCase.swift
//  RoutineMaker
//
//  Created by ByeongJu Yu on 2022/04/16.
//

import Foundation
protocol EventListUseCaseDelegate: AnyObject {
    //네이밍 수정
    func didAddEvent()
}

protocol EventListUseCase {
    var delegate: EventListUseCaseDelegate? { get set }
    
    func setDelegate(delegate: EventListUseCaseDelegate)
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
    
    weak var delegate: EventListUseCaseDelegate?
    
    func setDelegate(delegate: EventListUseCaseDelegate) {
        self.delegate = delegate
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
            delegate?.didAddEvent()
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
    
//    func calculateAchievement() {
//        let incompletedEventCount = countOfEvent(isCompleted: false)
//        let completedEventCount = countOfEvent(isCompleted: true)
//        let achievement = incompletedEventCount + completedEventCount == 0 ? 0 : round(Double(completedEventCount) / (Double(incompletedEventCount) + Double(completedEventCount)) * 100) / 100
//        print(achievement)
//    }
//    
//    func getTodayDate() {
//        let formatter = ISO8601DateFormatter()
//        formatter.timeZone = .autoupdatingCurrent
//        formatter.formatOptions = [.withFullDate]
//        print(formatter.string(from: Date()))
//    }
}
