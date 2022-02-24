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
    var dayEventData: DayEventData?
    var todoEventList: [Event] = []
    var completionEventList: [Event] = []
    
    var ref: DatabaseReference!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationController()
        setupTableView()
        setupNotification()
        
        dayEventData = DayEventData(eventList: [], todayAchivement: 0.0, date: getTodayDate())
        print(dayEventData!.date)
        
        readFirebaseData(date: dayEventData!.date)
        
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
        NotificationCenter.default.addObserver(self, selector: #selector(didChangedEventCompletion(_:)), name: Notification.Name("tappedEventCompletionButton"), object: nil)
    }
    
    func readFirebaseData(date: String) {
        ref = Database.database().reference()
        ref.child("user1").observeSingleEvent(of: .value, with: { snapshot in
            guard let value = snapshot.value as? [String: Any] else { return }
            print("-----------------------")
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: value)
                let todayEvent = try JSONDecoder().decode([String: DayEventData].self, from: jsonData)
                guard let data = todayEvent[date] else { return }
                self.dayEventData = data
                self.loadDayData()
                self.eventTableView.reloadData()
            }  catch let error {
                print("Error JSON parsing: \(error.localizedDescription)")
            }
        }) { error in
          print(error.localizedDescription)
        }
    }
    
    func writeFirebaseData(dayEventData: DayEventData) {
        ref = Database.database().reference()
        print(dayEventData.toDictionary)
        ref.child("user1").child(dayEventData.date).setValue(dayEventData.toDictionary)
    }
    
    func getTodayDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY_MM_dd_EEEE"
        dateFormatter.locale = Locale(identifier: "ko_KR")
        let date = dateFormatter.string(from: Date())
        return date
    }
    
    func computedAchivement() -> Double {
        if todoEventList.count + completionEventList.count == 0 {
            return 0.0
        }
        let result = Double(completionEventList.count) / (Double(todoEventList.count) + Double(completionEventList.count))
        NotificationCenter.default.post(name: Notification.Name("getDayAchivementData"), object: round(result * 100) / 100)
        return round(result * 100) / 100
    }
    
    func loadDayData() {
        dayEventData?.eventList.forEach { event in
            if event.completion {
                completionEventList.append(event)
            } else {
                todoEventList.append(event)
            }
        }
    }
    
    func addDayData(event: Event) {
        dayEventData?.eventList.append(event)
    }
    
    func deleteDayData(event: Event) {
        guard let index = dayEventData?.eventList.firstIndex(of: event) else { return }
        dayEventData?.eventList.remove(at: index)
    }
    
    
    
    @objc func didChangedEventCompletion(_ notification: Notification) {
        let (isSelected, index) = notification.object as! (Bool, Int)
        switch isSelected {
        case true:
            var event = todoEventList[index]
            deleteDayData(event: event)
            event.completion = isSelected
            addDayData(event: event)
            todoEventList.remove(at: index)
            completionEventList.append(event)
            break
        case false:
            var event = completionEventList[index]
            deleteDayData(event: event)
            event.completion = isSelected
            addDayData(event: event)
            completionEventList.remove(at: index)
            todoEventList.append(event)
            break
        }
        let todayAchivement = computedAchivement()
        dayEventData?.todayAchivement = todayAchivement
        writeFirebaseData(dayEventData: dayEventData!)
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
            return todoEventList.count + 1
        default:
            return completionEventList.count + 1
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
        
        switch indexPath.section {
        case 0:
            if editingStyle == .delete {
                let event = todoEventList[indexPath.row - 1]
                deleteDayData(event: event)
                todoEventList.remove(at: indexPath.row - 1)
                eventTableView.deleteRows(at: [indexPath], with: .fade)
            }
        default:
            if editingStyle == .delete {
                let event = completionEventList[indexPath.row - 1]
                deleteDayData(event: event)
                completionEventList.remove(at: indexPath.row - 1)
                eventTableView.deleteRows(at: [indexPath], with: .fade)
            }
        }
    }
    
    func loadEventTableViewCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "EventTableViewCell", for: indexPath) as? EventTableViewCell else {
            return UITableViewCell()
        }
        switch indexPath.section {
        case 0:
            cell.EventNameLabel.text = todoEventList[indexPath.row - 1].title
            cell.setIndex(indexPath.row - 1)
            cell.EventCompletionButton.isSelected = false
        default:
            cell.EventNameLabel.text = completionEventList[indexPath.row - 1].title
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
    func didAddEvent(event: Event) {
        todoEventList.append(event)
        addDayData(event: event)
        writeFirebaseData(dayEventData: dayEventData!)
        eventTableView.reloadData()
    }
}
