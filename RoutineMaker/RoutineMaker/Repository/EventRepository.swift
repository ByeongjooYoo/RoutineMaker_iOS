//
//  EventRepository.swift
//  RoutineMaker
//
//  Created by ByeongJu Yu on 2022/04/16.
//

import Foundation
import Firebase

protocol EventRepository {
    var reference: DatabaseReference { get }
    func postEvent(event: Event)
    func updateIsCompletedOfEvent(to isCompleted: Bool, byID id: String)
    func deleteEvent(event: Event)
    func requestEvents(completion: @escaping ([Event]) -> Void)
}

class EventRepositoryImpl: EventRepository {
    var reference: DatabaseReference = Database.database().reference()
    
    func postEvent(event: Event) {
        reference.child("user1").child("EventList").child(event.id).setValue(event.toDictionary)
    }
    
    func updateIsCompletedOfEvent(to isCompleted: Bool, byID id: String) {
        reference.child("user1").child("EventList").child(id).child("isCompleted").setValue(isCompleted)
    }
    
    func deleteEvent(event: Event) {
        reference.child("user1").child("EventList").child(event.id).removeValue()
    }
    
    func requestEvents(completion: @escaping ([Event]) -> Void) {
        reference.child("user1").child("EventList").observeSingleEvent(of: .value, with: { snapshot in
            guard let value = snapshot.value else {
                print("Firebase Data Empty")
                return
            }
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: value)
                let eventList = try JSONDecoder().decode([String:Event].self, from: jsonData).map { $0.value }
                completion(eventList)
            }  catch let error {
                print("Error JSON parsing: \(error.localizedDescription)")
            }
        }) { error in
            print(error.localizedDescription)
        }
    }
}
