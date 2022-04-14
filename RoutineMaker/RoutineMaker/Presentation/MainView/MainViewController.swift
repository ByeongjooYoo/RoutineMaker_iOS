//
//  MainViewController.swift
//  RoutineMaker
//
//  Created by ByeongJu Yu on 2022/02/06.
//

import UIKit
import Firebase

class MainViewController: UIViewController {
    
    @IBOutlet weak var eventTableView: UITableView!

    private let viewModel = MainViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationController()
        setupTableView()
        setupNotification()
        viewModel.fetchAchievement {
            self.eventTableView.reloadData()
        }
    }
    
    // TODO: Need Refactoring
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
    
    // TODO: Need Refactoring
    func setupNotification() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(didChangedEventCompletion(_:)),
            name: Notification.Name("tappedEventCompletionButton"),
            object: nil
        )
    }

    // TODO: Need Refactoring
    @objc func didChangedEventCompletion(_ notification: Notification) {
        let (isSelected, index) = notification.object as! (Bool, Int)
        
        switch isSelected {
        case true:
            var event = viewModel.todoEventList[index]
            event.completion = isSelected
            viewModel.todoEventList.remove(at: index)
            viewModel.completedEventList.append(event)
            break
        case false:
            var event = viewModel.completedEventList[index]
            event.completion = isSelected
            viewModel.completedEventList.remove(at: index)
            viewModel.todoEventList.append(event)
            break
        }
        viewModel.dayAchievement?.dayAchivement = viewModel.computedAchivement(viewModel.todoEventList.count, viewModel.completedEventList.count)
       
        viewModel.updateAchievement()
        viewModel.updateEventList()
        eventTableView.reloadData()
    }
}

extension MainViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return viewModel.todoEventList.count + 1
        default:
            return viewModel.completedEventList.count + 1
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
    
    // TODO: Need Refactoring
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            return
        }
        switch indexPath.section {
        case 0:
            if editingStyle == .delete {
                viewModel.todoEventList.remove(at: indexPath.row - 1)
                eventTableView.deleteRows(at: [indexPath], with: .fade)
            }
        default:
            if editingStyle == .delete {
                viewModel.completedEventList.remove(at: indexPath.row - 1)
                eventTableView.deleteRows(at: [indexPath], with: .fade)
            }
        }
        viewModel.dayAchievement?.dayAchivement = viewModel.computedAchivement(viewModel.todoEventList.count, viewModel.completedEventList.count)
       
        viewModel.updateAchievement()
        viewModel.updateEventList()
    }
    
    // TODO: Need Refactoring
    func loadEventTableViewCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "EventTableViewCell", for: indexPath) as? EventTableViewCell else {
            return UITableViewCell()
        }
        switch indexPath.section {
        case 0:
            cell.EventNameLabel.text = viewModel.todoEventList[indexPath.row - 1].title
            cell.setIndex(indexPath.row - 1)
            cell.EventCompletionButton.isSelected = false
        default:
            cell.EventNameLabel.text = viewModel.completedEventList[indexPath.row - 1].title
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

// TODO: Need Refactoring
extension MainViewController: AddEventViewDelegate {
    func didAddEvent(event: Event) {
        viewModel.todoEventList.append(event)
        viewModel.dayAchievement?.dayAchivement = viewModel.computedAchivement(viewModel.todoEventList.count, viewModel.completedEventList.count)
        viewModel.updateAchievement()
        viewModel.updateEventList()
        eventTableView.reloadData()
    }
}

