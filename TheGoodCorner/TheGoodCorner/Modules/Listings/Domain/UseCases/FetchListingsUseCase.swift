//
//  FetchListingsUseCase.swift
//  TheGoodCorner
//
//  Created by Hani Ben Aissa on 11/8/2026.
//
protocol FetchListingsUseCase {

    func execute() async throws -> [Listing]
}

final class FetchListingsUseCaseImp: FetchListingsUseCase {

    private let repository: ListingsRepository

    init(repository: ListingsRepository) {
        self.repository = repository
    }

    func execute() async throws -> [Listing] {
        try await repository.fetchListings()
    }
}
