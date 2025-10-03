//
//  FavoriteSwiftDataManager.swift
//  SwiftUIAssignment
//
//  Created by Sandeep on 02/10/25.
//

import Foundation
import SwiftData

class FavoriteSwiftDataManager {
    
    static let shared = FavoriteSwiftDataManager()
    var context: ModelContext?
    
    func setContext(context: ModelContext) {
        self.context = context
    }
    
    func isFavorite(_ post: PostListModel, favorites: [FavoritePostModel]) -> Bool {
        favorites.contains(where: { $0.id == post.id })
    }
    
    func toggleFavorite(_ post: PostListModel,
                               favorites: [FavoritePostModel],
                               alertStore: FavoritesAlertStore? = nil) async {
        do {
            if let entity = favorites.first(where: { $0.id == post.id }) {
                context?.delete(entity)
            } else {
                context?.insert(FavoritePostModel.convertToFavoriteEntity(post: post))
            }
            try context?.save()
        } catch {
            print("Failed to toggle favorite: \(error)")
            await MainActor.run {
                alertStore?.showError("Failed to save favorite: \(error.localizedDescription)")
            }
        }
    }
    
    func favoriteIDs(from favorites: [FavoritePostModel]) -> Set<Int> {
        Set(favorites.map(\.id))
    }
}
