//
//  MockListingRepository.swift
//  TheGoodCornerTests
//
//  Created by Tests on 13/8/2026.
//

import Foundation
@testable import TheGoodCorner

@MainActor
final class MockListingRepository: ListingRepositoryProtocol {
    
    var shouldThrowError = false
    var errorToThrow: Error = APIError.unknown
    var mockResponse: ListingsResponse?
    var fetchCallsCount = 0
    var lastFetchParameters: (page: Int?, limit: Int?, query: String?)?
    
    func fetchListings(page: Int?, limit: Int?, query: String?) async throws -> ListingsResponse {
        fetchCallsCount += 1
        lastFetchParameters = (page, limit, query)
        
        if shouldThrowError {
            throw errorToThrow
        }
        
        guard let response = mockResponse else {
            throw APIError.unknown
        }
        
        return response
    }
}
