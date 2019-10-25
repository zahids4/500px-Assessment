//
//  PopularPhotos.swift
//  500px Assessment
//
//  Created by Saim Zahid on 2019-10-25.
//  Copyright © 2019 Saim Zahid. All rights reserved.
//

import Foundation

public struct PopularPhotos: Decodable {
    public let photos: [Photo]
    
    func convertPhotosToViewModels() -> [PhotoViewModel] {
        return self.photos.map { PhotoViewModel(photo: $0) }
    }
}
