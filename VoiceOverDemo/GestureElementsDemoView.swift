//
//  GestureElementsDemoView.swift
//  VoiceOverDemo
//
//  Created by Bogdan Sikora on 07.10.2025.
//

import SwiftUI

struct GestureElementsDemoView: View {
    @State private var badCardPressed: Set<Int> = []
    @State private var goodCardPressed: Set<Int> = []

    var body: some View {
        DemoPageTemplate(
            title: "Elements That Aren't Buttons",
            description: "Creating button-like elements without using actual Button components makes them inaccessible to Voice Control users. Voice Control can only target proper SwiftUI Button elements with accessibility labels.",
            badExampleTitle: "❌ Bad Example - Tap Gesture on Non-Button",
            goodExampleTitle: "✅ Good Example - Proper Button Component",
            explanation: """
Button accessibility requirements:

1. Use SwiftUI Button component for all tappable actions
2. Provide clear accessibility labels describing the action
3. Use .accessibilityAddTraits(.isButton) if using custom tap handlers
4. Avoid using .onTapGesture on non-interactive views

Voice Control identifies buttons by their semantic role. A VStack with a tap gesture looks interactive visually, but Voice Control cannot target it because it's not recognized as a button.
""",
            codeSnippet: """
// Bad - VStack with tap gesture
VStack {
    Image(systemName: "star.fill")
    Text("Favorite")
}
.onTapGesture {
    toggleFavorite()
}

// Good - Proper Button component
Button(action: toggleFavorite) {
    VStack {
        Image(systemName: "star.fill")
        Text("Favorite")
    }
}
.accessibilityLabel("Toggle favorite")

// Alternative - Add button trait explicitly
VStack {
    Image(systemName: "star.fill")
    Text("Favorite")
}
.onTapGesture {
    toggleFavorite()
}
.accessibilityAddTraits(.isButton)
.accessibilityLabel("Toggle favorite")
""",
            badExample: {
                VStack(spacing: 20) {
                    Text("Tap cards (not actual buttons):")
                        .font(.caption)
                        .foregroundColor(.secondary)

                    HStack(spacing: 12) {
                        ForEach(1...3, id: \.self) { index in
                            BadTappableCard(
                                icon: ["star.fill", "heart.fill", "bookmark.fill"][index - 1],
                                label: ["Favorite", "Like", "Save"][index - 1],
                                isPressed: badCardPressed.contains(index)
                            )
                            .onTapGesture {
                                if badCardPressed.contains(index) {
                                    badCardPressed.remove(index)
                                } else {
                                    badCardPressed.insert(index)
                                }
                            }
                        }
                    }

                    Text("⚠️ Voice Control can't target these - they're not buttons")
                        .font(.caption)
                        .foregroundColor(.red)
                        .italic()
                        .multilineTextAlignment(.center)
                }
            },
            goodExample: {
                VStack(spacing: 20) {
                    Text("Proper Button components:")
                        .font(.caption)
                        .foregroundColor(.secondary)

                    HStack(spacing: 12) {
                        ForEach(1...3, id: \.self) { index in
                            Button(action: {
                                if goodCardPressed.contains(index) {
                                    goodCardPressed.remove(index)
                                } else {
                                    goodCardPressed.insert(index)
                                }
                            }) {
                                GoodTappableCard(
                                    icon: ["star.fill", "heart.fill", "bookmark.fill"][index - 1],
                                    label: ["Favorite", "Like", "Save"][index - 1],
                                    isPressed: goodCardPressed.contains(index)
                                )
                            }
                            .accessibilityLabel(["Favorite", "Like", "Save"][index - 1])
                        }
                    }

                    Text("✅ Voice Control can target these buttons")
                        .font(.caption)
                        .foregroundColor(.green)
                        .italic()
                        .multilineTextAlignment(.center)
                }
            }
        )
    }
}

// Bad tappable card - VStack with tap gesture (not a button)
struct BadTappableCard: View {
    let icon: String
    let label: String
    let isPressed: Bool

    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 32))
                .foregroundColor(isPressed ? .yellow : .gray)

            Text(label)
                .font(.caption)
                .foregroundColor(.primary)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 100)
        .background(Color.white)
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(isPressed ? Color.yellow : Color.gray.opacity(0.3), lineWidth: 2)
        )
        .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
    }
}

// Good tappable card - used inside proper Button component
struct GoodTappableCard: View {
    let icon: String
    let label: String
    let isPressed: Bool

    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 32))
                .foregroundColor(isPressed ? .blue : .gray)

            Text(label)
                .font(.caption)
                .foregroundColor(.primary)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 100)
        .background(Color.white)
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(isPressed ? Color.blue : Color.green.opacity(0.3), lineWidth: 2)
        )
        .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
    }
}
