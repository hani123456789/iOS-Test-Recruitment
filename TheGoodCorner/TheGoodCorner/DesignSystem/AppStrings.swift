//
//  AppStrings.swift
//  TheGoodCorner
//
//  Created by Hani Ben Aissa on 14/8/2026.
//
import Foundation

enum AppStrings {
    
    // MARK: - Errors
    enum Errors {
        static let invalidURL = "L’URL de la requête est invalide."
        static let invalidResponse = "Le serveur a renvoyé une réponse invalide."
        static func httpError(
            _ statusCode: Int
        ) -> String {
            "Le serveur a renvoyé une erreur (HTTP \(statusCode))."
        }
        static let decodingError = "Impossible de lire la réponse du serveur."
        static let networkError = "Impossible de se connecter au serveur."
        static let unknown = "Une erreur s’est produite. Veuillez réessayer."
    }

    // MARK: - Listings
    enum Listings {
        static let title = "Annonces"
        static let categoryFilterAccessibility = "Filtrer par catégorie"
        static let allCategories = "Toutes"
        static let loading = "Chargement des annonces..."
        static let emptyTitle = "Aucune annonce"
        static let emptyMessage = "Aucune annonce ne correspond à cette catégorie."
        static let errorTitle = "Impossible de charger les annonces"
        static let retry = "Réessayer"
        static let retryAccessibility = "Réessayer de charger les annonces"
    }

    // MARK: - Listing
    enum Listing {
        static let detailTitle = "Annonce"
        static let urgent = "Urgent"
        static let category = "Catégorie"
        static let publishedAt = "Publié le"
        static let information = "Informations"
        static let description = "Description"
        static let unknownDate = "Date inconnue"
        static let defaultDescription =
            "Cette annonce est proposée par un particulier. " +
            "Contactez le vendeur pour obtenir plus " +
            "d'informations sur cet article."
        static let imageAccessibilityPrefix = "Image de"
    }
}
