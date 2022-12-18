//
//  ProfileViewController.swift
//  TwitterLite
//
//  Created by Al-Amin on 6/12/22.
//

import UIKit

class ProfileViewController: UIViewController {
    
    var user: TwitterUser?
    var tweetList = [TweetInfo]()
    var avatarImage = UIImage(systemName: "person")
    private var isStatusBarHidden: Bool = true
    private var height: CGFloat?
    
    private let statusBar: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemBackground
        view.layer.opacity = 0
        return view
    }()
    
    private let profileTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(TweetTableViewCell.self, forCellReuseIdentifier: TweetTableViewCell.identifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureTableView()
        configureConstraints()
    }
    
    private func configureUI() {
        height = self.tabBarController?.tabBar.frame.size.height
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.isHidden = true
        view.addSubview(profileTableView)
        view.addSubview(statusBar)
    }
    
    private func configureTableView() {
        let headerView = ProfileTableViewHeader(frame: CGRect(x: 0, y: 0, width: profileTableView.frame.width, height: 380))
        if let user = user {
            headerView.displayNameLabel.text = user.fullname
            headerView.usernameLabel.text = "@\(user.username)"
            headerView.profileAvatarImageView.image = avatarImage
        }
        profileTableView.delegate = self
        profileTableView.dataSource = self
        profileTableView.tableHeaderView = headerView
        profileTableView.tableFooterView = UIView()
        profileTableView.contentInsetAdjustmentBehavior = .never
    }
    
    private func configureConstraints() {
        
        let profileTableViewConstraints = [
            profileTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            profileTableView.topAnchor.constraint(equalTo: view.topAnchor),
            profileTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            profileTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -(height ?? 0))
        ]
        
        let statusBarConstraints = [
            statusBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            statusBar.topAnchor.constraint(equalTo: view.topAnchor),
            statusBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            statusBar.heightAnchor.constraint(equalToConstant: view.bounds.height > 800 ? 40 : 20)
        ]
        
        NSLayoutConstraint.activate(profileTableViewConstraints)
        NSLayoutConstraint.activate(statusBarConstraints)
    }
    
}

// MARK: - TableViewDelegate/DataSource

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweetList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TweetTableViewCell.identifier, for: indexPath) as? TweetTableViewCell else {
            return UITableViewCell()
        }
        cell.tweetTextContentLabel.text = tweetList[indexPath.row].captionText
        if tweetList[indexPath.row].tweetImageUrl != nil {
            let url = URL(string: tweetList[indexPath.row].tweetImageUrl!)
            cell.tweetImageView.sd_setImage(with: url, completed: nil)
        }
        cell.displayNameLabel.text = user?.fullname
        cell.usernameLabel.text = "@\(user?.username ?? "")"
        cell.avatarImageView.image = avatarImage
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let yPosition = scrollView.contentOffset.y
        
        if yPosition > 150 && isStatusBarHidden {
            isStatusBarHidden = false
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveLinear) { [weak self] in
                self?.statusBar.layer.opacity = 1
            }
        } else if yPosition < 0 && !isStatusBarHidden {
            isStatusBarHidden = true
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveLinear) { [weak self] in
                self?.statusBar.layer.opacity = 0
            }
        }
    }
}
