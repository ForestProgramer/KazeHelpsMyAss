//
//  UsersComments.swift
//  AudioGuide
//
//  Created by Максим Оліярник on 05.04.2024.
//

import Foundation
struct UsersComments{
    let id: Int
    let idPointOrTour: Int
    let idUser: Int
    let comment: String
    let active: Int
    let createdAt: String
    let updatedAt: String
    let rating : Int?
    let userData : UserCommentInfos
}
