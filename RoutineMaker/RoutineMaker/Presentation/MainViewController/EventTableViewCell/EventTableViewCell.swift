//
//  EventTableViewCell.swift
//  RoutineMaker
//
//  Created by ByeongJu Yu on 2022/02/10.
//

import UIKit

class EventTableViewCell: UITableViewCell {
    @IBOutlet weak var EventNameLabel: UILabel!
    @IBOutlet weak var EventCompletionButton: UIButton!
    
    
    @IBAction func tappedEventCompletionButton(_ sender: UIButton) {
        sender.isSelected.toggle()
        NotificationCenter.default.post(name: Notification.Name("tappedEventCompletionButton"), object: sender.isSelected)
    }
}
