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
    var userImage: UIImage { get set }
    var formattedByLabelText: String { get }
    var formattedCreatedAtText: String { get }
    var formattedLikesText: String { get }
    var commentsText: String { get }
    func fetchImage() -> Data?
    func getDataFromImageURL(_ stringUrl: String) -> Data?
    func fetchAvatar(closure: @escaping () -> ())
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
    
    var userImage: UIImage = UIImage(systemName: "person.fill")!
    
    var formattedByLabelText: String {
        return "By: \(photo.user.fullName)"
    }
    
    var formattedCreatedAtText: String {
        let isoFormatter = ISO8601DateFormatter()
        let formattedDate = isoFormatter.date(from: photo.createdAt)!
        //TODO: get time elpased since posting then swift between hrs, yesterday, weeks etc.
        return "\(formattedDate)"
    }
    var formattedLikesText: String {
        return "\(photo.positiveVotesCount) likes"
    }
    
    var commentsText: String {
        return "\(photo.commentsCount)"
    }
    
    func fetchImage() -> Data? {
        return getDataFromImageURL(imageUrlString)
    }
    
    func getDataFromImageURL(_ stringUrl: String) -> Data? {
        return try? Data(contentsOf: URL(string: stringUrl)!)
    }
    
    func fetchAvatar(closure: @escaping voidClosure) {
        DispatchQueue.global(qos: .userInteractive).async {
            guard let imageData = self.getDataFromImageURL(self.photo.user.avatarUrl) else { return }
          
            if !imageData.isEmpty {
                self.userImage = UIImage(data:imageData)!
            }
            
            closure()
        }
    }
}
