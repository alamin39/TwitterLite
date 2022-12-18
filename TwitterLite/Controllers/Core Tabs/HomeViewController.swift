//
//  HomeViewController.swift
//  TwitterLite
//
//  Created by Al-Amin on 8/12/22.
//

import UIKit
import FirebaseAuth
import SDWebImage

class HomeViewController: UIViewController {
    
    private var avatarImageView = UIImageView(image: UIImage(systemName: "person"))
    var user: TwitterUser? {
        didSet {
            print("DEBUG:: user data set success")
            configureLeftBarButton()
        }
    }
    
    var tweetList = [TweetInfo]() {
        didSet {
            timelineTableView.reloadData()
        }
    }
    
    private func configureLeftBarButton() {
        guard let user = user else { return }
        
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.heightAnchor.constraint(equalToConstant: 34).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 34).isActive = true
        imageView.layer.cornerRadius = 17
        imageView.clipsToBounds = true
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        
        let url = URL(string: user.profileImageUrl)
        imageView.sd_setImage(with: url, completed: nil)
        avatarImageView = imageView
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: imageView)
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapProfile)))
    }
    
    private func configureNavigationBar() {
        let size: CGFloat = 36
        let logoImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: size, height: size))
        logoImageView.contentMode = .scaleAspectFill
        logoImageView.image = UIImage(named: "Twitter")
        
        let middleView = UIView(frame: CGRect(x: 0, y: 0, width: size, height: size))
        middleView.addSubview(logoImageView)
        navigationItem.titleView = middleView
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "rectangle.portrait.and.arrow.right"), style: .plain, target: self, action: #selector(didTapSignOut))
    }
    
    private let timelineTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(TweetTableViewCell.self,
                           forCellReuseIdentifier: TweetTableViewCell.identifier)
        return tableView
    }()
    
    private func configureTableView() {
        timelineTableView.delegate = self
        timelineTableView.dataSource = self
        timelineTableView.tableFooterView = UIView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(timelineTableView)
        configureTableView()
        configureNavigationBar()
        fetchTweets()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
        handleAuthentication()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        timelineTableView.frame = view.frame
    }
    
    private func fetchTweets() {
        TweetService.shared.fetchTweets { [weak self] tweets in
            self?.tweetList = tweets
        }
    }
    
    @objc private func didTapProfile() {
        let vc = ProfileViewController()
        vc.user = user
        vc.avatarImage = avatarImageView.image
        vc.tweetList = tweetList
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func didTapSignOut() {
        let alert = UIAlertController(title: "Are you sure you want to sign out?", message: "", preferredStyle: .actionSheet)
        let okayButton = UIAlertAction(title: "Sign Out", style: .default) { [weak self] _ in
            try? Auth.auth().signOut()
            self?.handleAuthentication()
        }
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addAction(okayButton)
        alert.addAction(cancelButton)
        present(alert, animated: true)
    }
    
    private func handleAuthentication() {
        if Auth.auth().currentUser == nil {
            DispatchQueue.main.async {
                let vc = UINavigationController(rootViewController: OnboardingViewController())
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: false)
            }
        }
    }
}

// MARK: - TableViewDelegate/DataSource

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweetList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TweetTableViewCell.identifier, for: indexPath) as? TweetTableViewCell else {
            return UITableViewCell()
        }
        cell.delegate = self
        cell.tweetTextContentLabel.text = tweetList[indexPath.row].captionText
        if tweetList[indexPath.row].tweetImageUrl != nil {
            let url = URL(string: tweetList[indexPath.row].tweetImageUrl!)
            cell.tweetImageView.sd_setImage(with: url, completed: nil)
        }
        cell.displayNameLabel.text = user?.fullname
        cell.usernameLabel.text = "@\(user?.username ?? "")"
        cell.avatarImageView.image = avatarImageView.image
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            TweetService.shared.deleteTweet(tweetID: tweetList[indexPath.row].id, url: tweetList[indexPath.row].tweetImageUrl)
            tweetList.remove(at: indexPath.row)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}


extension HomeViewController: TweetTableViewCellDelegate {
    
    func tweetTableViewCellDidTapReply() {
        print("DEBUG:: Reply")
    }
    
    func tweetTableViewCellDidTapLike() {
        print("DEBUG:: Like")
    }
    
    func tweetTableViewCellDidTapShare() {
        print("DEBUG:: Share")
    }
}
