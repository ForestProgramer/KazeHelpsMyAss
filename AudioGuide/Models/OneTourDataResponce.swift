//
//  OneTourDataResponce.swift
//  AudioGuide
//
//  Created by Максим Оліярник on 27.03.2024.
//

import Foundation

struct OneTourDetailsResponse: Codable {
    let data: OneTourDataContainer

    enum CodingKeys: String, CodingKey {
        case data
    }
}

struct OneTourDataContainer: Codable {
    let message: String
    let data: OneTourData
    let subscriptions: [OneTourSubscription]

    enum CodingKeys: String, CodingKey {
        case message
        case data
        case subscriptions
    }
}

struct OneTourData: Codable {
    let tourInfo: OneTourInfo
    let tourPoints: [OneTourPoint]

    enum CodingKeys: String, CodingKey {
        case tourInfo = "0"
        case tourPoints
    }
}

struct OneTourInfo: Codable {
    let id: Int
    let idUser: Int
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
    let isFavorite: Bool
    let rating: Int?
    let toursLangData: [OneTourLangData]
    let comments: [OneTourDetailsComment]
    let favorite: TourPointsFavorite?  // Updated to match JSON structure

    enum CodingKeys: String, CodingKey {
        case id
        case idUser = "id_user"
        case img
        case points
        case duration
        case distance
        case audio
        case video
        case active
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case clicks
        case isFavorite = "is_favorite"
        case rating
        case toursLangData = "tours_lang_data"
        case comments
        case favorite
    }
}

struct OneTourLangData: Codable {
    let id: Int
    let idLang: String
    let idRef: Int
    let name: String
    let description: String
    let createdAt: String?
    let updatedAt: String?

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

struct OneTourDetailsComment: Codable {
    let id: Int
    let idTour: Int
    let idUser: Int
    let comment: String
    let active: Int
    let createdAt: String
    let updatedAt: String
    let rating: Int?
    let userData: UserCommentInfos

    enum CodingKeys: String, CodingKey {
        case id
        case idTour = "id_tour"
        case idUser = "id_user"
        case comment
        case active
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case rating
        case userData = "userdata"
    }
}

struct UserCommentInfos: Codable {  // Missing UserCommentInfo structure
    let id: Int
    let name: String?
    let email: String
    let avatar: String
}

struct OneTourPoint: Codable {
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
    let icon: String?
    let clicks: Int?
    let isFavorite: Bool
    let pointLangData: [InTourPointLangData]
    let audio: [OneTourAudio]?  // Updated to array since audio can be multiple
    let favorite: TourPointsFavorite?

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
        case pointLangData = "point_lang_data"
        case audio
        case favorite
    }
}

struct OneTourAudio: Codable {
    let id: Int
    let idPoint: Int
    let idUser: Int
    let audioUrl: String
    let audioTime: String
    let createdAt: String?
    let updatedAt: String?
    let audioURL : String
    let isFavorite: Bool

    enum CodingKeys: String, CodingKey {
        case id
        case idPoint = "id_point"
        case idUser = "id_user"
        case audioUrl = "audio_url"
        case audioTime = "audio_time"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case audioURL = "audioUrl"
        case isFavorite = "is_favorite"
    }
}

struct TourPointsFavorite: Codable {
    let id: Int
    let idUser: Int
    let type: String
    let idObject: Int
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

struct InTourPointLangData: Codable {
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

struct OneTourSubscription: Codable {
    let id: Int
    let userId: Int
    let subscriptionId: Int
    let startTime: String
    let endTime: String?
    let active: Int
    let createdAt: String
    let updatedAt: String
    let diff: Int
    let subscription: OneTourSubscriptionInfo

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

struct OneTourSubscriptionInfo: Codable {
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



