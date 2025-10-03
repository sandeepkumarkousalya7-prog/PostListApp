//
//  PostRowView.swift
//  SwiftUIAssignment
//
//  Created by Sandeep on 02/10/25.
//

import SwiftUI
import SwiftData

struct PostRowView: View {
    
    @Environment(\.modelContext) private var context
    @Query private var favoritePosts: [FavoritePostModel]
    @ObservedObject var alertStore: FavoritesAlertStore
    
    let post: PostListModel
    var isFavorite: Bool {
        FavoriteSwiftDataManager.shared.isFavorite(post, favorites: favoritePosts)
    }
    
    var body: some View {
        
        HStack {
            
            VStack(alignment: .leading, spacing: 4) {
                Text(post.title)
                    .font(.headline)
                    .lineLimit(2)
                Text("User ID: \(post.userId)")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Button {
                Task {
                    await FavoriteSwiftDataManager.shared.toggleFavorite(post, favorites: favoritePosts, alertStore: alertStore)
                }
            } label: {
                Image(systemName: isFavorite ? "heart.fill" : "heart")
                    .imageScale(.large)
                    .foregroundStyle(isFavorite ? .red : .black)
            }
            .buttonStyle(.plain)
            
        }
        .padding(.vertical, 8)
        .alert(isPresented: Binding(
            get: { alertStore.favoriteError != nil },
            set: { isPresented in
                if !isPresented {
                    alertStore.dismiss()
                }
            }
        )) {
            Alert(
                title: Text("Error"),
                message: Text(alertStore.favoriteError ?? ""),
                dismissButton: .default(Text("OK"), action: { alertStore.dismiss() })
            )
        }
    }
}

#Preview {
    PostRowView(alertStore: FavoritesAlertStore(), post: MockData.post1)
}
