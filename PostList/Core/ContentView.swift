//
//  ContentView.swift
//  SwiftUIAssignment
//
//  Created by Sandeep on 02/10/25.
//

import SwiftUI

struct ContentView: View {
    
    @State var showSplashScreen: Bool = true
    
    var body: some View {
        VStack {
            if showSplashScreen {
                SplashView()
            } else {
                MainTabView()
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: {
                showSplashScreen = false
            })
        }
    }
}

struct SplashView: View {
    var body: some View {
        ZStack {
            // Background Gradient
            LinearGradient(
                gradient: Gradient(colors: [Color.blue, Color.purple]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            // Centered Text
            Text("Welcome to Post List App")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .padding()
        }
    }
}



#Preview {
    ContentView()
        .environmentObject(PostListViewModel())
}

