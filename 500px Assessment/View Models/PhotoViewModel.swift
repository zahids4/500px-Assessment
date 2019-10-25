//
//  PhotoViewModel.swift
//  500px Assessment
//
//  Created by Saim Zahid on 2019-10-25.
//  Copyright © 2019 Saim Zahid. All rights reserved.
//

import Foundation

public class PhotoViewModel {
    private let photo: Photo

    public init(photo: Photo) {
      self.photo = photo
    }

    public var name: String {
      return photo.name
    }

    public var image: String {
        return photo.imageUrl.first ?? ""
    }
}
