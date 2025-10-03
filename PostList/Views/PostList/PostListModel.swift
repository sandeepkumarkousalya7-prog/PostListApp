//
//  Post.swift
//  SwiftUIAssignment
//
//  Created by Sandeep on 02/10/25.
//

import Foundation

struct PostListModel: Identifiable, Codable, Equatable, Hashable {
    let userId: Int
    let id: Int
    let title: String
    let body: String
}

