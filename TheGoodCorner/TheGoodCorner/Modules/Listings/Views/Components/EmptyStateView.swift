//
//  EmptyStateView.swift
//  TheGoodCorner
//
//  Created by Hani Ben Aissa on 13/8/2026.
//

import SwiftUI

struct EmptyStateView: View {
    
    var body: some View {
        VStack(spacing: AppSpacing.md) {
            Image(systemName: AppIcon.search)
                .font(AppTypography.emptyStateIcon)
                .foregroundStyle(Color.appOrange)
            Text(AppStrings.Listings.emptyTitle)
                .font(AppTypography.sectionTitle)
            Text(
                AppStrings.Listings.emptyMessage
            )
            .font(AppTypography.subheadline)
            .foregroundStyle(
                Color.appSecondaryText
            )
            .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, AppSpacing.geant)
    }
}
