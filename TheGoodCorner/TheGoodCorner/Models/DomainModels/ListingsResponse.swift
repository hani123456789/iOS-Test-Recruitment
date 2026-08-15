//
//  ListingsResponse.swift
//  TheGoodCorner
//
//  Created by Hani Ben Aissa on 13/8/2026.
//

struct ListingsResponse: Equatable {
    let listings: [Listing]
    let total: Int
    let page: Int
    let limit: Int
    let hasMore: Bool
}
