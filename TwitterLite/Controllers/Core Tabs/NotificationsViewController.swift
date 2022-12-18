//
//  NotificationsViewController.swift
//  TwitterLite
//
//  Created by Al-Amin on 6/12/22.
//

import UIKit

class NotificationsViewController: UIViewController {
    
    private let msgLabel: UILabel = {
        let label = UILabel()
        label.text = "No notification yet!"
        label.textAlignment = .center
        label.tintColor = .label
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 25, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private func configureUI() {
        navigationItem.title = "Notifications"
        view.backgroundColor = .systemBackground
        view.addSubview(msgLabel)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureConstraints()
    }
    
    private func configureConstraints() {
        let msgLabelConstraint = [
            msgLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            msgLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
            msgLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            msgLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ]
        
        NSLayoutConstraint.activate(msgLabelConstraint)
    }
}
