//
//  EmptyStateView.swift
//  TheGoodCorner
//
//  Created by Hani Ben Aissa on 13/8/2026.
//

import SwiftUI

struct EmptyStateView: View {
    
    var body: some View {
        
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
