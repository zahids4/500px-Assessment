//
//  Photo.swift
//  500px Assessment
//
//  Created by Saim Zahid on 2019-10-25.
//  Copyright © 2019 Saim Zahid. All rights reserved.
//

import Foundation

public struct Photo: Decodable {
    public let name: String
    public let user: User
    public let imageUrl: [String]
    public let createdAt: String
    public let positiveVotesCount: Int
    public let commentsCount: Int
}
