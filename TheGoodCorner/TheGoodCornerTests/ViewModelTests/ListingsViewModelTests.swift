//
//  ListingsViewModelTests.swift
//  TheGoodCornerTests
//
//  Created by Tests on 13/8/2026.
//

import XCTest
@testable import TheGoodCorner

@MainActor
final class ListingsViewModelTests: XCTestCase {
    
    var sut: ListingsViewModel!
    var mockListingRepository: MockListingRepository!
    var mockCategoriesRepository: MockCategoriesRepository!
    
    override func setUpWithError() throws {
        mockListingRepository = MockListingRepository()
        mockCategoriesRepository = MockCategoriesRepository()
        sut = ListingsViewModel(
            listingRepository: mockListingRepository,
            categoriesRepository: mockCategoriesRepository
        )
    }
    
    override func tearDownWithError() throws {
        sut = nil
        mockListingRepository = nil
        mockCategoriesRepository = nil
    }
    
    // MARK: - Initial Data Loading Tests
    
    func testLoadInitialData_Success() async {
        // Given
        let categories = [
            Category(id: 1, name: "Electronics"),
            Category(id: 2, name: "Home")
        ]
        mockCategoriesRepository.mockCategories = categories
        
        let listings = [
            Listing(id: 1, title: "iPhone", description: "Good", price: 500, categoryId: 1, isUrgent: false, creationDate: "2026-08-13", thumbnailURL: nil, imageURL: nil),
            Listing(id: 2, title: "Laptop", description: "New", price: 1000, categoryId: 1, isUrgent: true, creationDate: "2026-08-12", thumbnailURL: nil, imageURL: nil)
        ]
        let response = ListingsResponse(listings: listings, total: 2, page: 1, limit: 20, hasMore: false)
        mockListingRepository.mockResponse = response
        
        // When
        await sut.loadInitialData()
        
        // Then
        XCTAssertEqual(sut.categories.count, 2)
        XCTAssertEqual(sut.listings.count, 2)
        XCTAssertEqual(sut.state, .loaded)
    }
    
    func testLoadInitialData_EmptyResponse() async {
        // Given
        mockCategoriesRepository.mockCategories = []
        let response = ListingsResponse(listings: [], total: 0, page: 1, limit: 20, hasMore: false)
        mockListingRepository.mockResponse = response
        
        // When
        await sut.loadInitialData()
        
        // Then
        XCTAssertTrue(sut.listings.isEmpty)
        XCTAssertEqual(sut.state, .empty)
    }
    
    func testLoadInitialData_NetworkError() async {
        // Given
        mockListingRepository.shouldThrowError = true
        mockListingRepository.errorToThrow = APIError.networkError
        
        // When
        await sut.loadInitialData()
        
        // Then
        if case .error(let error) = sut.state {
            XCTAssertEqual(error, .networkError)
        } else {
            XCTFail("Expected error state")
        }
    }
    
    func testLoadInitialData_StateTransitions() async {
        // Given
        mockCategoriesRepository.mockCategories = []
        let response = ListingsResponse(listings: [], total: 0, page: 1, limit: 20, hasMore: false)
        mockListingRepository.mockResponse = response
        
        // Initial state
        XCTAssertEqual(sut.state, .idle)
        
        // When
        let task = Task {
            await sut.loadInitialData()
        }
        
        // Then - Should transition through loading
        try? await Task.sleep(nanoseconds: 1_000_000) // Small delay
        await task.value
        
        // Final state
        XCTAssertEqual(sut.state, .empty)
    }
    
    // MARK: - Pagination Tests
    
    func testLoadNextPage_Success() async {
        // Given
        let initialListings = [
            Listing(id: 1, title: "Item 1", description: nil, price: 100, categoryId: 1, isUrgent: false, creationDate: "2026-08-13", thumbnailURL: nil, imageURL: nil)
        ]
        let initialResponse = ListingsResponse(listings: initialListings, total: 3, page: 1, limit: 1, hasMore: true)
        mockListingRepository.mockResponse = initialResponse
        mockCategoriesRepository.mockCategories = []
        
        await sut.loadInitialData()
        
        // Setup next page
        let nextPageListings = [
            Listing(id: 2, title: "Item 2", description: nil, price: 200, categoryId: 1, isUrgent: false, creationDate: "2026-08-12", thumbnailURL: nil, imageURL: nil)
        ]
        let nextPageResponse = ListingsResponse(listings: nextPageListings, total: 3, page: 2, limit: 1, hasMore: true)
        mockListingRepository.mockResponse = nextPageResponse
        
        // When
        await sut.loadNextPage()
        
        // Then
        XCTAssertEqual(sut.listings.count, 2)
        XCTAssertEqual(mockListingRepository.fetchCallsCount, 2)
        XCTAssertEqual(mockListingRepository.lastFetchParameters?.page, 2)
    }
    
    func testLoadNextPage_NoDuplicates() async {
        // Given
        let initialListings = [
            Listing(id: 1, title: "Item 1", description: nil, price: 100, categoryId: 1, isUrgent: false, creationDate: "2026-08-13", thumbnailURL: nil, imageURL: nil)
        ]
        let initialResponse = ListingsResponse(listings: initialListings, total: 2, page: 1, limit: 1, hasMore: true)
        mockListingRepository.mockResponse = initialResponse
        mockCategoriesRepository.mockCategories = []
        
        await sut.loadInitialData()
        
        // Setup next page with duplicate
        let duplicateResponse = ListingsResponse(listings: initialListings, total: 2, page: 2, limit: 1, hasMore: false)
        mockListingRepository.mockResponse = duplicateResponse
        
        // When
        await sut.loadNextPage()
        
        // Then - Should not add duplicate
        XCTAssertEqual(sut.listings.count, 1)
    }
    
