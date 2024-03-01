//
//  SearchResponce.swift
//  AudioGuide
//
//  Created by Максим Оліярник on 05.02.2024.
//

import Foundation
struct SearchResponseModel<T: Codable>: Codable {
    let data: T
}
struct SearchLocationsResponceModel: Codable {
    let data: LocationDataDetails
    private enum CodingKeys: String, CodingKey {
        case data
    }
}

struct LocationDataDetails: Codable {
    let message: String
    let data: [LocationModelResponce]
    let subscriptions: [String]
    private enum CodingKeys: String, CodingKey {
        case message
        case data
        case subscriptions
    }
}
struct LocationModelResponce: Codable {
    let id: Int
    let lat: String
    let lng: String
    let markerImg: String
    let idGroup: Int
    let phone: String?
    let url: String
    let img: String
    let visible: Int
    let createdAt: String?
    let updatedAt: String?
    let icon: String
    let rating: Int
    let tours: [Tour]
    let pointLangData: [LocationLangData]

    private enum CodingKeys: String, CodingKey {
        case id, lat, lng, markerImg = "marker_img", idGroup = "id_group", phone, url, img, visible, createdAt = "created_at", updatedAt = "updated_at", icon, rating, tours, pointLangData = "point_lang_data"
    }
}
struct Tour: Codable {
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
    let toursLangData: [TourLangData]

    private enum CodingKeys: String, CodingKey {
        case id, userId = "id_user", img, points, duration, distance, audio, video, active, createdAt = "created_at", updatedAt = "updated_at", toursLangData = "tours_lang_data"
    }
}
struct TourLangData: Codable {
    let id: Int
    let idLang: String
    let idRef: Int
    let name: String
    let description: String
    let createdAt: String
    let updatedAt: String

    private enum CodingKeys: String, CodingKey {
        case id, idLang = "id_lang", idRef = "id_ref", name, description, createdAt = "created_at", updatedAt = "updated_at"
    }
}
struct LocationLangData: Codable {
    let id: Int
    let idRef: Int
    let idLang: String
    let name: String
    let description: String
    let address: String
    let createdAt: String?
    let updatedAt: String?

    private enum CodingKeys: String, CodingKey {
        case id, idRef = "id_ref", idLang = "id_lang", name, description, address, createdAt = "created_at", updatedAt = "updated_at"
    }
}
struct SearchTourReposnceData: Codable{
    let data : SearchTourData
    private enum CodingKeys: String, CodingKey {
        case data
    }
}
struct SearchTourData: Codable {
    let message: String
    let data: [SearchTour]
    let subscriptions: [String] // Assuming subscriptions are strings, you can change the type accordingly
    
    private enum CodingKeys: String, CodingKey {
        case message
        case data
        case subscriptions
    }
}

struct SearchTour: Codable {
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
    let toursLangData: [SearchTourLangData]
    
    enum CodingKeys: String, CodingKey {
        case id, img, points, duration, distance, audio, video, active, rating
        case userId = "id_user"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case toursLangData = "tours_lang_data"
    }
}

struct SearchTourLangData: Codable {
    let id: Int
    let lang: String
    let refId: Int
    let name: String
    let description: String
    let createdAt: String
    let updatedAt: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case lang = "id_lang"
        case name
        case description
        case refId = "id_ref"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

//enum SearchResult<T: Codable>: Codable {
//    case locations(LocationSearchModelResponce)
//    case tours([SearchTourResponse])
//
//    init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        if let locations = try? container.decode(LocationSearchModelResponce.self, forKey: .data) {
//            self = .locations(locations)
//        } else if let tours = try? container.decode([SearchTourResponse].self, forKey: .data) {
//            self = .tours(tours)
//        } else {
//            throw DecodingError.dataCorruptedError(forKey: .data, in: container, debugDescription: "Unable to decode SearchResult")
//        }
//    }
//
//    func encode(to encoder: Encoder) throws {
//        var container = encoder.container(keyedBy: CodingKeys.self)
//        switch self {
//        case .locations(let locations):
//            try container.encode(locations, forKey: .data)
//        case .tours(let tours):
//            try container.encode(tours, forKey: .data)
//        }
//    }
//
//    private enum CodingKeys: String, CodingKey {
//        case data
//    }
//}

