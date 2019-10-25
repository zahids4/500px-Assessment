//
//  ApiProvider.swift
//  500px Assessment
//
//  Created by Saim Zahid on 2019-10-25.
//  Copyright © 2019 Saim Zahid. All rights reserved.
//

import Foundation
import Alamofire


struct params: Encodable {
    let feature: String
    let consumer_key: String
}

class ApiProvider {
    private init() {}
    static let shared = ApiProvider()
    
    private let appDelegate = UIApplication.shared.delegate as! AppDelegate
    private let jsonDecoder: JSONDecoder = {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        return jsonDecoder
    }()
    
    func fetchPopularPhotos(completionHandler: @escaping (Result<PopularPhotos, Error>) -> ()) {
        let paramsForPhotos = params(feature: "popular", consumer_key: appDelegate.apiKey)
        AF.request("https://api.500px.com/v1/photos", parameters: paramsForPhotos)
        .responseDecodable(of: PopularPhotos.self, decoder: jsonDecoder) { response in
            switch response.result {
                case .success(let photos):
                    completionHandler(.success(photos))
                case .failure(let error):
                    completionHandler(.failure(error))
            }
        }
    }
}
