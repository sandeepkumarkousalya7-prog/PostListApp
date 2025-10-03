//
//  FavoritePostEntity.swift
//  SwiftUIAssignment
//
//  Created by Sandeep on 02/10/25.
//

import SwiftData
import Foundation

@Model
final class FavoritePostModel {
    
    var userId: Int
    @Attribute(.unique) var id: Int
    var title: String
    var body: String
    
    init(userId: Int, id: Int, title: String, body: String) {
        self.userId = userId
        self.id = id
        self.title = title
        self.body = body
    }
    
    static func convertToFavoriteEntity(post: PostListModel) -> FavoritePostModel {
        return FavoritePostModel(userId: post.userId, id: post.id, title: post.title, body: post.body)
    }
    
    func convertToPostVM() -> PostListModel {
        return PostListModel(userId: self.userId, id: self.id, title: self.title, body: self.body)
    }
    
}
