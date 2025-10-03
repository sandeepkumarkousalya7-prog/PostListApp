//
//  PostDetailView.swift
//  SwiftUIAssignment
//
//  Created by Sandeep on 02/10/25.
//

import SwiftUI
import SwiftData

struct PostDetailView: View {
    
    @Environment(\.modelContext) private var context
    @Query private var favoritePosts: [FavoritePostModel]
    
    let post: PostListModel
    var isFavorite: Bool {
        FavoriteSwiftDataManager.shared.isFavorite(post, favorites: favoritePosts)
    }
    
    var body: some View {
        
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    VStack(alignment: .leading, spacing: 8) {
                        Text(post.title)
                            .font(.title)
                            .bold()
                    }
                    
                    Spacer()
                    
                    Button {
                        Task {
                            await FavoriteSwiftDataManager.shared.toggleFavorite(post, favorites: favoritePosts)
                        }
                    } label: {
                        Image(systemName: isFavorite ? "heart.fill" : "heart")
                            .imageScale(.large)
                            .foregroundStyle(isFavorite ? .red : .black)
                    }
                    .buttonStyle(.plain)
                }
                
                Text(post.body)
                    .font(.body)
                    .fixedSize(horizontal: false, vertical: true)
                
                Spacer()
            }
            .padding()
        }
        .navigationTitle("Details")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    PostDetailView(post: MockData.post1)
}
