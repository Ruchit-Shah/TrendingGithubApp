//
//  ErrorBannerView.swift
//  TrendingGithubApp
//
//  Created by Ruchit on 11/06/26.
//

import SwiftUI

struct ErrorBannerView: View {

    let message: String
    let onDismiss: () -> Void

    var body: some View {

        HStack(alignment: .top, spacing: 12) {

            Image(systemName: "exclamationmark.triangle.fill")
                .foregroundStyle(.white)

            Text(message)
                .font(.subheadline)
                .foregroundStyle(.white)
                .multilineTextAlignment(.leading)

            Spacer()

            Button {
                onDismiss()
            } label: {
                Image(systemName: "xmark")
                    .foregroundStyle(.white)
            }
        }
        .padding()
        .background(Color.red)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(radius: 4)
    }
}

#Preview {
    ErrorBannerView(
        message: "Something went wrong. Showing cached data.",
        onDismiss: {}
    )
    .padding()
}
