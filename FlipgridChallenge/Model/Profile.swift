//
//  Profile.swift
//  FlipgridChallenge
//
//  Created by Lokesha Saralikana on 11/20/21.
//

import Foundation

struct Profile: Codable {
    var avatar: Data?
    var firstName: String?
    var email: String
    var password: String
    var website: String?
}
