//
//  TrendingGithubAppApp.swift
//  TrendingGithubApp
//
//  Created by Ruchit on 11/06/26.
//

import SwiftUI

@main
struct TrendingGithubApp: App {

    private let apiClient: APIClient
    private let cacheService: CacheServiceProtocol
    private let repositoryService: RepositoryServiceProtocol

    init() {
        self.apiClient = GitHubAPIClient()
        self.cacheService = CacheService()
        self.repositoryService = RepositoryService(
            apiClient: apiClient,
            cacheService: cacheService
        )
    }

    var body: some Scene {
        WindowGroup {
            RepositoryListView(
                viewModel: RepositoryListViewModel(
                    service: repositoryService
                )
            )
        }
    }
}
