//
//  RepositoryListViewModel.swift
//  TrendingGithubApp
//
//  Created by Ruchit on 11/06/26.
//

import Foundation
import Combine

@MainActor
final class RepositoryListViewModel: ObservableObject {

    @Published private(set) var repositories: [Repository] = []
    @Published private(set) var filteredRepositories: [Repository] = []
    @Published var searchText = ""
    @Published var errorMessage: String?
    @Published private(set) var isLoading = false
    @Published private(set) var isLoadingMore = false

    private let service: RepositoryServiceProtocol
    private var cancellables = Set<AnyCancellable>()

    private var currentPage = 1
    private var canLoadMore = true

    init(service: RepositoryServiceProtocol) {
        self.service = service
        bindSearch()
        fetchRepositories(reset: true)
    }

    func fetchRepositories(reset: Bool = false) {
        guard !isLoading else { return }

        if reset {
            currentPage = 1
            canLoadMore = true
            repositories.removeAll()
            filteredRepositories.removeAll()
        }

        isLoading = true
        errorMessage = nil

        service
            .fetchRepositories(page: currentPage)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in

                guard let self else { return }

                self.isLoading = false
                self.isLoadingMore = false

                if case .failure(let error) = completion {
                    self.errorMessage = error.localizedDescription
                }

            } receiveValue: { [weak self] repos in

                guard let self else { return }

                if repos.isEmpty {
                    self.canLoadMore = false
                }
                
                if self.currentPage == 1 {
                    self.repositories = repos
                } else {
                    self.repositories.append(contentsOf: repos)
                }

                self.applySearchFilter(self.searchText)
                if self.service.didReturnCachedData {
                    self.errorMessage = "Network unavailable. Showing cached repositories."
                }
            }
            .store(in: &cancellables)
    }

    func refresh() {
        fetchRepositories(reset: true)
    }

    func loadMoreIfNeeded(currentRepository: Repository? = nil) {
        guard canLoadMore, !isLoading, !isLoadingMore else { return }

        guard let currentRepository else {
            loadNextPage()
            return
        }

        let thresholdIndex = filteredRepositories.index(
            filteredRepositories.endIndex,
            offsetBy: -5,
            limitedBy: filteredRepositories.startIndex
        ) ?? filteredRepositories.startIndex

        if filteredRepositories.firstIndex(where: { $0.id == currentRepository.id }) == thresholdIndex {
            loadNextPage()
        }
    }

    func loadNextPage() {
        guard canLoadMore, !isLoadingMore else { return }

        isLoadingMore = true
        currentPage += 1

        fetchRepositories()
    }

    func dismissError() {
        errorMessage = nil
    }

    private func bindSearch() {
        $searchText
            .debounce(for: .milliseconds(500), scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] text in
                self?.applySearchFilter(text)
            }
            .store(in: &cancellables)
    }

    private func applySearchFilter(_ text: String) {
        let query = text.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !query.isEmpty else {
            filteredRepositories = repositories
            return
        }

        filteredRepositories = repositories.filter { repository in
            repository.name.localizedCaseInsensitiveContains(query)
            || repository.owner.login.localizedCaseInsensitiveContains(query)
            || (repository.language ?? "").localizedCaseInsensitiveContains(query)
        }
    }
}
