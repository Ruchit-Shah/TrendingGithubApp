//
//  RepositoryRowView.swift
//  TrendingGithubApp
//
//  Created by Ruchit on 11/06/26.
//

import SwiftUI

struct RepositoryRowView: View {

    let repository: Repository

    var body: some View {

        HStack(spacing: 12) {

            AsyncImage(
                url: URL(string: repository.owner.avatarURL)
            ) { image in

                image
                    .resizable()
                    .scaledToFill()

            } placeholder: {

                ProgressView()
            }
            .frame(width: 50, height: 50)
            .clipShape(Circle())

            VStack(alignment: .leading, spacing: 6) {

                Text(repository.name)
                    .font(.headline)
                    .lineLimit(1)

                Text(repository.owner.login)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                HStack(spacing: 12) {

                    Label(
                        "\(repository.stargazersCount)",
                        systemImage: "star.fill"
                    )

                    Text(repository.language ?? "Unknown")
                }
                .font(.caption)
                .foregroundStyle(.secondary)
            }
        }
        .padding(.vertical, 6)
    }
}
