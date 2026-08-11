//
//  ListingsRepositoryImp.swift
//  TheGoodCorner
//
//  Created by Hani Ben Aissa on 11/8/2026.
//

import Foundation

final class ListingsRepositoryImp: ListingsRepository {

    private let remoteDataSource: ListingsRemoteDataSource
    private let baseURL: URL

    init(
        remoteDataSource: ListingsRemoteDataSource,
        baseURL: URL
    ) {
        self.remoteDataSource = remoteDataSource
        self.baseURL = baseURL
    }

    func fetchListings() async throws -> [Listing] {

        let response = try await remoteDataSource.fetchListings()

        return response.items.map {
            $0.toDomain(baseURL: baseURL)
        }
    }
}
