//
//  ListingsViewModel.swift
//  TheGoodCorner
//
//  Created by Hani Ben Aissa on 10/8/2026.
//
import SwiftUI
import Foundation
import Combine

@MainActor
final class ListingsViewModel: ObservableObject {

    // MARK: - Published Properties
    
    @Published private(set) var categories: [Category] = []
    @Published var selectedCategory: Category?
    @Published private(set) var state: State = .idle
    @Published private(set) var listings: [Listing] = []
    @Published private(set) var isLoadingNextPage = false
   

    private var currentPage = 0
    private var hasMore = true
    private var categoryNames: [Int?: String?] = [:]
    
    private let listingRepository: ListingRepositoryProtocol
    private let categoriesRepository: CategoriesRepositoryProtocol

    init(listingRepository: ListingRepositoryProtocol, categoriesRepository: CategoriesRepositoryProtocol) {
        self.listingRepository = listingRepository
        self.categoriesRepository = categoriesRepository
    }

    
    var displayedListings: [Listing] {
        guard let selectedCategory else {
            return listings
        }
        return listings.filter {
            $0.categoryId == selectedCategory.id
        }
    }
    
    func loadInitialData() async {
        state = .loading
        do {
            async let categoriesTask =
                categoriesRepository.fetchCategories()

            async let listingsTask =
                listingRepository.fetchListings(
                    page: 1,
                    limit: 20,
                    query: nil
                )

            let fetchedCategories = try await categoriesTask
            let response = try await listingsTask

            categories = fetchedCategories
            listings = response.listings

            categoryNames = Dictionary(
                            uniqueKeysWithValues: fetchedCategories.map {
                                ($0.id, $0.name)
                            }
                        )
            
            currentPage = 1
            hasMore = response.hasMore

            state = listings.isEmpty ? .empty : .loaded
        } catch let error as APIError {
            state = .error(error)
        } catch {
            state = .error(.unknown)
        }
    }
    
    
    func loadNextPage() async {
        guard hasMore, !isLoadingNextPage else {
            return
        }
        isLoadingNextPage = true
        defer {
            isLoadingNextPage = false
        }
        do {
            let nextPage = currentPage + 1

            let response = try await listingRepository.fetchListings(
                page: nextPage,
                limit: 20,
                query: nil
            )

            let existingIDs = Set(listings.map(\.id))

            let newListings = response.listings.filter {
                !existingIDs.contains($0.id)
            }
            listings.append(contentsOf: newListings)
            currentPage = nextPage
            hasMore = response.hasMore
            state = .loaded
        } catch {
            // Keep the existing listings.
            // You can expose a pagination error/retry state later.
        }
    }
    
    func selectCategory(_ category: Category?) async {
        selectedCategory = category
        guard category != nil else {
            return
        }
        await loadPagesUntilCategoryHasResults()
    }
    
    private func loadPagesUntilCategoryHasResults() async {
        while hasMore {
            let filtered = displayedListings
            if !filtered.isEmpty {
                return
            }
            await loadNextPage()
        }
    }

    func selectAllCategories() {
        selectedCategory = nil
    }
    
    func categoryName(for categoryId: Int?) -> String? {
        guard let categoryId else {
            return AppStrings.Listings.allCategories
        }
        return categoryNames[categoryId]  ?? AppStrings.Listings.allCategories
    }
}
