//
//  AppDIContainer.swift
//  TrendingGithubApp
//
//  Created by Ruchit on 11/06/26.
//

import Foundation

final class AppDIContainer {

    func makeRepositoryListViewModel()
    -> RepositoryListViewModel {

        RepositoryListViewModel(
            service: makeRepositoryService()
        )
    }

    private func makeRepositoryService()
    -> RepositoryServiceProtocol {

        RepositoryService(
            apiClient: GitHubAPIClient(),
            cacheService: CacheService()
        )
    }
}
