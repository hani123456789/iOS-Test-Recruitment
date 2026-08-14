//
//  ListingDetailsView.swift
//  TheGoodCorner
//
//  Created by Hani Ben Aissa on 13/8/2026.
//

import SwiftUI

struct ListingDetailView: View {

    let listing: Listing
    let categoryName: String

    var body: some View {
        ScrollView {
            VStack(
                alignment: .leading,
                spacing: AppSpacing.lg
            ){
                image
                VStack(
                    alignment: .leading,
                    spacing: AppSpacing.md
                ){
                    header
                    Divider()
                        .padding(.vertical, AppSpacing.xxs)
                    details
                    Divider()
                        .padding(.vertical, AppSpacing.xxs)
                    description
                }
                .padding(.horizontal, AppSpacing.lg)
            }
            .padding(.bottom, AppSpacing.xl)
        }
        .background(Color.appBackground)
        .navigationTitle(AppStrings.Listing.detailTitle)
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
                    .clipped()
            case .failure:
                imagePlaceholder
            @unknown default:
                imagePlaceholder
            }
        }
        .frame(maxWidth: .infinity)
        .frame(height: AppDimensions.listingDetailImageHeight)
        .clipped()
        .accessibilityLabel(
            "\(AppStrings.Listing.imageAccessibilityPrefix)  \(listing.title ?? "" )"
        )
    }

    var imagePlaceholder: some View {
        ZStack {
            Color.gray.opacity(0.1)
            Image(systemName: AppIcon.photo)
                .font(.largeTitle)
                .foregroundStyle(.secondary)
        }
        .accessibilityHidden(true)
    }

    var header: some View {
        VStack(
            alignment: .leading,
            spacing: AppSpacing.sm
        ) {
            HStack {
                Spacer()
                if listing.isUrgent ?? false {
                    Label(
                        AppStrings.Listing.urgent,
                        systemImage: AppIcon.urgent
                    )
                    .font(AppTypography.captionSemibold)
                    .foregroundStyle(Color.appUrgent)
                    .padding(.horizontal, AppSpacing.sm)
                    .padding(.vertical,AppSpacing.xs)
                    .background(Color.appUrgent.opacity(0.08))
                    .clipShape(Capsule())
                }
            }
            Text(listing.title ?? "")
                .font(
                    AppTypography.screenTitle
                )
                .foregroundStyle(Color.appText)
            Text(AppFormatters.price(listing.price))
                .font(
                    AppTypography.price
                )
                .foregroundStyle(Color.appOrange)
        }
    }

    var details: some View {
        VStack(
            alignment: .leading,
            spacing: AppSpacing.md
        ){
            Text(AppStrings.Listing.information)
                .font(AppTypography.sectionTitle)
            detailRow(
                icon: AppIcon.category,
                title: AppStrings.Listing.category,
                value: categoryName
            )
            detailRow(
                icon: AppIcon.calendar,
                title: AppStrings.Listing.publishedAt,
                value: AppFormatters.date(fromISO8601: listing.creationDate)
            )
        }
    }

    func detailRow(
        icon: String,
        title: String,
        value: String
    ) -> some View {
        HStack(spacing: AppSpacing.md) {
            Image(systemName: icon)
                .foregroundStyle(
                    Color.appOrange
                )
                .frame(width: 24)

            VStack(
                alignment: .leading,
                spacing: AppSpacing.xxs
            ){
                Text(title)
                    .font(AppTypography.caption)
                    .foregroundStyle(
                        Color.appSecondaryText
                    )
                Text(value)
                    .font(AppTypography.body)
                    .foregroundStyle(
                        Color.appText
                    )
            }
        }
    }

    var description: some View {
        VStack(
            alignment: .leading,
            spacing: AppSpacing.sm
        ){
            Text(AppStrings.Listing.description)
                .font(AppTypography.sectionTitle)
            Text(
                listing.description ?? AppStrings.Listing.defaultDescription
            )
            .font(AppTypography.body)
            .foregroundStyle(
                Color.appSecondaryText
            )
            .lineSpacing(AppSpacing.xs)
        }
    }
}
