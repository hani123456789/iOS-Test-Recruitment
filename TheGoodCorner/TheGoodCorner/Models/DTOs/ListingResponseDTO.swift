//
//  ListingResponseDTO.swift
//  TheGoodCorner
//
//  Created by Hani Ben Aissa on 11/8/2026.
//

import Foundation

struct ListingsResponseDTO: Decodable {

    let items: [ListingDTO]
    let total: Int
    let page: Int
    let limit: Int
    let hasMore: Bool

    enum CodingKeys: String, CodingKey {
        case items
        case total
        case page
        case limit
        case hasMore = "has_more"
    }
}

extension ListingsResponseDTO {
    
    func toDomain(baseURL: URL) -> ListingsResponse {
        ListingsResponse(
            listings: items.map {
                $0.toDomain(baseURL: baseURL)
            },
            total: total,
            page: page,
            limit: limit,
            hasMore: hasMore
        )
    }
}
