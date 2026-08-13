//
//  EndpointTests.swift
//  TheGoodCornerTests
//
//  Created by Tests on 13/8/2026.
//

import XCTest
@testable import TheGoodCorner

final class EndpointTests: XCTestCase {
    
    var baseURL: URL!
    
    override func setUpWithError() throws {
        baseURL = URL(string: "https://api.example.com")!
    }
    
    override func tearDownWithError() throws {
        baseURL = nil
    }
    
    // MARK: - Categories Endpoint Tests
    
    func testCategoriesEndpoint_URL() {
        // Given
        let endpoint = Endpoint.categories
        
        // When
        let url = endpoint.url(baseURL: baseURL)
        
        // Then
        XCTAssertNotNil(url)
        XCTAssertEqual(url?.absoluteString, "https://api.example.com/categories")
    }
    
    func testCategoriesEndpoint_Method() {
        // Given
        let endpoint = Endpoint.categories
        
        // When
        let method = endpoint.method
        
        // Then
        XCTAssertEqual(method, .GET)
    }
    
    // MARK: - Listings Endpoint Tests
    
    func testListingsEndpoint_URLWithoutParameters() {
        // Given
        let endpoint = Endpoint.listings(page: nil, limit: nil, query: nil)
        
        // When
        let url = endpoint.url(baseURL: baseURL)
        
        // Then
        XCTAssertNotNil(url)
        XCTAssertEqual(url?.absoluteString, "https://api.example.com/listings")
    }
    
    func testListingsEndpoint_URLWithPage() {
        // Given
        let endpoint = Endpoint.listings(page: 2, limit: nil, query: nil)
        
        // When
        let url = endpoint.url(baseURL: baseURL)
        
        // Then
        XCTAssertNotNil(url)
        XCTAssertTrue(url?.absoluteString.contains("page=2") ?? false)
    }
    
    func testListingsEndpoint_URLWithLimit() {
        // Given
        let endpoint = Endpoint.listings(page: nil, limit: 20, query: nil)
        
        // When
        let url = endpoint.url(baseURL: baseURL)
        
        // Then
        XCTAssertNotNil(url)
        XCTAssertTrue(url?.absoluteString.contains("limit=20") ?? false)
    }

    
    func testListingsEndpoint_Method() {
        // Given
        let endpoint = Endpoint.listings(page: 1, limit: 20, query: nil)
        
        // When
        let method = endpoint.method
        
        // Then
        XCTAssertEqual(method, .GET)
    }
}
