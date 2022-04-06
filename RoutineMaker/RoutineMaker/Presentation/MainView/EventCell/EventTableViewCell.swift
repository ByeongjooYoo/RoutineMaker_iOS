//
//  EventTableViewCell.swift
//  RoutineMaker
//
//  Created by ByeongJu Yu on 2022/02/10.
//

import UIKit

class EventTableViewCell: UITableViewCell {
    var index: Int?
    @IBOutlet weak var EventNameLabel: UILabel!
    @IBOutlet weak var EventCompletionButton: UIButton!
    
    func setIndex(_ index: Int) {
        self.index = index
    }
    
    @IBAction func tappedEventCompletionButton(_ sender: UIButton) {
        sender.isSelected.toggle()
        NotificationCenter.default.post(name: Notification.Name("tappedEventCompletionButton"), object: (sender.isSelected, index!))
    }
}
