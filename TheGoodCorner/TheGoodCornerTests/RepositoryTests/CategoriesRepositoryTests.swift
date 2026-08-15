//
//  CategoriesRepositoryTests.swift
//  TheGoodCornerTests
//
//  Created by Tests on 13/8/2026.
//

import XCTest
@testable import TheGoodCorner

@MainActor
final class CategoriesRepositoryTests: XCTestCase {
    
    var sut: CategoriesRepository!
    var mockAPIClient: MockAPIClient!
    
    override func setUpWithError() throws {
        mockAPIClient = MockAPIClient()
        sut = CategoriesRepository(apiClient: mockAPIClient)
    }
    
    override func tearDownWithError() throws {
        sut = nil
        mockAPIClient = nil
    }
    
    func testFetchCategories_Success() async throws {
        // Given
        let categoryDTOs = [
            CategoryDTO(id: 1, name: "Electronics"),
            CategoryDTO(id: 2, name: "Home")
        ]
        mockAPIClient.mockResponse = categoryDTOs
        
        // When
        let categories = try await sut.fetchCategories()
        
        // Then
        XCTAssertEqual(categories.count, 2)
        XCTAssertEqual(categories[0].id, 1)
        XCTAssertEqual(categories[0].name, "Electronics")
        XCTAssertEqual(categories[1].id, 2)
        XCTAssertEqual(categories[1].name, "Home")
    }
    
    func testFetchCategories_EmptyResponse() async throws {
        // Given
        let categoryDTOs: [CategoryDTO] = []
        mockAPIClient.mockResponse = categoryDTOs
        
        // When
        let categories = try await sut.fetchCategories()
        
        // Then
        XCTAssertTrue(categories.isEmpty)
    }
    
    func testFetchCategories_NetworkError() async {
        // Given
        mockAPIClient.shouldThrowError = true
        mockAPIClient.errorToThrow = APIError.networkError
        
        // When/Then
        do {
            _ = try await sut.fetchCategories()
            XCTFail("Expected error to be thrown")
        } catch let error as APIError {
            XCTAssertEqual(error, .networkError)
        } catch {
            XCTFail("Unexpected error type")
        }
    }
    
    func testFetchCategories_DecodingError() async {
        // Given
        mockAPIClient.shouldThrowError = true
        mockAPIClient.errorToThrow = APIError.decodingError
        
        // When/Then
        do {
            _ = try await sut.fetchCategories()
            XCTFail("Expected error to be thrown")
        } catch let error as APIError {
            XCTAssertEqual(error, .decodingError)
        } catch {
            XCTFail("Unexpected error type")
        }
    }
}
