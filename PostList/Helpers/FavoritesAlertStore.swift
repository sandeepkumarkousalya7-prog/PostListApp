//
//  FavoritesAlertStore.swift
//  SwiftUIAssignment
//
//  Created by Sandeep on 02/10/25.
//

import SwiftUI
import Combine

@MainActor
final class FavoritesAlertStore: ObservableObject {
    @Published var favoriteError: String?

    func showError(_ message: String) {
        favoriteError = message
    }

    func dismiss() {
        favoriteError = nil
    }
}
