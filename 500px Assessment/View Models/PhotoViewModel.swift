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

public class PhotoViewModel {
    private let photo: Photo

    public init(photo: Photo) {
      self.photo = photo
    }

    public var name: String {
      return photo.name
    }

    public var imageUrlString: String {
        return photo.imageUrl.first ?? ""
    }
    
    var imageDownloadState: ImageDownloadState = .new
    
    var image = UIImage(named: "Placeholder")
}
