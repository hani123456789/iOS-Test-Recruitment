//
//  ListingsErrorView.swift
//  TheGoodCorner
//
//  Created by Hani Ben Aissa on 13/8/2026.
//

import SwiftUI

struct ListingsErrorView: View {

    let errorMessage: String
    let retry: () -> Void

    var body: some View {

        VStack(spacing: AppSpacing.lg) {

            Image(systemName: AppIcon.networkError)
            .font(.system(size: 40))
            .foregroundStyle(Color.appOrange)

            VStack(spacing: AppSpacing.sm) {
                Text(AppStrings.Listings.errorTitle)
                    .font(AppTypography.sectionTitle)
                    .foregroundStyle(Color.appText)
                    .multilineTextAlignment(.center)

                Text(errorMessage)
                    .font(AppTypography.subheadline)
                    .foregroundStyle(Color.appSecondaryText)
                    .multilineTextAlignment(.center)
            }
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
        .frame(maxWidth: .infinity,minHeight: 300)
        .padding(.horizontal, AppSpacing.xxl)
    }
}
