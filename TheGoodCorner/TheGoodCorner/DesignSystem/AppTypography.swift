//
//  AppTypography.swift
//  TheGoodCorner
//
//  Created by Hani Ben Aissa on 11/8/2026.
//

import SwiftUI

enum AppTypography {
    
    // MARK: - Titles
    static let screenTitle = Font.title2.weight(.bold)
    static let cardTitle = Font.title3.weight(.semibold)
    static let price = Font.title3.weight(.bold)
    
    // MARK: - Headings
    static let sectionTitle = Font.headline

    // MARK: - Body
    static let body = Font.body
    static let subheadline = Font.subheadline
    static let subheadlineSemibold = Font.subheadline.weight(.semibold)
    static let subheadlineMedium = Font.subheadline.weight(.medium)
    static let emptyStateIcon = Font.system(size: 36)

    // MARK: - Caption
    static let caption = Font.caption
    static let captionSemibold = Font.caption.weight(.semibold)
}
