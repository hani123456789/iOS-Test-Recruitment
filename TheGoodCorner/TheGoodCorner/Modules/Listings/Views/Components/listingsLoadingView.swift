//
//  listingsLoadingView.swift
//  TheGoodCorner
//
//  Created by Hani Ben Aissa on 13/8/2026.
//
import SwiftUI

struct ListingsLoadingView: View {

    var body: some View {
        VStack(spacing: 12) {

            ProgressView()
                .tint(Color.appOrange)
                .scaleEffect(1.2)

            Text("Chargement des annonces...")
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(
                    Color.appSecondaryText
                )
        }
        .frame(
            maxWidth: .infinity,
            minHeight: 300
        )
        .accessibilityElement(children: .combine)
        .accessibilityLabel(
            "Chargement des annonces"
        )
    }
}
