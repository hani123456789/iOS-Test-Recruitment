import SwiftUI

@main
struct TheGoodCornerApp: App {
    
    private let viewModel: ListingsViewModel
    
    init() {
        let apiClient = APIClient(
            baseURL: APIConfiguration.baseURL
        )
        
        let remoteDataSource =
        ListingsRemoteDataSourceImp(
            apiClient: apiClient
        )
        
        let repository =
        ListingsRepositoryImp(
            remoteDataSource: remoteDataSource,
            baseURL: APIConfiguration.baseURL
        )
        
        let fetchListingsUseCase =
        FetchListingsUseCaseImp(
            repository: repository
        )
        
        self.viewModel = ListingsViewModel(fetchListingsUseCase: fetchListingsUseCase)
        
    }
        
    
    var body: some Scene {
        WindowGroup {
            ListingsView(viewModel: viewModel)
        }
    }
}
