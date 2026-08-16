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
                    VStack(spacing: AppSpacing.xs) {
                        categoryFilter
                            .padding(.horizontal, AppSpacing.lg)

                        ScrollView {
                            LazyVStack(
                                alignment: .leading,
                                spacing: AppSpacing.lg
                            ){
                                listingsSection(
                                    listings: viewModel.displayedListings
                                )
                            }
                            .padding(.horizontal, AppSpacing.lg)
                            .padding(.bottom, AppSpacing.xl)
                        }
                        .id(viewModel.selectedCategory?.id ?? 0)
                        .background(Color.appBackground)
                    }
                case .empty:
                    EmptyStateView() {
                        Task { await viewModel.loadInitialData() }
                    }
                case .error(let error):
                    ListingsErrorView(errorMessage: error.errorDescription ?? AppStrings.Listings.errorTitle) {
                        Task { await viewModel.loadInitialData() }
                    }
                case .idle:
                    Color.clear
                }
            }
            .navigationTitle(AppStrings.Listings.title)
        }
        .task {
            await viewModel.loadInitialData()
        }
    }

    func listingsSection(
        listings: [Listing]
    ) -> some View {
        LazyVStack(spacing: AppSpacing.lg) {
            ForEach(listings) { listing in
                NavigationLink {
                    ListingDetailView(
                        listing: listing,
                        categoryName: viewModel.categoryName(for: listing.categoryId) ?? ""
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
                    .padding(.vertical, AppSpacing.xl)
            }
            
        }
    }
}

private extension ListingsView {

    var categoryFilter: some View {
        ScrollView(
            .horizontal,
            showsIndicators: false
        ){
            HStack(spacing: AppSpacing.sm) {
                categoryButton(
                    title: AppStrings.Listings.allCategories,
                    isSelected:
                        viewModel.selectedCategory == nil
                ){
                    viewModel.selectAllCategories()
                }
                ForEach(
                    viewModel.categories,
                    id: \.id
                ){ category in
                    categoryButton(
                        title: category.name ?? "",
                        isSelected:
                            viewModel.selectedCategory?.id
                            == category.id
                    ){
                        Task {
                            await viewModel.selectCategory(category)
                        }
                    }
                }
            }
        }
        .padding(.vertical, AppSpacing.xs)
        .accessibilityElement(children: .contain)
        .accessibilityLabel(AppStrings.Listings.categoryFilterAccessibility)
    }
    
        func categoryButton(
            title: String,
            isSelected: Bool,
            action: @escaping () -> Void
        ) -> some View {
            Button {
                withAnimation(
                    .easeInOut(duration: 0.2)
                ){
                    action()
                }
            } label: {
                Text(title)
                    .font(isSelected ? AppTypography.subheadlineSemibold: AppTypography.subheadlineMedium)
                    .foregroundStyle(isSelected ? .white : Color.appText)
                    .padding(.horizontal, AppSpacing.md)
                    .padding(.vertical, AppSpacing.sm)
                    .background(isSelected ? Color.appOrange : Color.white)
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
            .accessibilityLabel("\(AppStrings.Listing.category) \(title)")
            .accessibilityAddTraits(isSelected ? .isSelected : [])
        }
    }
