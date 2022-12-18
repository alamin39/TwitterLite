//
//  PostTweetViewController.swift
//  TwitterLite
//
//  Created by Al-Amin on 2022/12/14.
//

import UIKit
import PhotosUI
import Firebase
import FirebaseStorage

class PostTweetViewController: UIViewController {
    
    private var tweetContent: TweetInfo?
    private var captionText: String?
    
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(systemName: "person")
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 24
        imageView.backgroundColor = .systemGray
        return imageView
    }()
    
    let captionTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.backgroundColor = .systemBackground
        textView.font = .systemFont(ofSize: 16)
        textView.text = "What's on your mind?"
        textView.textColor = .darkGray
        textView.isScrollEnabled = false
        return textView
    }()
    
    private let tweetImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        imageView.layer.masksToBounds = true
        imageView.backgroundColor = .lightGray
        imageView.image = UIImage(systemName: "camera")
        imageView.tintColor = .gray
        imageView.isUserInteractionEnabled = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        addSubviews()
        captionTextView.delegate = self
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapToDismiss)))
        tweetImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapToUpload)))
        configureConstraints()
    }
    
    private func configureNavigationBar() {
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.isHidden = false
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(didTapCancel))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Tweet", style: .done, target: self, action: #selector(didTapTweet))
    }
    
    private func addSubviews() {
        view.addSubview(profileImageView)
        view.addSubview(captionTextView)
        view.addSubview(tweetImageView)
    }
    
    private func showAlert(with title: String, msg: String) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(alert, animated: true)
    }
    
    // MARK: - Selectors
    
    @objc private func didTapToUpload() {
        var configuration = PHPickerConfiguration()
        configuration.filter = .images
        configuration.selectionLimit = 1
        
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        present(picker, animated: true)
    }
    
    @objc private func didTapToDismiss() {
        view.endEditing(true)
    }
    
    @objc private func didTapCancel() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func didTapTweet() {
        if tweetImageView.image == UIImage(systemName: "camera") {
            tweetImageView.image = nil
        }
        
        if captionText == nil && tweetImageView.image == nil {
            tweetImageView.image = UIImage(systemName: "camera")
            showAlert(with: "Sorry! You can't post empty tweet", msg: "")
            return
        }
        
        TweetService.shared.uploadTweet(caption: captionText, image: tweetImageView.image) { [weak self] (error, ref) in
            if let error = error {
                self?.showAlert(with: "Error!", msg: error.localizedDescription)
                return
            }
            self?.dismiss(animated: true, completion: nil)
        }
    }
    
    // MARK: - Constraints
    
    private func configureConstraints() {
        let profileImageViewConstraints = [
            profileImageView.widthAnchor.constraint(equalToConstant: 48),
            profileImageView.heightAnchor.constraint(equalToConstant: 48),
            profileImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            profileImageView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16)
        ]
        
        let captionTextViewConstraints = [
            captionTextView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            captionTextView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10),
            captionTextView.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 8)
        ]
        
        let tweetImageViewConstraints = [
            tweetImageView.topAnchor.constraint(equalTo: captionTextView.bottomAnchor, constant: 10),
            tweetImageView.rightAnchor.constraint(equalTo: captionTextView.rightAnchor),
            tweetImageView.leftAnchor.constraint(equalTo: captionTextView.leftAnchor),
            tweetImageView.heightAnchor.constraint(equalToConstant: 150)
        ]
        
        NSLayoutConstraint.activate(profileImageViewConstraints)
        NSLayoutConstraint.activate(captionTextViewConstraints)
        NSLayoutConstraint.activate(tweetImageViewConstraints)
    }
}

// MARK: - TextViewDelegate

extension PostTweetViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .darkGray {
            textView.textColor = .label
            textView.text = ""
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "What's on your mind?"
            textView.textColor = .darkGray
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        captionText = textView.text
    }
}

// MARK: - PHPickerViewControllerDelegate

extension PostTweetViewController: PHPickerViewControllerDelegate {
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        
        for result in results {
            result.itemProvider.loadObject(ofClass: UIImage.self) { [weak self] (object, error) in
                if let image = object as? UIImage {
                    DispatchQueue.main.async {
                        self?.tweetImageView.image = image
                    }
                }
            }
        }
    }
}
