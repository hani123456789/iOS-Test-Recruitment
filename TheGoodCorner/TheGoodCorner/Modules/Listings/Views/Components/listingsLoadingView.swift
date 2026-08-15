//
//  listingsLoadingView.swift
//  TheGoodCorner
//
//  Created by Hani Ben Aissa on 13/8/2026.
//
import SwiftUI

struct ListingsLoadingView: View {

    var body: some View {
        VStack(spacing: AppSpacing.md) {
            ProgressView()
                .tint(Color.appOrange)
                .scaleEffect(1.2)

            Text(AppStrings.Listings.loading)
                .font(AppTypography.subheadlineSemibold)
                .foregroundStyle(Color.appSecondaryText)
        }
        .frame(maxWidth: .infinity,minHeight: 300)
        .accessibilityElement(children: .combine)
        .accessibilityLabel(AppStrings.Listings.loading)
    }
}
