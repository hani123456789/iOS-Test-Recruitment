//
//  APIErrorTests.swift
//  TheGoodCornerTests
//
//  Created by Tests on 13/8/2026.
//

import XCTest
@testable import TheGoodCorner

final class APIErrorTests: XCTestCase {
    
    func testAPIError_InvalidURL_ErrorDescription() {
        // Given
        let error = APIError.invalidURL
        
        // When
        let description = error.errorDescription
        
        // Then
        XCTAssertEqual(description, "The request URL is invalid.")
    }
    
    func testAPIError_InvalidResponse_ErrorDescription() {
        // Given
        let error = APIError.invalidResponse
        
        // When
        let description = error.errorDescription
        
        // Then
        XCTAssertEqual(description, "The server returned an invalid response.")
    }
    
    func testAPIError_HTTPError_ErrorDescription() {
        // Given
        let error = APIError.httpError(statusCode: 404)
        
        // When
        let description = error.errorDescription
        
        // Then
        XCTAssertEqual(description, "The server returned an error (HTTP 404).")
    }
    
    func testAPIError_DecodingError_ErrorDescription() {
        // Given
        let error = APIError.decodingError
        
        // When
        let description = error.errorDescription
        
        // Then
        XCTAssertEqual(description, "We couldn't read the server response.")
    }
    
    func testAPIError_NetworkError_ErrorDescription() {
        // Given
        let error = APIError.networkError
        
        // When
        let description = error.errorDescription
        
        // Then
        XCTAssertEqual(description, "Unable to connect to the server.")
    }
    
    func testAPIError_Unknown_ErrorDescription() {
        // Given
        let error = APIError.unknown
        
        // When
        let description = error.errorDescription
        
        // Then
        XCTAssertEqual(description, "Something went wrong. Please try again.")
    }
    
    func testAPIError_Equatable() {
        // Given/When/Then
        XCTAssertEqual(APIError.invalidURL, APIError.invalidURL)
        XCTAssertEqual(APIError.networkError, APIError.networkError)
        XCTAssertEqual(APIError.httpError(statusCode: 404), APIError.httpError(statusCode: 404))
        XCTAssertNotEqual(APIError.httpError(statusCode: 404), APIError.httpError(statusCode: 500))
        XCTAssertNotEqual(APIError.networkError, APIError.unknown)
    }
}
