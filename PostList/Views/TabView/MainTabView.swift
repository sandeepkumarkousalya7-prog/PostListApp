//
//  MainTabView.swift
//  SwiftUIAssignment
//
//  Created by vikash kumar on 03/10/25.
//

import SwiftUI

struct MainTabView: View {
    @EnvironmentObject var postsVM: PostListViewModel
    
    var body: some View {
        TabView {
            NavigationStack {
                PostListView()
                    .navigationDestination(for: PostListModel.self) { post in
                        PostDetailView(post: post)
                    }
            }
            .tabItem {
                Label("Posts", systemImage: "list.bullet")
            }
            
            NavigationStack {
                FavoritesView()
                    .navigationDestination(for: PostListModel.self) { post in
                        PostDetailView(post: post)
                    }
            }
            .tabItem {
                Label("Favorites", systemImage: "heart.fill")
            }
        }
    }
}
