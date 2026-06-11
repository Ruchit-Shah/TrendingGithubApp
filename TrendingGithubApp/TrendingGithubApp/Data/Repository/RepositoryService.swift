//
//  RepositoryService.swift
//  TrendingGithubApp
//
//  Created by Ruchit on 11/06/26.
//

import Foundation
import Combine

final class RepositoryService: RepositoryServiceProtocol {

    private let apiClient: APIClient
    private let cacheService: CacheServiceProtocol

    private(set) var didReturnCachedData = false

    init(
        apiClient: APIClient,
        cacheService: CacheServiceProtocol
    ) {
        self.apiClient = apiClient
        self.cacheService = cacheService
    }

    func fetchRepositories(
        page: Int
    ) -> AnyPublisher<[Repository], Error> {

        didReturnCachedData = false

        return apiClient
            .fetchRepositories(page: page)
            .handleEvents(
                receiveOutput: { [weak self] repos in
                    self?.cacheService.save(repositories: repos)
                }
            )
            .catch { [weak self] error -> AnyPublisher<[Repository], Error> in

                let cached = self?.cacheService.fetchRepositories() ?? []

                guard !cached.isEmpty else {
                    return Fail(error: error)
                        .eraseToAnyPublisher()
                }

                self?.didReturnCachedData = true

                return Just(cached)
                    .setFailureType(to: Error.self)
                    .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
}
