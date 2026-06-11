//
//  RepositoryListView.swift
//  TrendingGithubApp
//
//  Created by Ruchit on 11/06/26.
//

import SwiftUI

struct RepositoryListView: View {

    @StateObject var viewModel: RepositoryListViewModel

    var body: some View {

        NavigationStack {

            ZStack(alignment: .top) {

                List {

                    if viewModel.isLoading && viewModel.filteredRepositories.isEmpty {
                        ForEach(0..<8, id: \.self) { _ in
                            LoadingView()
                                .redacted(reason: .placeholder)
                        }
                    } else {

                        ForEach(viewModel.filteredRepositories) { repo in

                            NavigationLink {

                                RepositoryDetailView(repository: repo)

                            } label: {

                                RepositoryRowView(repository: repo)
                                    .onAppear {
                                        viewModel.loadMoreIfNeeded(
                                            currentRepository: repo
                                        )
                                    }
                            }
                        }

                        if viewModel.isLoadingMore {
                            HStack {
                                Spacer()
                                ProgressView("Loading more...")
                                Spacer()
                            }
                        }

                        Button("Load More") {
                            viewModel.loadNextPage()
                        }
                    }
                }
                .searchable(
                    text: $viewModel.searchText,
                    prompt: "Search repositories"
                )
                .refreshable {
                    viewModel.refresh()
                }
                .navigationTitle("Trending Repositories")

                if let errorMessage = viewModel.errorMessage {
                    ErrorBannerView(
                        message: errorMessage,
                        onDismiss: {
                            viewModel.dismissError()
                        }
                    )
                    .padding(.horizontal)
                    .padding(.top, 8)
                    .transition(.move(edge: .top))
                    .zIndex(1)
                }
            }
        }
    }
}
