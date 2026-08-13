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

        VStack(spacing: 16) {

            Image(
                systemName: "wifi.exclamationmark"
            )
            .font(.system(size: 40))
            .foregroundStyle(Color.appOrange)

            VStack(spacing: 8) {

                Text("Impossible de charger les annonces")
                    .font(.headline)
                    .foregroundStyle(Color.appText)
                    .multilineTextAlignment(.center)

                Text(errorMessage)
                    .font(.subheadline)
                    .foregroundStyle(
                        Color.appSecondaryText
                    )
                    .multilineTextAlignment(.center)
            }

            Button {
                retry()
            } label: {

                Label(
                    "Réessayer",
                    systemImage: "arrow.clockwise"
                )
                .font(
                    .subheadline.weight(.semibold)
                )
                .foregroundStyle(.white)
                .padding(.horizontal, 20)
                .padding(.vertical, 11)
                .background(Color.appOrange)
                .clipShape(Capsule())
            }
            .accessibilityLabel(
                "Réessayer de charger les annonces"
            )
        }
        .frame(
            maxWidth: .infinity,
            minHeight: 300
        )
        .padding(.horizontal, 32)
    }
}
