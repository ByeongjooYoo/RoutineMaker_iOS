//
//  EventHeaderFooterView.swift
//  RoutineMaker
//
//  Created by ByeongJu Yu on 2022/05/12.
//

import UIKit

class EventHeaderFooterView: UITableViewHeaderFooterView {
    private var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = .systemFont(ofSize: 25, weight: .bold)
        return titleLabel
    }()
    
    func setLayout(titleText: String) {
        contentView.addSubview(titleLabel)
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 15
        contentView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        titleLabel.text = titleText
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 18),
            titleLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            titleLabel.heightAnchor.constraint(equalTo: contentView.heightAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
}
