//
//  MockCategoriesRepository.swift
//  TheGoodCornerTests
//
//  Created by Tests on 13/8/2026.
//

import Foundation
@testable import TheGoodCorner

@MainActor
final class MockCategoriesRepository: CategoriesRepositoryProtocol {
    
    var shouldThrowError = false
    var errorToThrow: Error = APIError.unknown
    var mockCategories: [TheGoodCorner.Category] = []
    
    func fetchCategories() async throws -> [TheGoodCorner.Category] {
        if shouldThrowError {
            throw errorToThrow
        }
        return mockCategories
    }
}
