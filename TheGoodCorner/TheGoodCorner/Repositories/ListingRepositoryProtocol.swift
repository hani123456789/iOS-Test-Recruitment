//
//  ListingRepository.swift
//  TheGoodCorner
//
//  Created by Hani Ben Aissa on 12/8/2026.
//

import Foundation

@MainActor
protocol ListingRepositoryProtocol {
    func fetchListings(page: Int?, limit: Int?, query: String?) async throws -> ListingsResponse
}
