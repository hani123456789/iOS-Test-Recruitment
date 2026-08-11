//
//  ListingResponseDTO.swift
//  TheGoodCorner
//
//  Created by Hani Ben Aissa on 11/8/2026.
//

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
