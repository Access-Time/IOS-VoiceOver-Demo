//
//  MenuView.swift
//  VoiceOverDemo
//
//  Created by Bogdan Sikora on 07.10.2025.
//

import SwiftUI

struct MenuView: View {
    @State private var isMenuShowing = false
    @State private var selectedPage: DemoPage?

    var body: some View {
        ZStack {
            // Main content
            NavigationView {
                VStack {
                    if let page = selectedPage {
                        page.destination
                    } else {
                        HomeView()
                    }
                }
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button(action: {
                            withAnimation {
                                isMenuShowing.toggle()
                            }
                        }) {
                            Image(systemName: "line.3.horizontal")
                                .font(.title2)
                                .foregroundColor(.primary)
                        }
                        .accessibilityLabel("Menu")
                        .accessibilityHint("Double tap to open the navigation menu")
                        .accessibilityAddTraits(.isButton)
                    }

                    ToolbarItem(placement: .principal) {
                        Text(selectedPage?.title ?? "Accessibility Demo")
                            .font(.headline)
                    }
                }
            }

            // Side menu overlay
            SideMenuView(isShowing: $isMenuShowing, selectedPage: $selectedPage)
        }
    }
}

struct HomeView: View {
    var body: some View {
        VStack(spacing: 30) {
            Image(systemName: "accessibility")
                .font(.system(size: 80))
                .foregroundColor(.blue)
                .accessibilityHidden(true)

            Text("Accessibility Demo App")
                .font(.largeTitle)
                .fontWeight(.bold)

            Text("Learn about VoiceOver and Voice Control accessibility through interactive examples")
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)

            VStack(alignment: .leading, spacing: 15) {
                HStack(spacing: 12) {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.green)
                    Text("15+ Interactive Demos")
                }
                HStack(spacing: 12) {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.green)
                    Text("VoiceOver & Voice Control Coverage")
                }
                HStack(spacing: 12) {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.green)
                    Text("Good vs Bad Examples")
                }
                HStack(spacing: 12) {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.green)
                    Text("Code Snippets & Explanations")
                }
            }
            .font(.body)
            .padding(.top, 20)

            Spacer()

            Text("Tap the menu icon (☰) to get started")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .padding(.bottom, 30)
        }
        .padding()
    }
}
