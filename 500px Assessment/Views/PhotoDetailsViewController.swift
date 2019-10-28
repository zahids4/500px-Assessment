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
    
    var selectedImage: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fullscreenPhotoImageView.image = selectedImage
    }

}
