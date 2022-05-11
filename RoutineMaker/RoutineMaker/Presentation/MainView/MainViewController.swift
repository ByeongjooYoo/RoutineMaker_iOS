//
//  MainViewController.swift
//  RoutineMaker
//
//  Created by ByeongJu Yu on 2022/02/06.
//

import UIKit

class MainViewController: UIViewController {
    
    @IBOutlet weak var eventTableView: UITableView!

    private let viewModel = MainViewModel(
        eventListUseCase: EventListUseCaseImpl(
            eventRepository: EventRepositoryImpl()
        )
    )
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationController()
        setupTableView()
        setupNotification()
        viewModel.fetchEventList {
            self.eventTableView.reloadData()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let addEventViewController = segue.destination as? AddEventViewController {
            addEventViewController.delegate = self
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
        
        let eventTableViewHeadCell = UINib(nibName: "EventTableViewHeadCell", bundle: nil)
        eventTableView.register(eventTableViewHeadCell, forCellReuseIdentifier: "EventTableViewHeadCell")
    }
    
    func setupNotification() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(didChangedEventCompletion(_:)),
            name: Notification.Name("tappedEventCompletionButton"),
            object: nil
        )
    }

    @objc func didChangedEventCompletion(_ notification: Notification) {
        let (isSelected, index) = notification.object as! (Bool, Int)
        viewModel.didChangedEventState(isSelected, index) {
            self.eventTableView.reloadData()
        }
    }
}

extension MainViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return viewModel.getIncompletedEventCount() + 1
        default:
            return viewModel.getCompletedEventCount() + 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            return loadEventTableViewHeadCell(tableView, cellForRowAt: indexPath)
        default:
            return loadEventTableViewCell(tableView, cellForRowAt: indexPath)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return 60
        default:
            return 45
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            return
        }
        if editingStyle == .delete {
            viewModel.deleteEventButtonDidClick(section: indexPath.section, index: indexPath.row - 1) {
                self.eventTableView.reloadData()
            }
        }
    }
    
    // TODO: 개선필요
    func loadEventTableViewCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "EventTableViewCell", for: indexPath) as? EventTableViewCell else {
            return UITableViewCell()
        }
        switch indexPath.section {
        case 0:
            guard let event = viewModel.getIncompletedEvent(by: indexPath.row - 1) else { return UITableViewCell() }
            cell.EventNameLabel.text = event.title
            cell.setIndex(indexPath.row - 1)
            cell.EventCompletionButton.isSelected = false
        default:
            guard let event = viewModel.getCompletedEvent(by: indexPath.row - 1) else { return UITableViewCell() }
            cell.EventNameLabel.text = event.title
            cell.setIndex(indexPath.row - 1)
            cell.EventCompletionButton.isSelected = true
        }
        return cell
    }
    
    func loadEventTableViewHeadCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "EventTableViewHeadCell", for: indexPath) as? EventTableViewHeadCell else {
            return UITableViewCell()
        }
        switch indexPath.section {
        case 0:
            cell.titleLabel.text = "해야할 일"
        default:
            cell.titleLabel.text = "완료"
        }
        return cell
    }
}

extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        if indexPath.row == 0 {
            return UITableViewCell.EditingStyle.none
        } else {
            return UITableViewCell.EditingStyle.delete
        }
    }
}

extension MainViewController: AddEventViewDelegate {
    func didAddEvent() {
        viewModel.fetchEventList {
            self.eventTableView.reloadData()
        }
    }
}
