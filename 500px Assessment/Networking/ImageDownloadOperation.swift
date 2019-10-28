//
//  ImageDownloadOperation.swift
//  500px Assessment
//
//  Created by Saim Zahid on 2019-10-27.
//  Copyright © 2019 Saim Zahid. All rights reserved.
//

import UIKit

class ImageDownloadOperations {
    lazy var downloadsInProgress: [IndexPath: DownloadOperation] = [:]
    lazy var operationQueue = OperationQueue()
}

class DownloadOperation: Operation {
    var photo: PhotoViewModelProtocol
    
    init(_ photo: PhotoViewModelProtocol) {
        self.photo = photo
    }
    
    override func main() {
        if isCancelled { return }
        
        //TODO: This seems like a code smell refactor it.
        guard let imageData = photo.getDataFromImageURL(photo.imageUrlString) else { return }
        
        if isCancelled {
          return
        }
        
        if !imageData.isEmpty {
            photo.image = UIImage(data:imageData)!
            photo.imageDownloadState = .downloaded
        } else {
            photo.imageDownloadState = .failed
            photo.image = UIImage(named: "Failed")!
        }
    }
    
}

