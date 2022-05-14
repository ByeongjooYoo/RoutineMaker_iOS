//
//  MainViewModel.swift
//  RoutineMaker
//
//  Created by ByeongJu Yu on 2022/04/14.
//

import Foundation

class MainViewModel {
    @Dependency
    private var eventListUseCase: EventListUseCase

    @ViewModelState
    private(set) var incompletedEventListCellViewModels: [EventListCellViewModel]?
    @ViewModelState
    private(set) var completedEventListCellViewModels: [EventListCellViewModel]?
    
    init() {
        eventListUseCase.addDelegate(delegate: self)
    }
    
    // View가 로드 될떄 호출되어 eventlist 데이터를 전달하는 역할
    func fetchEventList() {
        eventListUseCase.fetchEventList {
            self.getEventList()
        }
    }
    
    func getIncompletedEventCount() -> Int {
        incompletedEventListCellViewModels?.count ?? 0
    }
    
    func getCompletedEventCount() -> Int {
        completedEventListCellViewModels?.count ?? 0
    }
    
    func getIncompletedEventListCellViewModels() -> [EventListCellViewModel] {
        incompletedEventListCellViewModels ?? []
    }
    
    func getCompletedEventListCellViewModels() -> [EventListCellViewModel] {
        completedEventListCellViewModels ?? []
    }
    
    func eventCompletionButtonDidTap(viewModel: EventListCellViewModel) {
        let newIsCompleted = !viewModel.completionButtonIsSelected
        eventListUseCase.updateIsCompletedOfEvent(to: newIsCompleted, byID: viewModel.eventID) {
            self.getEventList()
        }
    }
    
    func deleteIncompletedEventButtonDidClick(index: Int) {
        guard let viewModel = incompletedEventListCellViewModels?[safe: index] else { return }
        deleteEvent(byEventID: viewModel.eventID)
    }
    
    func deleteCompletedEventButtonDidClick(index: Int) {
        guard let viewModel = completedEventListCellViewModels?[safe: index] else { return }
        deleteEvent(byEventID: viewModel.eventID)
    }
}

// MARK: - Delegate
extension MainViewModel: EventListUseCaseDelegate {
    func didAddEvent() {
        getEventList()
    }
}

// MARK: - Private Methods
private extension MainViewModel {
    /// UseCase에서 현재 로드된 Event 목록을 받아와서 EventListCellViewModel을 채워넣는다.
    func getEventList() {
        eventListUseCase.getEventList { incompleted, completed in
            self.incompletedEventListCellViewModels = incompleted.map(\.toEventListCellViewModel)
            self.completedEventListCellViewModels = completed.map(\.toEventListCellViewModel)
        }
    }
    
    func deleteEvent(byEventID eventID: String) {
        eventListUseCase.deleteEvent(byID: eventID) {
            self.getEventList()
        }
    }
}