    func testLoadNextPage_WhenNoMorePages() async {
        // Given
        let listings = [
            Listing(id: 1, title: "Item 1", description: nil, price: 100, categoryId: 1, isUrgent: false, creationDate: "2026-08-13", thumbnailURL: nil, imageURL: nil)
        ]
        let response = ListingsResponse(listings: listings, total: 1, page: 1, limit: 20, hasMore: false)
        mockListingRepository.mockResponse = response
        mockCategoriesRepository.mockCategories = []
        
        await sut.loadInitialData()
        XCTAssertEqual(mockListingRepository.fetchCallsCount, 1)
        
        // When
        await sut.loadNextPage()
        
        // Then - Should not fetch
        XCTAssertEqual(mockListingRepository.fetchCallsCount, 1)
    }
    
    func testLoadNextPage_PreventsConcurrentLoads() async {
        // Given
        let listings = [
            Listing(id: 1, title: "Item 1", description: nil, price: 100, categoryId: 1, isUrgent: false, creationDate: "2026-08-13", thumbnailURL: nil, imageURL: nil)
        ]
        let response = ListingsResponse(listings: listings, total: 10, page: 1, limit: 1, hasMore: true)
        mockListingRepository.mockResponse = response
        mockCategoriesRepository.mockCategories = []
        
        await sut.loadInitialData()
        
        // When - Trigger concurrent loads
        await withTaskGroup(of: Void.self) { group in
            group.addTask { await self.sut.loadNextPage() }
            group.addTask { await self.sut.loadNextPage() }
        }
        
        // Then - Should only fetch once more
        XCTAssertEqual(mockListingRepository.fetchCallsCount, 2)
    }
    
    // MARK: - Category Filter Tests
    
    func testDisplayedListings_WithoutFilter() {
        // Given
        let listings = [
            Listing(id: 1, title: "Item 1", description: nil, price: 100, categoryId: 1, isUrgent: false, creationDate: "2026-08-13", thumbnailURL: nil, imageURL: nil),
            Listing(id: 2, title: "Item 2", description: nil, price: 200, categoryId: 2, isUrgent: false, creationDate: "2026-08-12", thumbnailURL: nil, imageURL: nil)
        ]
        let response = ListingsResponse(listings: listings, total: 2, page: 1, limit: 20, hasMore: false)
        mockListingRepository.mockResponse = response
        mockCategoriesRepository.mockCategories = []
        
        Task {
            await sut.loadInitialData()
        }
        
        // When/Then
        XCTAssertEqual(sut.displayedListings.count, 2)
    }
    
    func testDisplayedListings_WithCategoryFilter() async {
        // Given
        let categories = [
            Category(id: 1, name: "Electronics"),
            Category(id: 2, name: "Home")
        ]
        mockCategoriesRepository.mockCategories = categories
        
        let listings = [
            Listing(id: 1, title: "Item 1", description: nil, price: 100, categoryId: 1, isUrgent: false, creationDate: "2026-08-13", thumbnailURL: nil, imageURL: nil),
            Listing(id: 2, title: "Item 2", description: nil, price: 200, categoryId: 2, isUrgent: false, creationDate: "2026-08-12", thumbnailURL: nil, imageURL: nil),
            Listing(id: 3, title: "Item 3", description: nil, price: 300, categoryId: 1, isUrgent: false, creationDate: "2026-08-11", thumbnailURL: nil, imageURL: nil)
        ]
        let response = ListingsResponse(listings: listings, total: 3, page: 1, limit: 20, hasMore: false)
        mockListingRepository.mockResponse = response
        
        await sut.loadInitialData()
        
        // When
        await sut.selectCategory(categories[0])
        
        // Then
        XCTAssertEqual(sut.displayedListings.count, 2)
        XCTAssertTrue(sut.displayedListings.allSatisfy { $0.categoryId == 1 })
    }
    
    func testSelectAllCategories() async {
        // Given
        let category = Category(id: 1, name: "Electronics")
        await sut.selectCategory(category)
        XCTAssertNotNil(sut.selectedCategory)
        
        // When
        sut.selectAllCategories()
        
        // Then
        XCTAssertNil(sut.selectedCategory)
    }
    
    // MARK: - Category Name Tests
    
    func testCategoryName_ForValidId() async {
        // Given
        let categories = [
            Category(id: 1, name: "Electronics"),
            Category(id: 2, name: "Home")
        ]
        mockCategoriesRepository.mockCategories = categories
        let response = ListingsResponse(listings: [], total: 0, page: 1, limit: 20, hasMore: false)
        mockListingRepository.mockResponse = response
        
        await sut.loadInitialData()
        
        // When
        let name = sut.categoryName(for: 1)
        
        // Then
        XCTAssertEqual(name, "Electronics")
    }
    
    func testCategoryName_ForNilId() async {
        // When
        let name = sut.categoryName(for: nil)
        
        // Then
        XCTAssertEqual(name, "Tous")
    }
    
    func testCategoryName_ForInvalidId() async {
        // Given
        mockCategoriesRepository.mockCategories = []
        let response = ListingsResponse(listings: [], total: 0, page: 1, limit: 20, hasMore: false)
        mockListingRepository.mockResponse = response
        
        await sut.loadInitialData()
        
        // When
        let name = sut.categoryName(for: 999)
        
        // Then
        XCTAssertEqual(name, "Tous")
    }
}
