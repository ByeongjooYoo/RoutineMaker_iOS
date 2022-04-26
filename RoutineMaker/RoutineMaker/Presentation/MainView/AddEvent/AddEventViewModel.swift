//
//  AddEventViewModel.swift
//  RoutineMaker
//
//  Created by ByeongJu Yu on 2022/03/16.
//

import Foundation

/*
 제목: String
 내용: String
 추가버튼 활성화 여부: Bool
 
 
 취소버튼 클릭: ButtonEvent
 추가버튼 클릭: ButtonEvent
 제목이 변경이 된 이벤트: textvalueChange
 내용이 변경이 된 이벤트: textvalueChange

 */

protocol AddEventViewModelDelegate: AnyObject {
    func isAddButtonEnabledDidChange()
    func dismiss()
    func didAddEvent()
}

class AddEventViewModel {
    var title: String? {
        didSet {
            updateIsAddButtonEnabled()
        }
    }
    
    var description: String? {
        didSet {
            updateIsAddButtonEnabled()
        }
    }
    
    var isAddButtonEnabled: Bool = false {
        didSet {
            delegate?.isAddButtonEnabledDidChange()
            print("isAddButtonEnabled: \(isAddButtonEnabled)")
        }
    }
    
    private let eventListUseCase: EventListUseCase
    
    weak var delegate: AddEventViewModelDelegate?
    
    init(eventListUseCase: EventListUseCase) {
        self.eventListUseCase = eventListUseCase
    }
    
    func cancelButtonDidClick() {
        delegate?.dismiss()
    }
    
    func addButtonDidClick() {
        guard let title = title, let description = description else { return }
        let event = Event(id: UUID().uuidString ,title: title, description: description, isCompleted: false)
        eventListUseCase.addEvent(event: event) {
            delegate?.didAddEvent()
            delegate?.dismiss()
        }
    }
    
    func titleDidChange(to title: String?) {
        self.title = title
        print("titleDidChage: \(title ?? "nil")")
    }
    
    func descriptionDidChange(to description: String?) {
        self.description = description
        print("descriptionDidChange: \(description ?? "nil")")
    }
    
    private func updateIsAddButtonEnabled() {
        isAddButtonEnabled = !(title?.isEmpty ?? true) && !(description?.isEmpty ?? true)
    }
}
