//
//  AppFormatters.swift
//  TheGoodCorner
//
//  Created by Hani Ben Aissa on 14/8/2026.
//
import Foundation

enum AppFormatters {

    // MARK: - Price

    static func price(_ value: Int?) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "EUR"
        formatter.locale = Locale(identifier: "fr_FR")
        formatter.maximumFractionDigits = 0

        return formatter.string(
            from: NSNumber(value: value ?? 0)
        ) ?? "\(value ?? 0) €"
    }

    // MARK: - Date

    static func date(
        fromISO8601 value: String?
    ) -> String {

        guard let value else {
            return AppStrings.Listing.unknownDate
        }

        let isoFormatter = ISO8601DateFormatter()

        guard let date = isoFormatter.date(
            from: value
        ) else {
            return AppStrings.Listing.unknownDate
        }

        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "fr_FR")
        formatter.dateStyle = .medium
        formatter.timeStyle = .none

        return formatter.string(from: date)
    }
}
