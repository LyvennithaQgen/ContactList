//
//  ContactListModelAPI.swift
//  ContactList
//
//  Created by Lyvennitha on 31/01/22.
//

import Foundation

struct ContactListModelAPI {
    let networkLayer = NetworkLayer()
    
    func getLatestContact(onResponse: @escaping (Result<ContactResponse, Error>) -> ()){
        networkLayer.getNew(OnResponse: onResponse)
    }
    
}

// MARK: - ContactResponseElement
struct ContactResponseElement: Codable, Hashable {
    static func == (lhs: ContactResponseElement, rhs: ContactResponseElement) -> Bool {
        return lhs.albumID == rhs.albumID && lhs.id == rhs.id
    }
    
    let albumID, id: Int?
    let title: String?
    let url, thumbnailURL: String?
    var view: Bool? = false

    enum CodingKeys: String, CodingKey {
        case albumID = "albumId"
        case id, title, url
        case thumbnailURL = "thumbnailUrl"
    }
}

typealias ContactResponse = [ContactResponseElement]
