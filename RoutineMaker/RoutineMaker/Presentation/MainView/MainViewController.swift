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
            guard indexPath.row != 0, editingStyle == .delete else { return }

            let index = indexPath.row - 1

            switch indexPath.section {
            case 0:
                viewModel.deleteIncompletedEventButtonDidClick(index: index) { self.eventTableView.reloadData() }
            case 1:
                viewModel.deleteCompletedEventButtonDidClick(index: index) { self.eventTableView.reloadData() }
            default:
                break
            }
        }

        func loadEventTableViewCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "EventTableViewCell", for: indexPath) as? EventTableViewCell else {
                return UITableViewCell()
            }

            cell.delegate = self

            let cellIndex = indexPath.row - 1
            switch indexPath.section {
            case 0:
                cell.viewModel = viewModel.getIncompletedEventListCellViewModels()[safe: cellIndex]
            default:
                cell.viewModel = viewModel.getCompletedEventListCellViewModels()[safe: cellIndex]
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

    // MARK: MainViewController + EventTableViewCellDelegate
    extension MainViewController: EventTableViewCellDelegate {
        func eventCompletionButtonDidTap(viewModel: EventListCellViewModel) {
            self.viewModel.eventCompletionButtonDidTap(viewModel: viewModel) {
                self.eventTableView.reloadData()
            }
        }
}
