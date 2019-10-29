//
//  PhotosTableViewController.swift
//  500px Assessment
//
//  Created by Saim Zahid on 2019-10-25.
//  Copyright © 2019 Saim Zahid. All rights reserved.
//

import UIKit
import Alamofire

private let prefetchPhotosBuffer: Int = 5

protocol DownloadForVisibleCellsProtocol {
    func resumeDownloadsForVisibleCells()
    func shoudSuspendOperations(_ isSuspended: Bool)
    func performImageDownloadOnlyForVisibleCells()
}

class PhotosTableViewController: UITableViewController {
    private let operations = ImageDownloadOperations()
    private var viewModel: PhotosListViewModel!
    
    var selectedPhoto: PhotoViewModelProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.prefetchDataSource = self
        title = "Popular Photos"
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
            self.selectedPhoto = self.viewModel.photo(at: indexPath.row)
            self.performSegue(withIdentifier: "photoDetailsSegue", sender: self)
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "photoCell", for: indexPath) as! PhotoTableViewCell

        let photo = viewModel.photo(at: indexPath.row)
        cell.configure(using: viewModel.photo(at: indexPath.row))
        
        let shouldStartImageDownload: Bool = photo.imageDownloadState == .new 
        
        if shouldStartImageDownload {
            startDownloadOperation(for: photo, at: indexPath)
        }

        return cell
    }
    
    private func startDownloadOperation(for photo: PhotoViewModelProtocol, at indexPath: IndexPath) {
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
            self.tableView.reloadRows(at: [indexPath], with: .automatic)
        }
      }
        
      operations.downloadsInProgress[indexPath] = downloadOperation
      operations.operationQueue.addOperation(downloadOperation)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "photoDetailsSegue" {
            let vc = segue.destination as! PhotoDetailsViewController
            vc.photoViewModel = selectedPhoto
        }
    }
}

extension PhotosTableViewController: UITableViewDataSourcePrefetching {
  func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
    if indexPaths.contains(where: shouldFetchNextPage) {
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
    
    tableView.insertRows(at: newIndexPathsToReload, with: .none)
    let indexPathsToReload = visibleIndexPathsToReload(intersecting: newIndexPathsToReload)
    tableView.reloadRows(at: indexPathsToReload, with: .fade)
  }
  
  func onFetchFailed(with reason: String) {
    print("Fetch Failed, error \(reason)")
  }
}

private extension PhotosTableViewController {
  func shouldFetchNextPage(for indexPath: IndexPath) -> Bool {
    return indexPath.row + prefetchPhotosBuffer >= viewModel.currentCount
  }
  
  func visibleIndexPathsToReload(intersecting indexPaths: [IndexPath]) -> [IndexPath] {
    let indexPathsForVisibleRows = tableView.indexPathsForVisibleRows ?? []
    let indexPathsIntersection = Set(indexPathsForVisibleRows).intersection(indexPaths)
    return Array(indexPathsIntersection)
  }
}

//extension PhotosTableViewController: DownloadForVisibleCellsProtocol {
//    override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
//        shoudSuspendOperations(true)
//    }
//
//    override func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
//        if !decelerate {
//            resumeDownloadsForVisibleCells()
//        }
//    }
//
//    override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
//        resumeDownloadsForVisibleCells()
//    }
//
//    internal func resumeDownloadsForVisibleCells() {
//        performImageDownloadOnlyForVisibleCells()
//        shoudSuspendOperations(false)
//    }
//
//    internal func shoudSuspendOperations(_ isSuspended: Bool) {
//        operations.operationQueue.isSuspended = isSuspended
//    }
//
//    internal func performImageDownloadOnlyForVisibleCells() {
//        if let indexPathsForVisibleCells = tableView.indexPathsForVisibleRows {
//            let allPendingOperations = Set(operations.downloadsInProgress.keys)
//
//            var toBeCancelled = allPendingOperations
//            let visiblePaths = Set(indexPathsForVisibleCells)
//            toBeCancelled.subtract(visiblePaths)
//
//            var toBeStarted = visiblePaths
//            toBeStarted.subtract(allPendingOperations)
//
//            for indexPath in toBeCancelled {
//                if let pendingOperation = operations.downloadsInProgress[indexPath] {
//                    pendingOperation.cancel()
//                }
//
//                operations.downloadsInProgress.removeValue(forKey: indexPath)
//            }
//
//            for indexPath in toBeStarted {
//                let photo = viewModel.photo(at: indexPath.row)
//                startDownloadOperation(for: photo, at: indexPath)
//            }
//        }
//    }
//}
