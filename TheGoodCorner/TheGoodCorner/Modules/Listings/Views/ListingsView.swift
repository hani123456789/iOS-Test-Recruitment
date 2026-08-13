//
//  ListingsView.swift
//  TheGoodCorner
//
//  Created by Hani Ben Aissa on 10/8/2026.
//
import Foundation
import SwiftUI

struct ListingsView: View {

    @StateObject private var viewModel: ListingsViewModel

    init(viewModel: ListingsViewModel) {
        _viewModel = StateObject(
            wrappedValue: viewModel
        )
    }    
    
    var body: some View {
        NavigationStack {
            Group {
                switch viewModel.state {
                    
                case .loading:
                    ListingsLoadingView()
                    
                case .loaded:

                    ScrollView {

                        LazyVStack(
                            alignment: .leading,
                            spacing: 16
                        ) {

                            categoryFilter

                            
                            listingsSection(listings: viewModel.displayedListings)
                        }
                        .padding(.horizontal, 16)
                        .padding(.bottom, 24)
                    }
                    .background(Color.appBackground)
                    
                case .empty:
                    EmptyStateView()
                    
                case .error(let error):
                    ListingsErrorView(errorMessage: error.errorDescription ?? "Something went wrong. Please try again.") {
                        Task { await viewModel.loadInitialData() }
                    }
                    
                case .idle:
                    Color.clear
                }
            }
            .navigationTitle("Listings")

        }
        .task {
            await viewModel.loadInitialData()
        }
    }

    func listingsSection(
        listings: [Listing]
    ) -> some View {

        LazyVStack(spacing: 16) {

            ForEach(listings) { listing in

                NavigationLink {
                    ListingDetailView(
                        listing: listing
                    )
                } label: {
                    ListingCardView(listing: listing,
                                    categoryName: viewModel.categoryName(for: listing.categoryId)
                    )
                }
                .buttonStyle(.plain)
                .onAppear {
                    if listing.id ==
                        viewModel.displayedListings.last?.id {
                        Task {
                            await viewModel.loadNextPage()
                        }
                    }
                }
            }
            if viewModel.isLoadingNextPage {
                ProgressView()
                    .padding(.vertical, 20)
            }
            
        }
    }
}

private extension ListingsView {

    var categoryFilter: some View {

        ScrollView(
            .horizontal,
            showsIndicators: false
        ) {

            HStack(spacing: 8) {

                // MARK: Tous

                categoryButton(
                    title: "Tous",
                    isSelected:
                        viewModel.selectedCategory == nil
                ) {
                    viewModel.selectAllCategories()
                }

                // MARK: API Categories

                ForEach(
                    viewModel.categories,
                    id: \.id
                ) { category in

                    categoryButton(
                        title: category.name ?? "",
                        isSelected:
                            viewModel.selectedCategory?.id
                            == category.id
                    ) {
                        Task {
                            await viewModel.selectCategory(category)
                        }
                    }
                }
            }
        }
        .padding(.vertical, 4)
        .accessibilityElement(
            children: .contain
        )
        .accessibilityLabel(
            "Filtrer par catégorie"
        )
    }
    
    
        func categoryButton(
            title: String,
            isSelected: Bool,
            action: @escaping () -> Void
        ) -> some View {

            Button {

                withAnimation(
                    .easeInOut(duration: 0.2)
                ) {
                    action()
                }

            } label: {

                Text(title)
                    .font(
                        .subheadline.weight(
                            isSelected
                                ? .semibold
                                : .regular
                        )
                    )
                    .foregroundStyle(
                        isSelected
                            ? .white
                            : Color.appText
                    )
                    .padding(
                        .horizontal,
                        16
                    )
                    .padding(
                        .vertical,
                        9
                    )
                    .background(
                        isSelected
                            ? Color.appOrange
                            : Color.white
                    )
                    .clipShape(Capsule())
                    .overlay {

                        if !isSelected {

                            Capsule()
                                .stroke(
                                    Color.appBorder,
                                    lineWidth: 1
                                )
                        }
                    }
            }
            .accessibilityLabel(
                "Catégorie \(title)"
            )
            .accessibilityAddTraits(
                isSelected
                    ? .isSelected
                    : []
            )
        }
    }
