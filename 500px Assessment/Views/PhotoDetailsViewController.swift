//
//  PhotoDetailsViewController.swift
//  500px Assessment
//
//  Created by Saim Zahid on 2019-10-28.
//  Copyright © 2019 Saim Zahid. All rights reserved.
//

import UIKit

private typealias voidClosure = () -> ()

class PhotoDetailsViewController: UIViewController {
    @IBOutlet weak var fullscreenPhotoImageView: UIImageView!
    @IBOutlet weak var byLabel: UILabel!
    @IBOutlet weak var createdAtLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var detailsView: UIView!
    
    var photo: PhotoViewModelProtocol!
    
    private var hideDetailsGesture: UITapGestureRecognizer!
    private var showDetailsGesture: UITapGestureRecognizer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupGestures()
        addHideDetailsViewGestureToImageView()
        configureView()
    }
    
    fileprivate func configureView() {
        fullscreenPhotoImageView.image = photo.image
        byLabel.text = photo.formattedByLabelText
        createdAtLabel.text = photo.formattedCreatedAtText
        nameLabel.text = photo.name
    }
    
    fileprivate func setupGestures() {
        hideDetailsGesture = UITapGestureRecognizer(target: self, action: #selector(hideDetailsView))
        showDetailsGesture = UITapGestureRecognizer(target: self, action: #selector(showDetailsView))
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
