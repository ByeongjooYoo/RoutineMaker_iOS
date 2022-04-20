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
    func didAddEvent(event: Event)
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
    
    weak var delegate: AddEventViewModelDelegate?
    let eventRepositoryUmpl = EventRepositoryImpl()
    
    func cancelButtonDidClick() {
        delegate?.dismiss()
    }
    
    func addButtonDidClick() {
        guard let title = title, let description = description else { return }
        let event = Event(id: UUID().uuidString ,title: title, description: description, isCompleted: false)
        eventRepositoryUmpl.postEvent(event: event)
        //delegate?.didAddEvent(event: event)
        delegate?.dismiss()
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
        //좆밥 버전
//        if (title?.isEmpty ?? false) && (description?.isEmpty ?? false) {
//            isAddButtonEnabled = true
//        } else {
//            isAddButtonEnabled = false
//        }
        
        //병한버전
        isAddButtonEnabled = !(title?.isEmpty ?? true) && !(description?.isEmpty ?? true)
    }
}

// TODO: event가 add될 때 바로 추가되게 만들기
