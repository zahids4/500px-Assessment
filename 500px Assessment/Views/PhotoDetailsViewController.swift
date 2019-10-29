//
//  PhotoDetailsViewController.swift
//  500px Assessment
//
//  Created by Saim Zahid on 2019-10-28.
//  Copyright © 2019 Saim Zahid. All rights reserved.
//

import UIKit

class PhotoDetailsViewController: UIViewController {
    @IBOutlet weak var fullscreenPhotoImageView: UIImageView!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var createdAtLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var numberOfLikesLabel: UILabel!
    @IBOutlet weak var numberOfCommentsLabel: UILabel!
    @IBOutlet weak var detailsView: UIView!
    
    var photoViewModel: PhotoViewModelProtocol!
    
    private var hideDetailsGesture: UITapGestureRecognizer!
    private var showDetailsGesture: UITapGestureRecognizer!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupGestures()
        addHideDetailsViewGestureToImageView()
        configureView()
        fetchAndSetUserAvatarIfRequired()
        makeAvatarFrameCircular()
    }
    
    fileprivate func configureView() {
        fullscreenPhotoImageView.image = photoViewModel.image
        userNameLabel.text = photoViewModel.userName
        createdAtLabel.text = photoViewModel.formattedCreatedAtText
        nameLabel.text = photoViewModel.name
        numberOfLikesLabel.text = photoViewModel.formattedLikesText
        numberOfCommentsLabel.text = photoViewModel.commentsText
    }
    
    fileprivate func setupGestures() {
        hideDetailsGesture = UITapGestureRecognizer(target: self, action: #selector(hideDetailsView))
        showDetailsGesture = UITapGestureRecognizer(target: self, action: #selector(showDetailsView))
    }
    
    fileprivate func setAvatarImageView() {
        DispatchQueue.main.async {
            self.avatarImageView.image = self.photoViewModel.userImage
        }
    }
    
    fileprivate func makeAvatarFrameCircular() {
        DispatchQueue.main.async {
            self.avatarImageView.layer.borderWidth = 1.0
            self.avatarImageView.layer.masksToBounds = false
            self.avatarImageView.layer.borderColor = UIColor.white.cgColor
            self.avatarImageView.layer.cornerRadius = self.avatarImageView.frame.size.width / 2
            self.avatarImageView.clipsToBounds = true
        }
    }
    
    fileprivate func fetchAndSetUserAvatarIfRequired() {
        if photoViewModel.userImage == UIImage(systemName: "person.fill") {
            photoViewModel.fetchAvatar() {
                self.setAvatarImageView()
            }
        } else {
            setAvatarImageView()
        }
    }
    
    @objc func hideDetailsView() {
        animateDetailsView(opacity: 0) {
            self.removeHideDetailsViewGestureToImageView()
            self.addShowDetailsViewGestureToImageView()
        }
    }
    
    @objc func showDetailsView() {
        animateDetailsView(opacity: 1) {
            self.removeShowDetailsViewGestureToImageView()
            self.addHideDetailsViewGestureToImageView()
        }
    }
    
    private func animateDetailsView(opacity: Float, closure: @escaping voidClosure) {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.5, animations: {
                self.detailsView.layer.opacity = opacity
            }) { _ in
                closure()
            }
        }
    }
    
    fileprivate func removeHideDetailsViewGestureToImageView() {
        fullscreenPhotoImageView.removeGestureRecognizer(hideDetailsGesture)
    }
    
    fileprivate func addHideDetailsViewGestureToImageView() {
        fullscreenPhotoImageView.addGestureRecognizer(hideDetailsGesture)
    }
    
    fileprivate func removeShowDetailsViewGestureToImageView() {
        fullscreenPhotoImageView.removeGestureRecognizer(showDetailsGesture)
    }
    
    fileprivate func addShowDetailsViewGestureToImageView() {
        fullscreenPhotoImageView.addGestureRecognizer(showDetailsGesture)
    }
}
