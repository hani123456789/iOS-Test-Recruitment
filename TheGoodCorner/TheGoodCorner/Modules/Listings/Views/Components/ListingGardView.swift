import SwiftUI
struct ListingCardView: View {

    let listing: Listing
    let categoryName: String?

    var body: some View {
        VStack(spacing: 0) {

            imageSection

            informationSection
        }
        .frame(maxWidth: .infinity)
        .background(Color.white)
        .clipShape(
            RoundedRectangle(cornerRadius: 14)
        )
        .overlay {
            RoundedRectangle(cornerRadius: 14)
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
        .frame(height: 150)
        .clipped()
        .allowsHitTesting(false)
        .accessibilityLabel(
            "Image de \(listing.title ?? "l'annonce")"
        )
    }

    var imagePlaceholder: some View {

        ZStack {

            Color(
                red: 0.94,
                green: 0.95,
                blue: 0.96
            )

            Image(systemName: "photo")
                .font(.system(size: 28))
                .foregroundStyle(
                    Color.appSecondaryText.opacity(0.5)
                )
        }
        .frame(
            maxWidth: .infinity
        )
        .frame(height: 150)
        .accessibilityHidden(true)
    }
}

private extension ListingCardView {

    var informationSection: some View {

        VStack(
            alignment: .leading,
            spacing: 8
        ) {

            HStack(alignment: .center) {

                Text(categoryName ?? "")
                    .font(
                        .caption.weight(.semibold)
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
                    .title3.weight(.semibold)
                )
                .foregroundStyle(
                    Color.appText
                )
                .lineLimit(2)

            Text(formattedPrice)
                .font(
                    .title2.weight(.bold)
                )
                .foregroundStyle(
                    Color.appOrange
                )
        }
        .frame(
            maxWidth: .infinity,
            alignment: .leading
        )
        .padding(12)
    }
    
    private var formattedPrice: String {
        "\(Int(listing.price ?? 0)) €"
    }
}

private extension ListingCardView {

    var urgentBadge: some View {

        Label(
            "Urgent",
            systemImage: "flame.fill"
        )
        .font(
            .caption.weight(.semibold)
        )
        .foregroundStyle(
            Color.appUrgent
        )
        .padding(
            .horizontal,
            9
        )
        .padding(
            .vertical,
            5
        )
        .background(
            Color.appUrgent.opacity(0.08)
        )
        .clipShape(Capsule())
    }
}
