//
//  EventTableViewHeadCell.swift
//  RoutineMaker
//
//  Created by ByeongJu Yu on 2022/02/10.
//

import UIKit

class EventTableViewHeadCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
