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

    enum State {
        case idle
        case loading
        case loaded([Listing])
        case empty
        case error(APIError)
    }

    @Published private(set) var state: State = .idle
    
    private let fetchListingsUseCase: FetchListingsUseCase

    init(fetchListingsUseCase: FetchListingsUseCase) {
        self.fetchListingsUseCase = fetchListingsUseCase
    }

    func loadListings() async {
        state = .loading

        do {
            let listings = try await fetchListingsUseCase.execute()

            if listings.isEmpty {
                state = .empty
            } else {
                state = .loaded(listings)
            }

        } catch let error as APIError {
            state = .error(error)

        } catch {
            state = .error(.unknown)
        }
    }
}
