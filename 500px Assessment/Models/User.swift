//
//  User.swift
//  500px Assessment
//
//  Created by Saim Zahid on 2019-10-28.
//  Copyright © 2019 Saim Zahid. All rights reserved.
//

import Foundation

public struct User: Decodable {
    public let userName: String
    public let avatarUrl: String
    
    private enum CodingKeys : String, CodingKey {
        case userName = "username"
        case avatarUrl = "userpicUrl"
    }
}
