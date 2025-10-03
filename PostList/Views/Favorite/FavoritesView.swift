//
//  FavoritesView.swift
//  SwiftUIAssignment
//
//  Created by Sandeep on 02/10/25.
//

import SwiftUI
import SwiftData

struct FavoritesView: View {
    
    @Environment(\.modelContext) private var context
    @Query private var favoritePosts: [FavoritePostModel]
    @StateObject private var alertStore = FavoritesAlertStore()
    @StateObject private var favoriteVM = FavoritesViewModel()
    
    var body: some View {
        VStack {
            searchBarView
            listView
        }
        .navigationTitle("Favorites")
        .onAppear {
            favoriteVM.setContext(context: context)
        }
    }
}

extension FavoritesView {
    var searchBarView: some View {
        // Search bar
        HStack {
            Image(systemName: "magnifyingglass")
            
            ZStack(alignment: .trailing) {
                TextField("Search by title...", text: $favoriteVM.searchText)
                    .padding(.vertical, 10)
                    .padding(.horizontal, 12)
                    .padding(.trailing, 30) // Extra padding for the "X" button
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                
                if !favoriteVM.searchText.isEmpty {
                    Button(action: {
                        favoriteVM.searchText = ""
                        favoriteVM.filteredPosts = []
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.gray)
                            .padding(.trailing, 8)
                    }
                    .transition(.opacity)
                }
            }
        }
        .padding([.horizontal, .top])
    }
    
    var noDataView: some View {
        Text("No Favorites")
            .foregroundColor(.secondary)
            .padding()
    }
    
    var listView: some View {
        List {
            ForEach(favoriteVM.searchText.isEmpty ? favoritePosts : favoriteVM.filteredPosts) { favoritePost in
                NavigationLink(value: favoritePost.convertToPostVM()) {
                    PostRowView(alertStore: alertStore, post: favoritePost.convertToPostVM())
                        .environment(\.modelContext, context)
                }
            }
            .onDelete(perform: deleteItems)
        }
        .listStyle(.plain)
        .overlay {
            if !favoriteVM.searchText.isEmpty && favoriteVM.filteredPosts.isEmpty {
                noDataView
            } else if favoritePosts.isEmpty {
                noDataView
            }
        }
    }
    
    func deleteItems(at offsets: IndexSet) {
        let idsToRemove = offsets.compactMap {
            
            favoriteVM.searchText.isEmpty ? favoritePosts[$0].id : favoriteVM.filteredPosts[$0].id
        }
        Task {
            do {
                // Remove entities matching those IDs
                for id in idsToRemove {
                    if let entity = favoritePosts.first(where: { $0.id == id }) {
                        context.delete(entity)
                    }
                }
                try context.save()
            } catch {
                print("Failed to remove favorite(s): \(error)")
            }
        }
    }
}

#Preview {
    FavoritesView()
        .environmentObject(PostListViewModel())
}
