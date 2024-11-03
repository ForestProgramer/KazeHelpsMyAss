//
//  SuccessUpdatedPointListCommentsResponce.swift
//  AudioGuide
//
//  Created by Максим Оліярник on 03.04.2024.
//

import Foundation
struct SuccessUpdatedPointListCommentsResponce: Codable {
    let data: CommentData
    let message: String
}

struct CommentData: Codable {
    let active: Int
    let comment: String
    let createdAt: String
    let id: Int
    let idPoint: Int
    let idUser: Int
    let pointsRating: [PointRating]
    let updatedAt: String
    
    enum CodingKeys: String, CodingKey {
        case active, comment, id, idPoint, idUser, pointsRating
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

struct PointRating: Codable {
    let active: Int
    let createdAt: String
    let id: Int
    let idComment: Int
    let idPoint: Int
    let idUser: Int
    let updatedAt: String
    let value: Int
    
    enum CodingKeys: String, CodingKey {
        case active, id, value
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case idComment = "id_comment"
        case idPoint = "id_point"
        case idUser = "id_user"
    }
}
