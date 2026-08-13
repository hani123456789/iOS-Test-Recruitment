//
//  CategoryDTO.swift
//  TheGoodCorner
//
//  Created by Hani Ben Aissa on 13/8/2026.
//

import Foundation

struct CategoryDTO: Decodable {
    let id: Int?
    let name: String?

    enum CodingKeys: String, CodingKey {
        case id
        case name
    }
}

// MARK: - Mapping

extension CategoryDTO {
    
    func toDomain() -> Category {
        Category(
            id: id,
            name: name
        )
    }
}
