//
//  ListingRepository.swift
//  TheGoodCorner
//
//  Created by Hani Ben Aissa on 12/8/2026.
//
import Foundation

@MainActor
final class ListingRepository: ListingRepositoryProtocol {
    private let apiClient: APIClientProtocol
    private let baseURL: URL
    
    init(apiClient: APIClientProtocol, baseURL: URL) {
        self.apiClient = apiClient
        self.baseURL = baseURL
    }
    
    func fetchListings(page: Int?, limit: Int?, query: String?) async throws -> ListingsResponse {
        let response: ListingsResponseDTO = try await apiClient.request (
            .listings(page: page, limit: limit, query: query)
        )
        return response.toDomain(baseURL: baseURL)
    }
}
