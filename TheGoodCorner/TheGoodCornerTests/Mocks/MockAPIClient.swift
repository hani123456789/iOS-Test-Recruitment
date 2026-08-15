//
//  MockAPIClient.swift
//  TheGoodCornerTests
//
//  Created by Tests on 13/8/2026.
//

import Foundation
@testable import TheGoodCorner

final class MockAPIClient: APIClientProtocol {
    
    var shouldThrowError = false
    var errorToThrow: Error = APIError.unknown
    var mockResponse: Any?
    
    func request<T: Decodable>(_ endpoint: Endpoint) async throws -> T {
        if shouldThrowError {
            throw errorToThrow
        }
        
        guard let response = mockResponse as? T else {
            throw APIError.decodingError
        }
        
        return response
    }
}
