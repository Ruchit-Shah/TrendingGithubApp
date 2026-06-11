//
//  RepositoryListViewModel.swift
//  TrendingGithubApp
//
//  Created by Ruchit on 11/06/26.
//

import Foundation
import Combine

@MainActor
final class RepositoryListViewModel:
ObservableObject {

    @Published var repositories:
    [Repository] = []

    @Published var searchText = ""

    @Published var errorMessage:
    String?

    @Published var isLoading = false

    private let service:
    RepositoryServiceProtocol

    private var cancellables =
    Set<AnyCancellable>()

    private var currentPage = 1

    init(
        service:
        RepositoryServiceProtocol
    ) {

        self.service = service

        bindSearch()

        fetchRepositories()
    }

    func fetchRepositories() {

        isLoading = true

        service
            .fetchRepositories(
                page: currentPage
            )

            .receive(
                on: DispatchQueue.main
            )

            .sink {

                [weak self] completion in

                self?.isLoading = false

                if case .failure(let error)
                    = completion {

                    self?.errorMessage =
                    error.localizedDescription
                }

            } receiveValue: {

                [weak self] repos in

                self?.repositories
                    .append(contentsOf: repos)
            }

            .store(
                in: &cancellables
            )
    }

    private func bindSearch() {

        $searchText

            .debounce(
                for: .milliseconds(500),
                scheduler: RunLoop.main
            )

            .removeDuplicates()

            .sink { text in

                print(text)
            }

            .store(
                in: &cancellables
            )
    }
}
