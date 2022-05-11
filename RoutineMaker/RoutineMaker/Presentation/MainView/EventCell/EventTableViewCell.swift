//
//  EventTableViewCell.swift
//  RoutineMaker
//
//  Created by ByeongJu Yu on 2022/02/10.
//

import UIKit

// MARK: - EventTableViewCellDelegate
protocol EventTableViewCellDelegate: AnyObject {
    func eventCompletionButtonDidTap(viewModel: EventListCellViewModel)
}

// MARK: - EventTableViewCell

class EventTableViewCell: UITableViewCell {
    
    weak var delegate: EventTableViewCellDelegate?
        var viewModel: EventListCellViewModel? {
            didSet {
                EventNameLabel.text = viewModel?.nameLabelText
                EventCompletionButton.isSelected = viewModel?.completionButtonIsSelected ?? false
            }
        }
    
    @IBOutlet weak var EventNameLabel: UILabel!
    @IBOutlet weak var EventCompletionButton: UIButton!
    
    @IBAction func tappedEventCompletionButton(_ sender: UIButton) {
            guard let viewModel = viewModel else { return }
            delegate?.eventCompletionButtonDidTap(viewModel: viewModel)
        }
}
