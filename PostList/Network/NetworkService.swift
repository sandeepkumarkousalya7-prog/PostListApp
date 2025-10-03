//
//  NetworkService.swift
//  SwiftUIAssignment
//
//  Created by Sandeep on 02/10/25.
//

import Foundation

enum NetworkError: Error, LocalizedError {
    case badURL
    case requestFailed(status: Int)
    case decodingError

    var errorDescription: String? {
        switch self {
        case .badURL: return "Invalid URL"
        case .requestFailed(let status): return "Network request failed (status \(status))"
        case .decodingError: return "Failed to decode response"
        }
    }
}

protocol NetworkServiceProtocol {
    func fetchPosts() async throws -> [PostListModel]
}

final class NetworkService: NetworkServiceProtocol {
    private let endpoint = "https://jsonplaceholder.typicode.com/posts"

    func fetchPosts() async throws -> [PostListModel] {
        guard let url = URL(string: endpoint) else { throw NetworkError.badURL }
        let (data, response) = try await URLSession.shared.data(from: url)
        if let http = response as? HTTPURLResponse, !(200..<300).contains(http.statusCode) {
            throw NetworkError.requestFailed(status: http.statusCode)
        }
        do {
            return try JSONDecoder().decode([PostListModel].self, from: data)
        } catch {
            throw NetworkError.decodingError
        }
    }
}
