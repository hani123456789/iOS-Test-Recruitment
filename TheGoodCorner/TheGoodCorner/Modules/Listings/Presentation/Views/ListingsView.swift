//
//  ListingsView.swift
//  TheGoodCorner
//
//  Created by Hani Ben Aissa on 10/8/2026.
//
import Foundation
import SwiftUI


//enum MockListings {
//
//    static let all: [Listing] = [
//        Listing(
//            id: 1,
//            title: "Fauteuil lounge en cuir vintage test test tsegz hsbdh",
//            category: 1,
//            price: 450,
//            location: "Paris, Île-de-France",
//            imageURL: URL(
//                string: "https://images.unsplash.com/photo-1555041469-a586c61ea9bc"
//            ),
//            isUrgent: true
//        ),
//
//        Listing(
//            id: 2,
//            title: "Appareil photo hybride professionnel",
//            category: "Électronique",
//            price: 1200,
//            location: "Lyon, Auvergne-Rhône-Alpes",
//            imageURL: URL(
//                string: "https://images.unsplash.com/photo-1516035069371-29a1b244cc32"
//            ),
//            isUrgent: false
//        ),
//
//        Listing(
//            id: 3,
//            title: "Veste en jean vintage",
//            category: "Mode",
//            price: 85,
//            location: "Paris, Île-de-France",
//            imageURL: URL(
//                string: "https://images.unsplash.com/photo-1543076447-215ad9ba6923"
//            ),
//            isUrgent: false
//        ),
//
//        Listing(
//            id: 4,
//            title: "Vélo de ville en excellent état",
//            category: "Loisirs",
//            price: 320,
//            location: "Bordeaux, Nouvelle-Aquitaine",
//            imageURL: URL(
//                string: "https://images.unsplash.com/photo-1485965120184-e220f721d03e"
//            ),
//            isUrgent: true
//        ),
//
//        Listing(
//            id: 5,
//            title: "MacBook Pro 14 pouces",
//            category: "Électronique",
//            price: 1450,
//            location: "Toulouse, Occitanie",
//            imageURL: URL(
//                string: "https://images.unsplash.com/photo-1517336714731-489689fd1ca8"
//            ),
//            isUrgent: false
//        )
//    ]
//}



extension Color {

    // Inspired by leboncoin's orange brand color.
    static let appOrange = Color(
        red: 1.0,
        green: 0.431,
        blue: 0.078
    )

    static let appBackground = Color(
        red: 0.965,
        green: 0.965,
        blue: 0.965
    )

    static let appText = Color(
        red: 0.10,
        green: 0.12,
        blue: 0.15
    )

    static let appSecondaryText = Color(
        red: 0.38,
        green: 0.39,
        blue: 0.42
    )

    static let appBorder = Color(
        red: 0.90,
        green: 0.90,
        blue: 0.90
    )

    static let appUrgent = Color(
        red: 0.80,
        green: 0.16,
        blue: 0.12
    )
}

import SwiftUI

struct ListingSkeletonView: View {

    var body: some View {
        VStack(spacing: 0) {

            RoundedRectangle(cornerRadius: 0)
                .fill(Color.gray.opacity(0.12))
                .frame(height: 230)
                .redacted(reason: .placeholder)

            VStack(
                alignment: .leading,
                spacing: 12
            ) {

                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.gray.opacity(0.15))
                    .frame(width: 90, height: 12)

                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.gray.opacity(0.15))
                    .frame(height: 22)

                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.gray.opacity(0.15))
                    .frame(width: 100, height: 24)
            }
            .frame(
                maxWidth: .infinity,
                alignment: .leading
            )
            .padding(16)
        }
        .background(.white)
        .clipShape(
            RoundedRectangle(cornerRadius: 14)
        )
    }
}



struct ListingsView: View {

    @StateObject private var viewModel: ListingsViewModel

    @State private var selectedCategory: String = "Tous"

    private let categories = [
        "Tous",
        "Bébé",
        "Maison",
        "Mode",
        "Électronique"
    ]

    init(viewModel: ListingsViewModel) {
        _viewModel = StateObject(
            wrappedValue: viewModel
        )
    }

    private var listings: [Listing] {
        guard case .loaded(let listings) = viewModel.state else {
            return []
        }

        return listings
    }

    private var filteredListings: [Listing] {
        guard selectedCategory != "Tous" else {
            return listings
        }

        return listings
    }

    var body: some View {

        NavigationStack {

            ScrollView {

                LazyVStack(spacing: 16) {

                    categoryFilter

                    listingsSection
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 24)
            }
            .background(Color.appBackground)
            .navigationTitle("Annonces")
            .navigationBarTitleDisplayMode(.large)
            .task {
                await viewModel.loadListings()
            }
        }
    }
}

// MARK: - Category Filter

private extension ListingsView {

