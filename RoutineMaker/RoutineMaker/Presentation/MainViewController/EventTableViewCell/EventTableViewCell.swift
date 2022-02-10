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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func tappedEventCompletionButton(_ sender: UIButton) {
        sender.isSelected.toggle()
    }
}
