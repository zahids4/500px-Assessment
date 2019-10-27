//
//  PhotoViewModel.swift
//  500px Assessment
//
//  Created by Saim Zahid on 2019-10-25.
//  Copyright © 2019 Saim Zahid. All rights reserved.
//

import UIKit

enum ImageDownloadState {
  case new, downloaded, failed
}

protocol PhotoViewModelProtocol {
    var name: String { get }
    var imageUrlString: String { get }
    var imageDownloadState: ImageDownloadState { get set }
    var image: UIImage { get set }
}

class PhotoViewModel: PhotoViewModelProtocol {
    private let photo: Photo

    public init(photo: Photo) {
      self.photo = photo
    }

    var name: String {
      return photo.name
    }

    var imageUrlString: String {
        return photo.imageUrl.first ?? ""
    }
    
    var imageDownloadState: ImageDownloadState = .new
    
    var image: UIImage = UIImage(named: "Placeholder")!
}
