//
//  CustomActionsDemoView.swift
//  VoiceOverDemo
//
//  Created by Bogdan Sikora on 07.10.2025.
//

import SwiftUI

struct CustomActionsDemoView: View {
    @State private var badLikedCards: Set<Int> = []
    @State private var goodLikedCards: Set<Int> = []
    @State private var bestLikedCards: Set<Int> = []
    @State private var showActionMenu: Int? = nil

    var body: some View {
        DemoPageTemplate(
            title: "Custom Accessibility Actions",
            description: "Some interactions (like swipe gestures, long press, or drag) aren't accessible to all users. Custom accessibility actions provide alternative ways to perform these actions without the physical gesture.",
            badExampleTitle: "❌ Bad Example - Swipe Gesture Only",
            goodExampleTitle: "✅ Good Example - Multiple Interaction Methods",
            explanation: "Provide multiple ways to perform actions: clickable elements (heart icon), gestures (swipe), and accessibility actions for assistive technology users. This ensures everyone can interact with your content regardless of their input method.",
            codeSnippet: """
// Bad - only swipe gesture
CardView()
    .gesture(DragGesture()...)

// Good - multiple interaction methods
HStack {
    CardView()

    // 1. Clickable heart icon
    Button(action: { toggleLike() }) {
        Image(systemName: isLiked ? "heart.fill" : "heart")
    }
}
.gesture(DragGesture()...) // 2. Gesture
.accessibilityAction(named: "Like") { // 3. Accessibility action
    toggleLike()
}
.contextMenu { // 4. Context menu (long press)
    Button("Like") { toggleLike() }
}
""",
            badExample: {
                VStack(spacing: 20) {
                    Text("Cards with swipe gesture only (swipe right to like):")
                        .font(.caption)
                        .foregroundColor(.secondary)

                    VStack(spacing: 12) {
                        ForEach(1...3, id: \.self) { index in
                            BadActionCard(
                                number: index,
                                isLiked: badLikedCards.contains(index)
                            )
                            .gesture(
                                DragGesture(minimumDistance: 50)
                                    .onEnded { value in
                                        if value.translation.width > 0 { // Swipe right
                                            if badLikedCards.contains(index) {
                                                badLikedCards.remove(index)
                                            } else {
                                                badLikedCards.insert(index)
                                            }
                                        }
                                    }
                            )
                        }
                    }

                    Text("⚠️ No way for VoiceOver users to like cards")
                        .font(.caption)
                        .foregroundColor(.red)
                        .italic()
                        .multilineTextAlignment(.center)
                }
            },
            goodExample: {
                VStack(spacing: 20) {
                    Text("Multiple ways to like cards:")
                        .font(.caption)
                        .foregroundColor(.secondary)

                    VStack(spacing: 12) {
                        ForEach(1...3, id: \.self) { index in
                            BestActionCard(
                                number: index,
                                isLiked: bestLikedCards.contains(index),
                                showMenu: showActionMenu == index,
                                onToggleLike: {
                                    if bestLikedCards.contains(index) {
                                        bestLikedCards.remove(index)
                                    } else {
                                        bestLikedCards.insert(index)
                                    }
                                    showActionMenu = nil
                                },
                                onToggleMenu: {
                                    showActionMenu = showActionMenu == index ? nil : index
                                }
                            )
                            .gesture(
                                DragGesture(minimumDistance: 50)
                                    .onEnded { value in
                                        if value.translation.width > 0 { // Swipe right
                                            if bestLikedCards.contains(index) {
                                                bestLikedCards.remove(index)
                                            } else {
                                                bestLikedCards.insert(index)
                                            }
                                        }
                                    }
                            )
                        }
                    }

                    VStack(spacing: 4) {
                        Text("✅ Tap heart icon to like")
                            .font(.caption)
                            .foregroundColor(.green)
                        Text("✅ Swipe right to like")
                            .font(.caption)
                            .foregroundColor(.green)
                        Text("✅ Tap ellipsis → Action sheet")
                            .font(.caption)
                            .foregroundColor(.green)
                        Text("✅ Long press → Context menu")
                            .font(.caption)
                            .foregroundColor(.green)
                    }
                    .italic()
                    .multilineTextAlignment(.center)
                }
            }
        )
    }
}

struct BadActionCard: View {
    let number: Int
    let isLiked: Bool

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("Photo Card \(number)")
                    .font(.headline)
                Text("Swipe right to like")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            Spacer()

            Image(systemName: isLiked ? "heart.fill" : "heart")
                .foregroundColor(isLiked ? .red : .gray)
                .font(.title)
                .accessibilityHidden(true)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(8)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
        )
        .accessibilityElement(children: .combine)
    }
}

struct BestActionCard: View {
    let number: Int
    let isLiked: Bool
    let showMenu: Bool
    let onToggleLike: () -> Void
    let onToggleMenu: () -> Void

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("Photo Card \(number)")
                    .font(.headline)
                Text("Multiple interaction methods")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            Spacer()

            // Clickable heart icon
            Button(action: onToggleLike) {
                Image(systemName: isLiked ? "heart.fill" : "heart")
                    .foregroundColor(isLiked ? .red : .gray)
                    .font(.title)
            }
            .accessibilityLabel(isLiked ? "Unlike" : "Like")

            Button(action: onToggleMenu) {
                Image(systemName: "ellipsis.circle")
                    .font(.title2)
                    .foregroundColor(.blue)
            }
            .accessibilityLabel("More actions")
            .confirmationDialog("Card Actions", isPresented: Binding(
                get: { showMenu },
                set: { if !$0 { onToggleMenu() } }
            )) {
                Button(isLiked ? "Unlike" : "Like") {
                    onToggleLike()
                }
                Button("Share") {
                    // Share action
                }
                Button("Cancel", role: .cancel) {
                    onToggleMenu()
                }
            } message: {
                Text("Choose an action for Photo Card \(number)")
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(8)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
        )
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Photo Card \(number)")
        .accessibilityValue(isLiked ? "Liked" : "Not liked")
        .accessibilityAction(named: isLiked ? "Unlike" : "Like") {
            onToggleLike()
        }
        .accessibilityAction(named: "Share") {
            // Share action
            print("Share Photo Card \(number)")
        }
        .contextMenu {
            Button(action: onToggleLike) {
                Label(isLiked ? "Unlike" : "Like", systemImage: isLiked ? "heart.slash" : "heart.fill")
            }
            Button(action: {}) {
                Label("Share", systemImage: "square.and.arrow.up")
            }
        }
    }
}
