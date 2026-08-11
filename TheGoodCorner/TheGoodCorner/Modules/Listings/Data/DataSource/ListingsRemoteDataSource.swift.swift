//
//  ListingsRemoteDataSource.swift.swift
//  TheGoodCorner
//
//  Created by Hani Ben Aissa on 11/8/2026.
//

protocol ListingsRemoteDataSource {

    func fetchListings() async throws -> ListingsResponseDTO
}

final class ListingsRemoteDataSourceImp: ListingsRemoteDataSource {

    private let apiClient: APIClientProtocol

    init(apiClient: APIClientProtocol) {
        self.apiClient = apiClient
    }

    func fetchListings() async throws -> ListingsResponseDTO {
        try await apiClient.request(
            .listings()
        )
    }
}
