//
//  TrendingGithubAppTests.swift
//  TrendingGithubAppTests
//
//  Created by Ruchit on 11/06/26.
//

import XCTest
import Combine
@testable import TrendingGithubApp

final class TrendingGithubAppTests: XCTestCase {

    private var cancellables: Set<AnyCancellable>!

    override func setUp() {
        super.setUp()
        cancellables = []
    }

    override func tearDown() {
        cancellables = nil
        super.tearDown()
    }

    @MainActor
    func testSearchDebounceFiltersRepositories() {

        let service = MockRepositoryService(
            result: .success(Self.mockRepositories)
        )

        let viewModel = RepositoryListViewModel(service: service)

        let expectation = XCTestExpectation(
            description: "Search debounce filters repositories"
        )

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            viewModel.searchText = "algorithms"
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.9) {

            XCTAssertEqual(viewModel.filteredRepositories.count, 1)
            XCTAssertEqual(
                viewModel.filteredRepositories.first?.name,
                "swift-algorithms"
            )

            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 2)
    }

    func testCachingFallbackOnNetworkError() {

        let cachedRepositories = Self.mockRepositories

        let apiClient = MockAPIClient(
            result: .failure(URLError(.notConnectedToInternet))
        )

        let cacheService = MockCacheService()
        cacheService.save(repositories: cachedRepositories)

        let service = RepositoryService(
            apiClient: apiClient,
            cacheService: cacheService
        )

        let expectation = XCTestExpectation(
            description: "Returns cached repositories when network fails"
        )

        service
            .fetchRepositories(page: 1)
            .sink { completion in

                if case .failure = completion {
                    XCTFail("Expected cache fallback, but received failure")
                }

            } receiveValue: { repositories in

                XCTAssertEqual(repositories.count, cachedRepositories.count)
                XCTAssertEqual(repositories.first?.name, "swift-algorithms")

                expectation.fulfill()
            }
            .store(in: &cancellables)

        wait(for: [expectation], timeout: 2)
    }
}

private extension TrendingGithubAppTests {

    static var mockRepositories: [Repository] {
        [
            Repository(
                id: 1,
                name: "swift-algorithms",
                description: "Algorithms package",
                stargazersCount: 5000,
                language: "Swift",
                owner: Owner(
                    login: "apple",
                    avatarURL: "https://example.com/avatar.png"
                )
            ),
            Repository(
                id: 2,
                name: "ios-clean-architecture",
                description: "Clean architecture sample",
                stargazersCount: 3000,
                language: "Swift",
                owner: Owner(
                    login: "ruchit",
                    avatarURL: "https://example.com/avatar2.png"
                )
            )
        ]
    }
}

private final class MockRepositoryService: RepositoryServiceProtocol {

    var didReturnCachedData: Bool = false

    private let result: Result<[Repository], Error>

    init(result: Result<[Repository], Error>) {
        self.result = result
    }

    func fetchRepositories(page: Int) -> AnyPublisher<[Repository], Error> {
        result.publisher.eraseToAnyPublisher()
    }
}

private final class MockAPIClient: APIClient {

    private let result: Result<[Repository], Error>

    init(result: Result<[Repository], Error>) {
        self.result = result
    }

    func fetchRepositories(page: Int) -> AnyPublisher<[Repository], Error> {
        result.publisher.eraseToAnyPublisher()
    }
}

private final class MockCacheService: CacheServiceProtocol {

    private var repositories: [Repository] = []

    func save(repositories: [Repository]) {
        self.repositories = repositories
    }

    func fetchRepositories() -> [Repository] {
        repositories
    }
}
