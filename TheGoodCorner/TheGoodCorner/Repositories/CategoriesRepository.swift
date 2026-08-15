//
//  CategoriesRepository.swift
//  TheGoodCorner
//
//  Created by Hani Ben Aissa on 12/8/2026.
//
import Foundation

@MainActor
final class CategoriesRepository: CategoriesRepositoryProtocol {
    private let apiClient: APIClientProtocol
    
    init(apiClient: APIClientProtocol) {
        self.apiClient = apiClient
    }
    
    func fetchCategories() async throws -> [Category] {
        let response: [CategoryDTO] = try await apiClient.request (
            .categories
        )
        return response.map {
            $0.toDomain()
        }
    }
}

