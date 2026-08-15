import SwiftUI
struct ListingCardView: View {

    let listing: Listing
    let categoryName: String?

    var body: some View {
        VStack {
            imageSection
            informationSection
        }
        .frame(maxWidth: .infinity)
        .background(Color.white)
        .clipShape(
            RoundedRectangle(cornerRadius: AppRadius.large)
        )
        .overlay {
            RoundedRectangle(cornerRadius: AppRadius.large)
                .stroke(
                    Color.appBorder,
                    lineWidth: 1
                )
        }
        .shadow(
            color: .black.opacity(0.09),
            radius: 8,
            x: 0,
            y: 3
        )
    }
}


private extension ListingCardView {

    var imageSection: some View {
        
        AsyncImage(url: listing.imageURL) { phase in

            switch phase {
            case .empty:
                imagePlaceholder
            case .success(let image):
                image
                    .resizable()
                    .clipped()

            case .failure:
                imagePlaceholder
            @unknown default:
                imagePlaceholder
            }
        }
        .frame(
            maxWidth: .infinity
        )
        .frame(height: AppDimensions.listingCardImageHeight)
        .clipped()
        .allowsHitTesting(false)
        .accessibilityLabel(
            "\(AppStrings.Listing.imageAccessibilityPrefix)  \(listing.title ?? "cette annonce" )"
        )
    }

    var imagePlaceholder: some View {

        ZStack {
            Color.appPlaceholderImage
            Image(systemName: AppIcon.photo)
                .font(.system(size: 28))
                .foregroundStyle(
                    Color.appSecondaryText.opacity(0.5)
                )
        }
        .frame(
            maxWidth: .infinity
        )
        .frame(height: AppDimensions.listingCardImageHeight)
        .accessibilityHidden(true)
    }
}

private extension ListingCardView {

    var informationSection: some View {

        VStack(
            alignment: .leading,
            spacing: AppSpacing.sm
        ){
            HStack(alignment: .center) {
                Text(categoryName ?? "")
                    .font(
                        AppTypography.captionSemibold
                    )
                    .foregroundStyle(
                        Color.appSecondaryText
                    )
                Spacer()
                if listing.isUrgent ?? false {
                    urgentBadge
                }
            }
            Text(listing.title ?? "")
                .font(
                    AppTypography.cardTitle
                )
                .foregroundStyle(
                    Color.appText
                )
                .lineLimit(2)
            Text(formattedPrice)
                .font(
                    AppTypography.screenTitle
                )
                .foregroundStyle(
                    Color.appOrange
                )
        }
        .frame(
            maxWidth: .infinity,
            alignment: .leading
        )
        .padding(AppSpacing.md)
    }
    
    private var formattedPrice: String {
        "\(Int(listing.price ?? 0)) €"
    }
}

private extension ListingCardView {

    var urgentBadge: some View {
        Label(
            AppStrings.Listing.urgent,
            systemImage: AppIcon.urgent
        )
        .font(AppTypography.captionSemibold)
        .foregroundStyle(Color.appUrgent)
        .padding(.horizontal, AppSpacing.sm)
        .padding(.vertical,AppSpacing.xs)
        .background(Color.appUrgent.opacity(0.08))
        .clipShape(Capsule())
    }
}
