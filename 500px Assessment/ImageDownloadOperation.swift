//
//  ImageDownloadOperation.swift
//  500px Assessment
//
//  Created by Saim Zahid on 2019-10-27.
//  Copyright © 2019 Saim Zahid. All rights reserved.
//

import UIKit

fileprivate typealias voidClosure = () -> ()

class ImageDownloadOperations {
    lazy var downloadsInProgress: [IndexPath: DownloadOperation] = [:]
    lazy var operationQueue = OperationQueue()
}

class DownloadOperation: Operation {
    var photo: PhotoViewModel
    
    init(_ photo: PhotoViewModel) {
        self.photo = photo
    }
    
    override func main() {
        if isCancelled { return }

        guard let imageData = try? Data(contentsOf: URL(string: photo.imageUrlString)!) else { return }
        
        if isCancelled {
          return
        }
        
        if !imageData.isEmpty {
          photo.image = UIImage(data:imageData)
          photo.imageDownloadState = .downloaded
        } else {
          photo.imageDownloadState = .failed
          photo.image = UIImage(named: "Failed")
        }
    }
    
}

