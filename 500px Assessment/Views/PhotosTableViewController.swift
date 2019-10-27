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
    fileprivate let operations = ImageDownloadOperations()
    fileprivate var photoViewModels = [PhotoViewModel]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchPopularPhotos()
    }
    
    private func fetchPopularPhotos() {
        ApiProvider.shared.fetchPopularPhotos() { result in
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
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "photoCell", for: indexPath) as! PhotoTableViewCell
        
        let photo = photoViewModels[indexPath.row]
        cell.configure(using: photo)

        return cell
    }
}
