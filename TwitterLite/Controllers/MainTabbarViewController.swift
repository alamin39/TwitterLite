//
//  MainTabbarViewController.swift
//  TwitterLite
//
//  Created by Al-Amin on 6/12/22.
//

import UIKit
import Firebase

class MainTabbarViewController: UITabBarController {
    
    var user: TwitterUser? {
        didSet {
            print("DEBUG:: got user data")
            guard let nav = viewControllers?[0] as? UINavigationController else { return }
            guard let home = nav.viewControllers.first as? HomeViewController else { return }
            home.user = user
        }
    }
    
    private let actionButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .white
        button.backgroundColor = .gray
        button.setImage(UIImage(systemName: "square.and.pencil"), for: .normal)
        button.layer.cornerRadius = 56/2
        return button
    }()
    
    private func configureTabbar() {
        let vc1 = UINavigationController(rootViewController: HomeViewController())
        let vc2 = UINavigationController(rootViewController: SearchViewController())
        let vc3 = UINavigationController(rootViewController: NotificationsViewController())
        
        vc1.tabBarItem.image = UIImage(systemName: "house")
        vc1.tabBarItem.selectedImage = UIImage(systemName: "house.fill")
        
        vc2.tabBarItem.image = UIImage(systemName: "magnifyingglass")
        
        vc3.tabBarItem.image = UIImage(systemName: "bell")
        vc3.tabBarItem.selectedImage = UIImage(systemName: "bell.fill")
        setViewControllers([vc1, vc2, vc3], animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        handleAuthenticationAndConfigureUI()
    }
    
    private func configureUI() {
        view.backgroundColor = .systemBackground
        view.addSubview(actionButton)
        actionButton.addTarget(self, action: #selector(didTapActionButton), for: .touchUpInside)
    }
    
    private func fetchUserData() {
        UserService.shared.fetchUser { user in
            self.user = user
        }
    }
    
    func handleAuthenticationAndConfigureUI() {
        if Auth.auth().currentUser == nil {
            DispatchQueue.main.async {
                let vc = UINavigationController(rootViewController: OnboardingViewController())
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: false)
            }
        }
        else {
            print("DEBUG:: User logged in")
            configureTabbar()
            configureUI()
            configureConstraints()
            fetchUserData()
        }
    }
    
    @objc private func didTapActionButton() {
        let vc = UINavigationController(rootViewController: PostTweetViewController())
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
    
    private func configureConstraints() {
        let actionButtonConstraints = [
            actionButton.heightAnchor.constraint(equalToConstant: 56),
            actionButton.widthAnchor.constraint(equalToConstant: 56),
            actionButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -64),
            actionButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16)
        ]
        
        NSLayoutConstraint.activate(actionButtonConstraints)
    }
}
