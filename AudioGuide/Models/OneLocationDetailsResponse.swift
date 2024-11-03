//
//  OneLocationDetailsResponse.swift
//  AudioGuide
//
//  Created by Максим Оліярник on 04.03.2024.
//

import Foundation

struct OneLocationDetailsResponse: Codable {
    let data: OneLocationData

    enum CodingKeys: String, CodingKey {
        case data
    }
}

struct OneLocationData: Codable {
    let message: String
    let data: OneLocation
    let subscriptions: [Subscription]

    enum CodingKeys: String, CodingKey {
        case message, data, subscriptions
    }
}

struct OneLocation: Codable {
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
    let clicks: Int
    let isFavorite : Bool
    let tours: [LocationTour]
    let pointLangData: [OnePointLangData]
    let comments: [OnePointDetailsComment]
    let favorite : OneLocationFavouriteData?

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
        case clicks
        case isFavorite = "is_favorite"
        case tours
        case pointLangData = "point_lang_data"
        case comments
        case favorite
    }
}
struct OneLocationFavouriteData : Codable{
    let id : Int
    let idUser : Int
    let type : String
    let idObject : Int
    let createdAt: String?
    let updatedAt: String?
    enum CodingKeys: String, CodingKey {
        case id
        case idUser = "id_user"
        case type
        case idObject = "id_object"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}
struct LocationTour: Codable {
    let id: Int
    let userId: Int
    let img: String
    let points: String
    let duration: String
    let distance: String
    let audio: String?
    let video: String?
    let active: Int
    let createdAt: String?
    let updatedAt: String?
    let clicks: Int
    let toursLangData: [OneLocationTourLangData]

    enum CodingKeys: String, CodingKey {
        case id, img, points, duration, distance, audio, video, active, clicks
        case userId = "id_user"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case toursLangData = "tours_lang_data"
    }
}
struct OneLocationTourLangData: Codable {
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
struct LocationTourLangData: Codable {
    let id: Int
    let langId: String
    let refId: Int
    let name: String
    let description: String
    let createdAt: String
    let updatedAt: String

    enum CodingKeys: String, CodingKey {
        case id, name, description
        case langId = "id_lang"
        case refId = "id_ref"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

struct OnePointLangData: Codable {
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
struct OnePointDetailsComment: Codable {
    let id: Int
    let idPoint: Int
    let idUser: Int
    let comment: String
    let active: Int
    let createdAt: String
    let updatedAt: String
    let rating : Int?
    let userData : UserCommentInfos

    enum CodingKeys: String, CodingKey {
        case id
        case idPoint = "id_point"
        case idUser = "id_user"
        case comment
        case active
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case rating
        case userData = "userdata"
    }
}
struct UserCommentInfo : Codable{
    let id : Int
    let name : String?
    let email : String
    let avatar : String
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case email
        case avatar
    }
}
struct OnePointRating: Codable {
    let idPoint: Int
    let value: Int
    enum CodingKeys: String, CodingKey {
        case idPoint = "id_point"
        case value
    }
    
}
struct Subscription: Codable {
    let id: Int
    let userId: Int
    let subscriptionId: Int
    let startTime: String
    let endTime: String?
    let active: Int
    let createdAt: String
    let updatedAt: String
    let diff: Int
    let subscription: SubscriptionInfo
    
    enum CodingKeys: String, CodingKey {
        case id
        case userId = "id_user"
        case subscriptionId = "id_subscription"
        case startTime = "start_time"
        case endTime = "end_time"
        case active
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case diff
        case subscription
    }
}

struct SubscriptionInfo: Codable {
    let id: Int
    let name: String
    let periodHours: String
    let createdAt: String?
    let updatedAt: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case periodHours = "period_hours"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}
