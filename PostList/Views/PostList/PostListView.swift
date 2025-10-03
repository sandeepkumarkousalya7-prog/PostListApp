//
//  PostListView.swift
//  SwiftUIAssignment
//
//  Created by Sandeep on 02/10/25.
//

import SwiftUI
import SwiftData

struct PostListView: View {
    
    @EnvironmentObject var postsVM: PostListViewModel
    @Environment(\.modelContext) private var context
    @Query private var favoritePosts: [FavoritePostModel]
    @StateObject private var alertStore = FavoritesAlertStore()
    
    var body: some View {
        
        VStack {
            searchBarView
            contentView
        }
        .navigationTitle("Posts")
        .task {
            if postsVM.posts.isEmpty {
                await postsVM.loadPosts()
            }
        }
        .onAppear {
            FavoriteSwiftDataManager.shared.setContext(context: context)
        }
    }
}

extension PostListView {
    var searchBarView: some View {
        // Search bar
        HStack {
            Image(systemName: "magnifyingglass")
            
            ZStack(alignment: .trailing) {
                TextField("Search by title...", text: $postsVM.searchText)
                    .padding(.vertical, 10)
                    .padding(.horizontal, 12)
                    .padding(.trailing, 30) // Extra padding for the "X" button
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                
                if !postsVM.searchText.isEmpty {
                    Button(action: {
                        postsVM.searchText = ""
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
    
    var contentView: some View {
        
        VStack {
            
            if postsVM.isLoading && postsVM.posts.isEmpty {
                
                ProgressView("Loading posts...")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                
            } else if let error = postsVM.errorMessage {
                
                VStack(spacing: 12) {
                    Text("Error: \(error)")
                        .multilineTextAlignment(.center)
                    Button("Retry") {
                        Task { await postsVM.loadPosts() }
                    }
                }
                .padding()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                
            } else {
                listView
            }
        }
        .animation(.default, value: postsVM.filteredPosts)
    }
    
    var listView: some View {
        List(postsVM.filteredPosts) { post in
            NavigationLink(value: post) {
                PostRowView(alertStore: alertStore, post: post)
                    .environment(\.modelContext, context)
            }
        }
        .listStyle(.plain)
        .refreshable {
            // Prevent multiple refreshes
            await postsVM.loadPosts()
            postsVM.updateFilteredPosts(text: postsVM.searchText)
        }
    }
}

#Preview {
    PostListView()
        .environmentObject(PostListViewModel())
}
