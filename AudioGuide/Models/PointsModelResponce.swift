//
//  PointsModelResponce.swift
//  AudioGuide
//
//  Created by Максим Оліярник on 04.02.2024.
//

import Foundation
struct PointsModelResponce: Codable {
    let data: PointsResponceData
}

struct PointsResponceData: Codable {
    let message: String
    let data: [PointLocation]
    let pagination: Pagination
    let subscriptions : [String]
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        message = try container.decode(String.self, forKey: .message)
        data = try container.decode([PointLocation].self, forKey: .data)
        pagination = try container.decode(Pagination.self, forKey: .pagination)
        
        // Додайте обробку для поля `subscriptions`
        if let subscriptionsArray = try? container.decode([String].self, forKey: .subscriptions) {
            subscriptions = subscriptionsArray
        } else {
            subscriptions = []
        }
    }
}
struct PointLocation: Codable {
    let id: Int
    let lat: String
    let lng: String
    let markerImg: String
    let idGroup: Int
    let phone: String
    let url: String
    let img: String
    let visible: Int
    let createdAt: String?
    let updatedAt: String?
    let icon: String
    let rating: Int
    let pointLangData: [PointLangData]
    
    enum CodingKeys: String, CodingKey {
        case id
        case lat
        case lng
        case markerImg = "marker_img"
        case idGroup = "id_group"
        case phone
        case url
        case img
        case visible
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case icon
        case rating
        case pointLangData = "point_lang_data"
    }
}

struct PointLangData: Codable {
    let id: Int
    let idRef: Int
    let idLang: String
    let name: String
    let description: String
    let address: String
    let createdAt: String?
    let updatedAt: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case idRef = "id_ref"
        case idLang = "id_lang"
        case name
        case description
        case address
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

struct Pagination: Codable {
    let total: Int
    let perPage: Int
    let currentPage: Int
    let lastPage: Int
    let nextPageUrl: String?
    let prevPageUrl: String?
    
    enum CodingKeys: String, CodingKey {
        case total
        case perPage = "per_page"
        case currentPage = "current_page"
        case lastPage = "last_page"
        case nextPageUrl = "next_page_url"
        case prevPageUrl = "prev_page_url"
        
    }
}


