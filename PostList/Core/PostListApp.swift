//
//  PostListApp.swift
//  PostListApp
//
//  Created by Sandeep on 02/10/25.
//

import SwiftUI
import SwiftData

@main
struct PostListApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            FavoritePostModel.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
    
    @StateObject private var postsVM = PostListViewModel()

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .environmentObject(postsVM)
        .modelContainer(sharedModelContainer)
    }
}
