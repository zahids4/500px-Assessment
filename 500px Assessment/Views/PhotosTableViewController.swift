//
//  PhotosTableViewController.swift
//  500px Assessment
//
//  Created by Saim Zahid on 2019-10-25.
//  Copyright © 2019 Saim Zahid. All rights reserved.
//

import UIKit
import Alamofire

class PhotosTableViewController: UITableViewController {
    private let operations = ImageDownloadOperations()
    private var photoViewModels = [PhotoViewModel]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchPopularPhotos(page: 1)
    }
    
    private func fetchPopularPhotos(page: Int) {
        ApiProvider.shared.fetchPopularPhotos(page: page) { result in
            switch result {
            case .success(let popularPhotos):
                self.photoViewModels = popularPhotos.convertPhotosToViewModels()
            case .failure(let error):
                print("Error: \(error)")
            }
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photoViewModels.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 350.0
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        DispatchQueue.main.async {
            self.tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "photoCell", for: indexPath) as! PhotoTableViewCell
        
        let photo = photoViewModels[indexPath.row]
        cell.configure(using: photo)
        
        switch (photo.imageDownloadState) {
        case .failed:
          cell.nameLabel?.text = "Failed to load"
        case .new:
            startDownloadOperation(for: photo, at: indexPath)
        case .downloaded:
            print("Do nothing")
        }

        return cell
    }
    
    func startDownloadOperation(for photo: PhotoViewModel, at indexPath: IndexPath) {
      guard operations.downloadsInProgress[indexPath] == nil else {
        return
      }
      
      let downloadOperation = DownloadOperation(photo)
        
      downloadOperation.completionBlock = {
        if downloadOperation.isCancelled {
          return
        }
        
        DispatchQueue.main.async {
          self.operations.downloadsInProgress.removeValue(forKey: indexPath)
          self.tableView.reloadRows(at: [indexPath], with: .fade)
        }
      }
        
      operations.downloadsInProgress[indexPath] = downloadOperation
      operations.operationQueue.addOperation(downloadOperation)
    }
}
