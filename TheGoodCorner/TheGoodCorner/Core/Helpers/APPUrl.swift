//
//  APPUrl.swift
//  TheGoodCorner
//
//  Created by Hani Ben Aissa on 14/8/2026.
//
import Foundation

enum AppURL {

    static func make(
        _ path: String?,
        baseURL: URL
    ) -> URL? {
        guard let path else {
            return nil
        }

        return URL(
            string: path,
            relativeTo: baseURL
        )
    }
}
