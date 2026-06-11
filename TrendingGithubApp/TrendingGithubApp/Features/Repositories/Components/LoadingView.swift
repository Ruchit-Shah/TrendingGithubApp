//
//  LoadingView.swift
//  TrendingGithubApp
//
//  Created by Ruchit on 11/06/26.
//

import SwiftUI

struct LoadingView: View {

    var body: some View {

        HStack(spacing: 12) {

            RoundedRectangle(cornerRadius: 8)
                .frame(width: 50, height: 50)

            VStack(alignment: .leading, spacing: 8) {

                RoundedRectangle(cornerRadius: 4)
                    .frame(height: 16)

                RoundedRectangle(cornerRadius: 4)
                    .frame(width: 120, height: 14)

                RoundedRectangle(cornerRadius: 4)
                    .frame(width: 80, height: 14)
            }
        }
        .padding(.vertical, 6)
    }
}

#Preview {
    LoadingView()
        .redacted(reason: .placeholder)
}
