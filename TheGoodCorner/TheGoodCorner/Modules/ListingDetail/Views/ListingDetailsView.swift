//
//  ListingDetailsView.swift
//  TheGoodCorner
//
//  Created by Hani Ben Aissa on 13/8/2026.
//

import SwiftUI

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

