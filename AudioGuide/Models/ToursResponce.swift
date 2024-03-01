//
//  ToursResponce.swift
//  AudioGuide
//
//  Created by Максим Оліярник on 05.02.2024.
//

import Foundation

struct TourResponse: Codable {
    let data: TourData
}

struct TourData: Codable {
    let message: String
    let data: [TourModel]
    let pagination: PaginationTours
    let subscriptions: [String]
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        message = try container.decode(String.self, forKey: .message)
        data = try container.decode([TourModel].self, forKey: .data)
        pagination = try container.decode(PaginationTours.self, forKey: .pagination)
        
        // Додайте обробку для поля `subscriptions`
        if let subscriptionsArray = try? container.decode([String].self, forKey: .subscriptions) {
            subscriptions = subscriptionsArray
        } else {
            subscriptions = []
        }
    }
}

struct TourModel: Codable {
    let id: Int
    let userId: Int
    let img: String
    let points: String
    let duration: String
    let distance: String
    let audio: String?
    let video: String?
    let active: Int
    let createdAt: String
    let updatedAt: String
    let rating: Int
    let toursLangData: [ToursLangData]

    enum CodingKeys: String, CodingKey {
        case id
        case userId = "id_user"
        case img
        case points
        case duration
        case distance
        case audio
        case video
        case active
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case rating
        case toursLangData = "tours_lang_data"
    }
}

struct ToursLangData: Codable {
    let id: Int
    let idLang: String
    let idRef: Int
    let name: String
    let description: String
    let createdAt: String
    let updatedAt: String

    enum CodingKeys: String, CodingKey {
        case id
        case idLang = "id_lang"
        case idRef = "id_ref"
        case name
        case description
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

struct PaginationTours: Codable {
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
