//
//  PhotosListViewModel.swift
//  500px Assessment
//
//  Created by Saim Zahid on 2019-10-27.
//  Copyright © 2019 Saim Zahid. All rights reserved.
//

import Foundation


protocol PhotosListViewModelDelegate: class {
    func onFetchCompleted(with newIndexPathsToReload: [IndexPath]?)
    func onFetchFailed(with reason: String)
}

final class PhotosListViewModel {
    private weak var delegate: PhotosListViewModelDelegate?
    
    private var photos: [PhotoViewModelProtocol] = []
    private var currentPage = 1
    private var total = 0
    private var isFetchInProgress = false
    
    init(delegate: PhotosListViewModelDelegate) {
      self.delegate = delegate
    }
    
    var totalCount: Int {
      return total
    }
    
    var currentCount: Int {
      return photos.count
    }
    
    func photo(at index: Int) -> PhotoViewModelProtocol {
      return photos[index]
    }
    
    func fetchPhotos() {
        guard !isFetchInProgress else {
            return
        }
      
        isFetchInProgress = true
        
        ApiProvider.shared.fetchPopularPhotos(page: currentPage) { result in
            switch result {
            case .success(let popularPhotos):
                DispatchQueue.main.async {
                    self.currentPage += 1
                    self.isFetchInProgress = false
                    self.total = popularPhotos.photos.count
                    
                    let newPhotos =  popularPhotos.convertPhotosToViewModels()
                    self.photos += newPhotos
                  
                  
                    if popularPhotos.currentPage > 1 {
                        let indexPathsToReload = self.calculateIndexPathsToReload(from: newPhotos)
                        self.delegate?.onFetchCompleted(with: indexPathsToReload)
                    } else {
                        self.delegate?.onFetchCompleted(with: .none)
                    }
                }
            case .failure(let error):
                DispatchQueue.main.async {
                  self.isFetchInProgress = false
                  self.delegate?.onFetchFailed(with: error.localizedDescription)
                }
            }
        }
    }
    
    
    private func calculateIndexPathsToReload(from newPhotos: [PhotoViewModelProtocol]) -> [IndexPath] {
      let startIndex = photos.count - newPhotos.count
      let endIndex = startIndex + newPhotos.count
      return (startIndex..<endIndex).map { IndexPath(row: $0, section: 0) }
    }
}
