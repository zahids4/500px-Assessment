//
//  PhotoTableViewCell.swift
//  500px Assessment
//
//  Created by Saim Zahid on 2019-10-27.
//  Copyright © 2019 Saim Zahid. All rights reserved.
//

import UIKit

class PhotoTableViewCell: UITableViewCell {
    @IBOutlet weak var photoImageView: UIImageView!

    func configure(using photoViewModel: PhotoViewModelProtocol) {
        photoImageView.image = photoViewModel.image
    }
}
