//
//  SearchEnums.swift
//  AudioGuide
//
//  Created by Максим Оліярник on 05.02.2024.
//

import Foundation
enum OrderBy: String {
    case rating
    case id
    case id_group
    case created_at
    case updated_at
}

enum Sort: String {
    case desc
    case asc
}

enum TypeFilter: String {
    case locations
    case tours
}

enum Mode: String {
    case toursInPoints
}
