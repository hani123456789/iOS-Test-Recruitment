//
//  DTOMappingTests.swift
//  TheGoodCornerTests
//
//  Created by Tests on 13/8/2026.
//

import XCTest
@testable import TheGoodCorner

final class DTOMappingTests: XCTestCase {
    
    // MARK: - CategoryDTO Mapping Tests
    
    func testCategoryDTO_ToDomain() {
        // Given
        let dto = CategoryDTO(id: 1, name: "Electronics")
        
        // When
        let domain = dto.toDomain()
        
        // Then
        XCTAssertEqual(domain.id, 1)
        XCTAssertEqual(domain.name, "Electronics")
    }
    
    func testCategoryDTO_ToDomain_WithNilValues() {
        // Given
        let dto = CategoryDTO(id: nil, name: nil)
        
        // When
        let domain = dto.toDomain()
        
        // Then
        XCTAssertNil(domain.id)
        XCTAssertNil(domain.name)
    }
    
    // MARK: - ListingDTO Mapping Tests
    
    func testListingDTO_ToDomain() {
        // Given
        let baseURL = URL(string: "https://api.example.com")!
        let imagesURL = ImagesURLDTO(thumb: "/images/thumb.jpg", small: "/images/small.jpg")
        let dto = ListingDTO(
            id: 1,
            title: "iPhone 13",
            description: "Good condition",
            price: 500,
            categoryId: 2,
            isUrgent: true,
            creationDate: "2026-08-13",
            imagesURL: imagesURL
        )
        
        // When
        let domain = dto.toDomain(baseURL: baseURL)
        
        // Then
        XCTAssertEqual(domain.id, 1)
        XCTAssertEqual(domain.title, "iPhone 13")
        XCTAssertEqual(domain.description, "Good condition")
        XCTAssertEqual(domain.price, 500)
        XCTAssertEqual(domain.categoryId, 2)
        XCTAssertEqual(domain.isUrgent, true)
        XCTAssertEqual(domain.creationDate, "2026-08-13")
        XCTAssertNotNil(domain.thumbnailURL)
        XCTAssertNotNil(domain.imageURL)
    }
    
    func testListingDTO_ToDomain_WithNilImages() {
        // Given
        let baseURL = URL(string: "https://api.example.com")!
        let dto = ListingDTO(
            id: 1,
            title: "Test Item",
            description: nil,
            price: 100,
            categoryId: 1,
            isUrgent: false,
            creationDate: "2026-08-13",
            imagesURL: nil
        )
        
        // When
        let domain = dto.toDomain(baseURL: baseURL)
        
        // Then
        XCTAssertNil(domain.thumbnailURL)
        XCTAssertNil(domain.imageURL)
    }
    
    func testListingDTO_ToDomain_ImageURLConstruction() {
        // Given
        let baseURL = URL(string: "https://api.example.com")!
        let imagesURL = ImagesURLDTO(thumb: "/thumb.jpg", small: "/small.jpg")
        let dto = ListingDTO(
            id: 1,
            title: "Test",
            description: nil,
            price: 100,
            categoryId: 1,
            isUrgent: false,
            creationDate: "2026-08-13",
            imagesURL: imagesURL
        )
        
        // When
        let domain = dto.toDomain(baseURL: baseURL)
        
        // Then
        XCTAssertEqual(domain.thumbnailURL?.absoluteString, "https://api.example.com/thumb.jpg")
        XCTAssertEqual(domain.imageURL?.absoluteString, "https://api.example.com/small.jpg")
    }
    
    // MARK: - ListingsResponseDTO Mapping Tests
    
    func testListingsResponseDTO_ToDomain() {
        // Given
        let baseURL = URL(string: "https://api.example.com")!
        let listing1 = ListingDTO(
            id: 1,
            title: "Item 1",
            description: nil,
            price: 100,
            categoryId: 1,
            isUrgent: false,
            creationDate: "2026-08-13",
            imagesURL: nil
        )
        let listing2 = ListingDTO(
            id: 2,
            title: "Item 2",
            description: nil,
            price: 200,
            categoryId: 2,
            isUrgent: true,
            creationDate: "2026-08-12",
            imagesURL: nil
        )
        
        let dto = ListingsResponseDTO(
            items: [listing1, listing2],
            total: 50,
            page: 2,
            limit: 20,
            hasMore: true
        )
        
        // When
        let domain = dto.toDomain(baseURL: baseURL)
        
        // Then
        XCTAssertEqual(domain.listings.count, 2)
        XCTAssertEqual(domain.total, 50)
        XCTAssertEqual(domain.page, 2)
        XCTAssertEqual(domain.limit, 20)
        XCTAssertTrue(domain.hasMore)
    }
    
    func testListingsResponseDTO_ToDomain_EmptyItems() {
        // Given
        let baseURL = URL(string: "https://api.example.com")!
        let dto = ListingsResponseDTO(
            items: [],
            total: 0,
            page: 1,
            limit: 20,
            hasMore: false
        )
        
        // When
        let domain = dto.toDomain(baseURL: baseURL)
        
        // Then
        XCTAssertTrue(domain.listings.isEmpty)
        XCTAssertEqual(domain.total, 0)
        XCTAssertFalse(domain.hasMore)
    }
}
