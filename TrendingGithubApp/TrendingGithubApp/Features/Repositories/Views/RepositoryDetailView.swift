//
//  RepositoryDetailView.swift
//  TrendingGithubApp
//
//  Created by Ruchit on 11/06/26.
//

import SwiftUI

struct RepositoryDetailView: View {

    let repository: Repository

    var body: some View {

        ScrollView {

            VStack(alignment: .leading, spacing: 20) {

                HStack(spacing: 16) {

                    AsyncImage(
                        url: URL(string: repository.owner.avatarURL)
                    ) { image in
                        image
                            .resizable()
                            .scaledToFill()
                    } placeholder: {
                        ProgressView()
                    }
                    .frame(width: 80, height: 80)
                    .clipShape(Circle())

                    VStack(alignment: .leading, spacing: 6) {

                        Text(repository.name)
                            .font(.title2)
                            .fontWeight(.bold)

                        Text(repository.owner.login)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                }

                VStack(alignment: .leading, spacing: 8) {

                    Text("Description")
                        .font(.headline)

                    Text(repository.description ?? "No description available.")
                        .font(.body)
                        .foregroundStyle(.secondary)
                }

                HStack {

                    Label(
                        "\(repository.stargazersCount)",
                        systemImage: "star.fill"
                    )

                    Spacer()

                    Label(
                        repository.language ?? "Unknown",
                        systemImage: "chevron.left.forwardslash.chevron.right"
                    )
                }
                .font(.subheadline)
            }
            .padding()
        }
        .navigationTitle(repository.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}
