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
    var photoViewModel: PhotoViewModelProtocol
    
    init(_ photo: PhotoViewModelProtocol) {
        self.photoViewModel = photo
    }
    
    override func main() {
        if isCancelled { return }
        
        guard let imageData = photoViewModel.fetchImage() else { return }
        
        if isCancelled {
          return
        }
        
        if !imageData.isEmpty {
            photoViewModel.image = UIImage(data:imageData)!
            photoViewModel.imageDownloadState = .downloaded
        } else {
            photoViewModel.imageDownloadState = .failed
            photoViewModel.image = UIImage(named: "Failed")!
        }
    }
    
}

