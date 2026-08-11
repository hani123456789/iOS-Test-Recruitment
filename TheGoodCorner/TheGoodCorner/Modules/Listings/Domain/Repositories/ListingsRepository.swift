//
//  ListingRepository.swift
//  TheGoodCorner
//
//  Created by Hani Ben Aissa on 11/8/2026.
//

protocol ListingsRepository {

    func fetchListings() async throws -> [Listing]
}
