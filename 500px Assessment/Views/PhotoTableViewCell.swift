//
//  PhotoTableViewCell.swift
//  500px Assessment
//
//  Created by Saim Zahid on 2019-10-27.
//  Copyright © 2019 Saim Zahid. All rights reserved.
//

import UIKit

class PhotoTableViewCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var photoImageView: UIImageView!

    func configure(using photoViewModel: PhotoViewModelProtocol) {
        nameLabel.text = photoViewModel.name
        photoImageView.image = photoViewModel.image
    }
    
    func setNameLabelForFailedDownload() {
        nameLabel?.text = "Failed to load"
    }
}
