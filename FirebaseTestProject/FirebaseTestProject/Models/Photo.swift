//
//  Photo.swift
//  FirebaseTestProject
//
//  Created by Евгений on 1.12.21.
//

import Foundation
import FirebaseFirestore

struct Photo: Identifiable, Codable {
    
    var id: String = UUID().uuidString
    var url: String
    var photoName: String
    var locationName: String
    
    enum CodingKeys: String, CodingKey {
        case url
        case photoName
        case locationName
    }

}
