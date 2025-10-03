//
//  FavoritesViewModel.swift
//  SwiftUIAssignment
//
//  Created by vikash kumar on 03/10/25.
//

import Foundation
import Combine
import SwiftData

class FavoritesViewModel: ObservableObject {
    
    @Published var searchText: String = ""
    @Published var filteredPosts: [FavoritePostModel] = []

    private var searchTask: Task<Void, Never>? = nil
    private var cancellables = Set<AnyCancellable>()
    var context: ModelContext?
    
    init() {
        
        $searchText
            .removeDuplicates()
            .sink { [weak self] newValue in
                self?.debounceSearch(newValue)
            }
            .store(in: &cancellables)
    }
    
    func setContext(context: ModelContext) {
        self.context = context
    }
    
    private func debounceSearch(_ text: String) {
        // Cancel previous task
        searchTask?.cancel()
        searchTask = Task { @MainActor in
            try? await Task.sleep(nanoseconds: 300_000_000) // 300ms debounce
            try? filterPosts(for: text)
        }
    }
    
    func filterPosts(for title: String) throws {
        let predicate = #Predicate<FavoritePostModel> { post in
            post.title.localizedStandardContains(title)
        }

        let fetchDescriptor = FetchDescriptor<FavoritePostModel>(predicate: predicate)

        let filteredPosts = try context?.fetch(fetchDescriptor)
        self.filteredPosts = filteredPosts ?? []
    }
}
