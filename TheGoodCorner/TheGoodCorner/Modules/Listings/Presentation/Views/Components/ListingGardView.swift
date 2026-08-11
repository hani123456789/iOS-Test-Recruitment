//
//  ListingGardView.swift
//  TheGoodCorner
//
//  Created by Hani Ben Aissa on 10/8/2026.
//

import SwiftUI

struct ListingCardView: View {

    let listing: Listing

    var body: some View {
        VStack(spacing: 0) {
            imageSection

            informationSection
        }
        .background(Color.white)
        .clipShape(
            RoundedRectangle(cornerRadius: 14)
        )
        .overlay {
            RoundedRectangle(cornerRadius: 14)
                .stroke(
                    Color.appBorder,
                    lineWidth: 1
                )
        }
        .shadow(
            color: .black.opacity(0.05),
            radius: 8,
            x: 0,
            y: 3
        )
    }
}

// MARK: - Image

private extension ListingCardView {

    var imageSection: some View {
        ZStack(alignment: .topTrailing) {

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
            .frame(height: 230)
            .frame(maxWidth: .infinity)
            .clipped()
            .accessibilityLabel(
                "Image de \(listing.title)"
            )
        }
    }

    var imagePlaceholder: some View {
        ZStack {
            Color(
                red: 0.94,
                green: 0.95,
                blue: 0.96
            )

            Image(systemName: "photo")
                .font(.system(size: 28))
                .foregroundStyle(
                    Color.appSecondaryText.opacity(0.5)
                )
        }
        .accessibilityHidden(true)
    }
}

// MARK: - Information

private extension ListingCardView {

    var informationSection: some View {
        VStack(
            alignment: .leading,
            spacing: 10
        ) {

            HStack(alignment: .center) {

                Text("tous")
                    .font(
                        .caption.weight(.semibold)
                    )
                    .foregroundStyle(
                        Color.appSecondaryText
                    )
                    .tracking(0.5)

                Spacer()

                if listing.isUrgent ?? false {
                    urgentBadge
                }
            }

            Text(listing.title ?? "")
                .font(
                    .title3.weight(.semibold)
                )
                .foregroundStyle(Color.appText)
                .multilineTextAlignment(.leading)
                .fixedSize(
                    horizontal: false,
                    vertical: true
                )

            HStack(alignment: .bottom) {

                Text(formattedPrice)
                    .font(
                        .title2.weight(.bold)
                    )
                    .foregroundStyle(Color.appOrange)
            }
        }
        .padding(16)
    }

    var urgentBadge: some View {
        Label(
            "Urgent",
            systemImage: "flame.fill"
        )
        .font(
            .caption.weight(.semibold)
        )
        .foregroundStyle(Color.appUrgent)
        .padding(
            .horizontal,
            9
        )
        .padding(
            .vertical,
            5
        )
        .background(
            Color.appUrgent.opacity(0.08)
        )
        .clipShape(Capsule())
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
