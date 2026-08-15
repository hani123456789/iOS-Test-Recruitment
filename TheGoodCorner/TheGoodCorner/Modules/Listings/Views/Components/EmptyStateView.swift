//
//  EmptyStateView.swift
//  TheGoodCorner
//
//  Created by Hani Ben Aissa on 13/8/2026.
//

import SwiftUI

struct EmptyStateView: View {
    let retry: () -> Void
    
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
            Button {
                retry()
            } label: {

                Label(
                    AppStrings.Listings.retry,
                    systemImage: AppIcon.refresh
                )
                .font(AppTypography.subheadlineSemibold)
                .foregroundStyle(.white)
                .padding(.horizontal, AppSpacing.xl)
                .padding(.vertical, AppSpacing.md)
                .background(Color.appOrange)
                .clipShape(Capsule())
            }
            .accessibilityLabel(AppStrings.Listings.retryAccessibility)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, AppSpacing.geant)
    }
}
