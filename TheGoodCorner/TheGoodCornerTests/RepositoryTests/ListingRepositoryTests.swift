//
//  ListingRepositoryTests.swift
//  TheGoodCornerTests
//
//  Created by Tests on 13/8/2026.
//

import XCTest
@testable import TheGoodCorner

@MainActor
final class ListingRepositoryTests: XCTestCase {
    
    var sut: ListingRepository!
    var mockAPIClient: MockAPIClient!
    var baseURL: URL!
    
    override func setUpWithError() throws {
        mockAPIClient = MockAPIClient()
        baseURL = URL(string: "https://api.example.com")!
        sut = ListingRepository(apiClient: mockAPIClient, baseURL: baseURL)
    }
    
    override func tearDownWithError() throws {
        sut = nil
        mockAPIClient = nil
        baseURL = nil
    }
    
    func testFetchListings_Success() async throws {
        // Given
        let listingDTO = ListingDTO(
            id: 1,
            title: "iPhone 13",
            description: "Good condition",
            price: 500,
            categoryId: 1,
            isUrgent: false,
            creationDate: "2026-08-13",
            imagesURL: ImagesURLDTO(thumb: "/thumb.jpg", small: "/small.jpg")
        )
        let responseDTO = ListingsResponseDTO(
            items: [listingDTO],
            total: 1,
            page: 1,
            limit: 20,
            hasMore: false
        )
        mockAPIClient.mockResponse = responseDTO
        
        // When
        let response = try await sut.fetchListings(page: 1, limit: 20, query: nil)
        
        // Then
        XCTAssertEqual(response.listings.count, 1)
        XCTAssertEqual(response.total, 1)
        XCTAssertEqual(response.page, 1)
        XCTAssertEqual(response.limit, 20)
        XCTAssertFalse(response.hasMore)
        
        let listing = response.listings[0]
        XCTAssertEqual(listing.id, 1)
        XCTAssertEqual(listing.title, "iPhone 13")
        XCTAssertEqual(listing.price, 500)
    }
    
    func testFetchListings_WithPagination() async throws {
        // Given
        let responseDTO = ListingsResponseDTO(
            items: [],
            total: 100,
            page: 2,
            limit: 20,
            hasMore: true
        )
        mockAPIClient.mockResponse = responseDTO
        
        // When
        let response = try await sut.fetchListings(page: 2, limit: 20, query: nil)
        
        // Then
        XCTAssertEqual(response.page, 2)
        XCTAssertTrue(response.hasMore)
    }
    
    func testFetchListings_WithQuery() async throws {
        // Given
        let responseDTO = ListingsResponseDTO(
            items: [],
            total: 10,
            page: 1,
            limit: 20,
            hasMore: false
        )
        mockAPIClient.mockResponse = responseDTO
        
        // When
        let response = try await sut.fetchListings(page: 1, limit: 20, query: "iPhone")
        
        // Then
        XCTAssertEqual(response.total, 10)
    }
    
    func testFetchListings_NetworkError() async {
        // Given
        mockAPIClient.shouldThrowError = true
        mockAPIClient.errorToThrow = APIError.networkError
        
        // When/Then
        do {
            _ = try await sut.fetchListings(page: 1, limit: 20, query: nil)
            XCTFail("Expected error to be thrown")
        } catch let error as APIError {
            XCTAssertEqual(error, .networkError)
        } catch {
            XCTFail("Unexpected error type")
        }
    }
    
    func testFetchListings_HTTPError() async {
        // Given
        mockAPIClient.shouldThrowError = true
        mockAPIClient.errorToThrow = APIError.httpError(statusCode: 404)
        
        // When/Then
        do {
            _ = try await sut.fetchListings(page: 1, limit: 20, query: nil)
            XCTFail("Expected error to be thrown")
        } catch let error as APIError {
            XCTAssertEqual(error, .httpError(statusCode: 404))
        } catch {
            XCTFail("Unexpected error type")
        }
    }
}
