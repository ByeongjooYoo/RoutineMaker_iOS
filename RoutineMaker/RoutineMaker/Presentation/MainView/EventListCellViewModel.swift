//
//  EventListCellViewModel.swift
//  RoutineMaker
//
//  Created by ByeongJu Yu on 2022/05/11.
//

import Foundation

struct EventListCellViewModel {
    let eventID: String
    let nameLabelText: String
    let completionButtonIsSelected: Bool
}

// MARK: - Event + EventListCellViewModel
extension Event {
    var toEventListCellViewModel: EventListCellViewModel {
        EventListCellViewModel(
            eventID: id,
            nameLabelText: title,
            completionButtonIsSelected: isCompleted
        )
    }
}
