//
//  EventRepository.swift
//  RoutineMaker
//
//  Created by ByeongJu Yu on 2022/04/16.
//

import Foundation
import Firebase

protocol EventRepository {
    var eventList: [Event] { get }
    func postEvent(event: Event, completion: () -> Void)
    func updateIsCompletedOfEvent(to isCompleted: Bool, byID id: String, completion: () -> Void)
    func deleteEvent(byID id: String, completion: () -> Void)
    func requestEvents(completion: @escaping () -> Void)
    func resetIsCompletedOfEvent(completion: @escaping () -> Void)
}

//Event 데이터를 가지고 있도록 수정
class EventRepositoryImpl: EventRepository {
    private let reference: DatabaseReference = Database.database().reference()
    var eventList: [Event] = []
    
    func postEvent(event: Event, completion: () -> Void) {
        eventList.append(event)
        reference.child("user1").child("EventList").child(event.id).setValue(event.toDictionary)
        completion()
    }
    
    func updateIsCompletedOfEvent(to isCompleted: Bool, byID id: String, completion: () -> Void) {
        if let index = eventList.firstIndex(where: { $0.id == id }) {
            eventList[index].isCompleted = isCompleted
        }
        reference.child("user1").child("EventList").child(id).child("isCompleted").setValue(isCompleted)
        completion()
    }
    
    func deleteEvent(byID id: String, completion: () -> Void) {
        if let index = eventList.firstIndex(where: { $0.id == id }) {
            eventList.remove(at: index)
        }
        reference.child("user1").child("EventList").child(id).removeValue()
        completion()
    }
    
    func requestEvents(completion: @escaping () -> Void) {
        reference.child("user1").child("EventList").observeSingleEvent(of: .value, with: { snapshot in
            guard let value = snapshot.value else {
                print("Firebase Data Empty")
                return
            }
            do {
                if value is NSNull {
                    print("RequestEvents: Null!")
                } else {
                    let jsonData = try JSONSerialization.data(withJSONObject: value)
                    let eventList = try JSONDecoder().decode([String:Event].self, from: jsonData).map { $0.value }
                    self.eventList = eventList
                    completion()
                }
            }  catch let error {
                print("Error JSON parsing: \(error.localizedDescription)")
            }
        }) { error in
            print(error.localizedDescription)
        }
    }
    
    func resetIsCompletedOfEvent(completion: @escaping () -> Void) {
        for index in 0 ..< eventList.count {
            if eventList[index].isCompleted {
                eventList[index].isCompleted = false
                // TODO: updateIsCompletedOfEvent를 사용하여 중복코드 제거 가능
                reference.child("user1").child("EventList").child(eventList[index].id).child("isCompleted").setValue(false)
            }
        }
        completion()
    }
    
    func getEventList() {
        
    }
    
    func eventListCount() {
        
    }
    
    
}

//// MARK: - MockEventRepository
//class MockEventRepository: EventRepository {
//    var eventList: [Event] = []
//    
//    func postEvent(event: Event, completion: () -> Void) {
//        eventList.append(event)
//        completion()
//    }
//    
//    func updateIsCompletedOfEvent(to isCompleted: Bool, byID id: String, completion: () -> Void) {
//        guard let index = eventList.firstIndex(where: { $0.id == id }) else { return }
//        
//        eventList[index].isCompleted = isCompleted
//        completion()
//    }
//    
//    func deleteEvent(byID id: String, completion: () -> Void) {
//        eventList.removeAll { $0.id == id }
//        completion()
//    }
//    
//    func requestEvents(completion: @escaping () -> Void) {
//        completion()
//    }
//}
