//
//  MainViewModel.swift
//  RoutineMaker
//
//  Created by ByeongJu Yu on 2022/04/14.
//

import Foundation

class MainViewModel {
    private let eventListUseCase: EventListUseCase = DIContainer.instance.get(type: EventListUseCase.self)

    private var incompletedEventListCellViewModels: [EventListCellViewModel]?
    private var completedEventListCellViewModels: [EventListCellViewModel]?

    // View가 로드 될떄 호출되어 eventlist 데이터를 전달하는 역할
    func fetchEventList(completion: @escaping () -> Void) {
        eventListUseCase.fetchEventList {
            self.getEventList(completion: completion)
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

    func eventCompletionButtonDidTap(viewModel: EventListCellViewModel, completion: @escaping () -> Void) {
        let newIsCompleted = !viewModel.completionButtonIsSelected
        eventListUseCase.updateIsCompletedOfEvent(to: newIsCompleted, byID: viewModel.eventID) {
            self.getEventList(completion: completion)
        }
    }
    
    func deleteIncompletedEventButtonDidClick(index: Int, completion: @escaping () -> Void) {
        guard let viewModel = incompletedEventListCellViewModels?[safe: index] else { return }
        deleteEvent(byEventID: viewModel.eventID, completion: completion)
    }

    func deleteCompletedEventButtonDidClick(index: Int, completion: @escaping () -> Void) {
        guard let viewModel = completedEventListCellViewModels?[safe: index] else { return }
        deleteEvent(byEventID: viewModel.eventID, completion: completion)
    }

    private func deleteEvent(byEventID eventID: String, completion: @escaping () -> Void) {
        eventListUseCase.deleteEvent(byID: eventID) {
            self.getEventList(completion: completion)
        }
    }
}

// MARK: - Private Methods
private extension MainViewModel {
    /// UseCase에서 현재 로드된 Event 목록을 받아와서 EventListCellViewModel을 채워넣는다.
    func getEventList(completion: @escaping () -> Void) {
        eventListUseCase.getEventList { incompleted, completed in
            self.incompletedEventListCellViewModels = incompleted.map(\.toEventListCellViewModel)
            self.completedEventListCellViewModels = completed.map(\.toEventListCellViewModel)

            completion()
        }
    }
}
