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
    private var currentPage = 1
    private let operations = ImageDownloadOperations()
    private var viewModel: PhotosListViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.prefetchDataSource = self
        
        viewModel = PhotosListViewModel(delegate: self)
        viewModel.fetchPhotos()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.totalCount
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
        
        let photo = viewModel.photo(at: indexPath.row)
        cell.configure(using: viewModel.photo(at: indexPath.row))
        
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
    
    func startDownloadOperation(for photo: PhotoViewModelProtocol, at indexPath: IndexPath) {
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

extension PhotosTableViewController: UITableViewDataSourcePrefetching {
  func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
    if indexPaths.contains(where: { $0.row.isMultiple(of: 45) } ) {
      viewModel.fetchPhotos()
    }
  }
}

extension PhotosTableViewController: PhotosListViewModelDelegate {
  func onFetchCompleted(with newIndexPathsToReload: [IndexPath]?) {
    guard let newIndexPathsToReload = newIndexPathsToReload else {
      tableView.reloadData()
      return
    }
    tableView.insertRows(at: newIndexPathsToReload, with: .fade)
    let indexPathsToReload = visibleIndexPathsToReload(intersecting: newIndexPathsToReload)
    tableView.reloadRows(at: indexPathsToReload, with: .automatic)
  }
  
  func onFetchFailed(with reason: String) {
    print("Fetch Failed, error \(reason)")
  }
}

private extension PhotosTableViewController {
  func isLoadingCell(for indexPath: IndexPath) -> Bool {
    return indexPath.row >= viewModel.currentCount
  }
  
  func visibleIndexPathsToReload(intersecting indexPaths: [IndexPath]) -> [IndexPath] {
    let indexPathsForVisibleRows = tableView.indexPathsForVisibleRows ?? []
    let indexPathsIntersection = Set(indexPathsForVisibleRows).intersection(indexPaths)
    return Array(indexPathsIntersection)
  }
}