    var categoryFilter: some View {
        ScrollView(
            .horizontal,
            showsIndicators: false
        ) {
            HStack(spacing: 8) {

                ForEach(categories, id: \.self) { category in

                    categoryButton(
                        title: category,
                        isSelected:
                            selectedCategory == category
                    )
                }
            }
        }
        .padding(.vertical, 4)
        .accessibilityElement(children: .contain)
        .accessibilityLabel("Filtrer par catégorie")
    }

    func categoryButton(
        title: String,
        isSelected: Bool
    ) -> some View {

        Button {
            withAnimation(.easeInOut(duration: 0.2)) {
                selectedCategory = title
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
            isSelected ? .isSelected : []
        )
    }
}

// MARK: - Listings

private extension ListingsView {

    var listingsSection: some View {

        LazyVStack(spacing: 16) {

            if filteredListings.isEmpty {

                emptyState

            } else {

                ForEach(filteredListings) { listing in

                    NavigationLink {
                        ListingDetailView(
                            listing: listing
                        )
                    } label: {
                        ListingCardView(
                            listing: listing
                        )
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }

    var emptyState: some View {
        VStack(spacing: 12) {

            Image(systemName: "magnifyingglass")
                .font(.system(size: 36))
                .foregroundStyle(Color.appOrange)

            Text("Aucune annonce")
                .font(.headline)

            Text(
                "Aucune annonce ne correspond à cette catégorie."
            )
            .font(.subheadline)
            .foregroundStyle(
                Color.appSecondaryText
            )
            .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 60)
    }
}

struct ListingDetailView: View {

    let listing: Listing

    var body: some View {
        ScrollView {

            VStack(
                alignment: .leading,
                spacing: 24
            ) {

                image

                VStack(
                    alignment: .leading,
                    spacing: 16
                ) {

                    header

                    Divider()

                    details

                    Divider()

                    description
                }
                .padding(.horizontal, 16)
            }
            .padding(.bottom, 32)
        }
        .background(Color.appBackground)
        .navigationTitle("Annonce")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Components

private extension ListingDetailView {

    var image: some View {
        AsyncImage(url: listing.imageURL) { phase in

            switch phase {

            case .empty:
                imagePlaceholder

            case .success(let image):
                image
                    .resizable()
                    .scaledToFill()

            case .failure:
                imagePlaceholder

            @unknown default:
                imagePlaceholder
            }
        }
        .frame(
            maxWidth: .infinity
        )
        .frame(height: 320)
        .clipped()
        .accessibilityLabel(
            "Image de \(listing.title)"
        )
    }

    var imagePlaceholder: some View {
        ZStack {
            Color.gray.opacity(0.1)

            Image(systemName: "photo")
                .font(.largeTitle)
                .foregroundStyle(.secondary)
        }
        .accessibilityHidden(true)
    }

    var header: some View {
        VStack(
            alignment: .leading,
            spacing: 12
        ) {

            HStack {

                Text("")
                    .font(
                        .caption.weight(.semibold)
                    )
                    .foregroundStyle(
                        Color.appSecondaryText
                    )

                Spacer()

                if listing.isUrgent ?? false {
                    Label(
                        "Urgent",
                        systemImage: "flame.fill"
                    )
                    .font(
                        .caption.weight(.semibold)
                    )
                    .foregroundStyle(
                        Color.appUrgent
                    )
                }
            }

            Text(listing.title ?? "")
                .font(
                    .largeTitle.weight(.bold)
                )
                .foregroundStyle(Color.appText)

            Text(formattedPrice)
                .font(
                    .title.weight(.bold)
                )
                .foregroundStyle(Color.appOrange)
        }
    }

    var details: some View {
        VStack(
            alignment: .leading,
            spacing: 16
        ) {

            Text("Informations")
                .font(.headline)

            detailRow(
                icon: "tag",
                title: "Catégorie",
                value: "Mécanic"
            )
        }
    }

    func detailRow(
        icon: String,
        title: String,
        value: String
    ) -> some View {

        HStack(spacing: 12) {

            Image(systemName: icon)
                .foregroundStyle(
                    Color.appOrange
                )
                .frame(width: 24)

            VStack(
                alignment: .leading,
                spacing: 2
            ) {

                Text(title)
                    .font(.caption)
                    .foregroundStyle(
                        Color.appSecondaryText
                    )

                Text(value)
                    .font(.body)
                    .foregroundStyle(
                        Color.appText
                    )
            }
        }
    }

    var description: some View {
        VStack(
            alignment: .leading,
            spacing: 10
        ) {

            Text("Description")
                .font(.headline)

            Text(
                "Cette annonce est proposée par un particulier. "
                + "Contactez le vendeur pour obtenir plus "
                + "d'informations sur cet article."
            )
            .font(.body)
            .foregroundStyle(
                Color.appSecondaryText
            )
            .lineSpacing(4)
        }
    }

    var formattedPrice: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "EUR"
        formatter.locale = Locale(identifier: "fr_FR")
        formatter.maximumFractionDigits = 0

        return formatter.string(
            from: NSNumber(value: listing.price ?? 0)
        ) ?? "\(Int(listing.price ?? 0)) €"
    }
}
