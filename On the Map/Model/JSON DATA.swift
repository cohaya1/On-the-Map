//
//  Network Data.swift
//  On the Map
//
//  Created by Makaveli Ohaya on 4/12/20.
//  Copyright © 2020 Ohaya. All rights reserved.
//

import Foundation

struct LoginResponse: Codable {
    let account: Account
    let session: Session
}

struct PostResponse: Codable {
    var createdAt: String
    var objectId: String
}

struct Account: Codable {
    let registered: Bool?
    let key: String?
}

struct Session: Codable {
    let id: String?
    let expiration: String?
}
struct Location: Decodable {
    let key: String
    let firstName: String
    let lastName: String
    
    enum CodingKeys: String, CodingKey {
        case firstName = "first_name"
        case lastName = "last_name"
        case key
    }
}
struct StudentInformation {
    var uniqueKey: String
    var firstName: String
    var lastName: String
    var latitude: Double
    var longitude: Double
    var mapString: String
    var mediaURL: String
}
struct Result: Codable {
    let results: [StudentLocation]?
}

struct StudentLocation: Codable {
    var createdAt: String?
    var firstName: String
    var lastName: String
    var latitude: Double?
    var longitude: Double?
    var mapString: String?
    var mediaURL: String?
    var objectId: String?
    var uniqueKey: String?
    var updatedAt: String?
    
    init(createdAt: String, firstName: String, lastName: String, latitude: Double, longitude: Double, mapString: String, mediaURL: String, objectId: String, uniqueKey: String, updatedAt: String) {
        self.createdAt = createdAt
        self.firstName = firstName
        self.lastName = lastName
        self.latitude = latitude
        self.longitude = longitude
        self.mapString = mapString
        self.mediaURL = mediaURL
        self.objectId = objectId
        self.uniqueKey = uniqueKey
        self.updatedAt = updatedAt
    }
}
struct StudentLocations {
    static var lastFetched: [StudentLocation]?
}
struct UpdateLocation: Codable {
    let updatedAt: String
}
