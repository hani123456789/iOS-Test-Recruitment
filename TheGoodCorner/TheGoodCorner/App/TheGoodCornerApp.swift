import SwiftUI

@main
struct TheGoodCornerApp: App {
    
    private let viewModel: ListingsViewModel
    
    init() {
        let apiClient = APIClient(
            baseURL: APIConfiguration.baseURL
        )
        
        // Simple MVVM: inject API client directly into the ViewModel
        self.viewModel = ListingsViewModel(
            listingRepository: ListingRepository(apiClient: apiClient, baseURL: APIConfiguration.baseURL), categoriesRepository: CategoriesRepository(apiClient: apiClient)
        )
    }
        
    var body: some Scene {
        WindowGroup {
            ListingsView(viewModel: viewModel)
        }
    }
}

