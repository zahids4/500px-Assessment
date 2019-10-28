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
    @IBOutlet weak var byLabel: UILabel!
    @IBOutlet weak var createdAtLabel: UILabel!
    var photo: PhotoViewModelProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fullscreenPhotoImageView.image = photo.image
        byLabel.text = photo.formattedByLabelText
        createdAtLabel.text = photo.formattedCreatedAtText
    }

}
