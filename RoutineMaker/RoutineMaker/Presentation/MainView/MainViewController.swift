//
//  MainViewController.swift
//  RoutineMaker
//
//  Created by ByeongJu Yu on 2022/02/06.
//

import UIKit

class MainViewController: UIViewController {
    
    @IBOutlet weak var eventTableView: UITableView!
    
    private let viewModel = MainViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationController()
        setupTableView()
        
        viewModel.delegate = self
        viewModel.fetchEventList {
            self.eventTableView.reloadData()
        }
    }
}

private extension MainViewController {
    func setupNavigationController() {
        navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    func setupTableView() {
        eventTableView.dataSource = self
        eventTableView.delegate = self
        
        let eventTableViewCell = UINib(nibName: "EventTableViewCell", bundle: nil)
        eventTableView.register(eventTableViewCell, forCellReuseIdentifier: "EventTableViewCell")
        
        eventTableView.register(EventHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: "EventHeaderFooterView")
    }
}

extension MainViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return viewModel.getIncompletedEventCount()
        default:
            return viewModel.getCompletedEventCount()
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "EventTableViewCell", for: indexPath) as? EventTableViewCell else {
            return UITableViewCell()
        }
        
        cell.delegate = self
        
        let cellIndex = indexPath.row
        switch indexPath.section {
        case 0:
            let incompletedEventCount = viewModel.getIncompletedEventCount() - 1
            cell.viewModel = viewModel.getIncompletedEventListCellViewModels()[safe: cellIndex]
            cellIndex == incompletedEventCount ? cell.makeCornersAtBottom() : cell.deleteCornersAtBottom()
        case 1:
            let completedEventCount = viewModel.getCompletedEventCount() - 1
            cell.viewModel = viewModel.getCompletedEventListCellViewModels()[safe: cellIndex]
            cellIndex == completedEventCount ? cell.makeCornersAtBottom() : cell.deleteCornersAtBottom()
        default:
            break
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        
        let index = indexPath.row
        
        switch indexPath.section {
        case 0:
            viewModel.deleteIncompletedEventButtonDidClick(index: index) { self.eventTableView.reloadData() }
        case 1:
            viewModel.deleteCompletedEventButtonDidClick(index: index) { self.eventTableView.reloadData() }
        default:
            break
        }
    }
    
    // MARK: sectionHeaderFooter
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "EventHeaderFooterView") as? EventHeaderFooterView else {
            return UITableViewHeaderFooterView()
        }
        var title: String?
        switch section {
        case 0:
            title = "해야할 일"
        case 1:
            title = "완료"
        default:
            break
        }
        header.setLayout(titleText: title ?? "")
        return header
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
}

extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return UITableViewCell.EditingStyle.delete
    }
}

extension MainViewController: MainViewModelDelegate {
    func didAddEvent() {
        eventTableView.reloadData()
    }
}

// MARK: MainViewController + EventTableViewCellDelegate
extension MainViewController: EventTableViewCellDelegate {
    func eventCompletionButtonDidTap(viewModel: EventListCellViewModel) {
        self.viewModel.eventCompletionButtonDidTap(viewModel: viewModel) {
            self.eventTableView.reloadData()
        }
    }
}
