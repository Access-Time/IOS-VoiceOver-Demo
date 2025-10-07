//
//  StateDemoView.swift
//  VoiceOverDemo
//
//  Created by Bogdan Sikora on 07.10.2025.
//

import SwiftUI

struct StateDemoView: View {
    @State private var badSelectedCards: Set<Int> = []
    @State private var goodSelectedCards: Set<Int> = []

    var body: some View {
        DemoPageTemplate(
            title: "State Traits (isSelected)",
            description: "Visual selection states must have programmatic equivalents. If a card appears selected visually, VoiceOver must announce it as selected. Without this, VoiceOver users can't tell which items are selected.",
            badExampleTitle: "❌ Bad Example - No State Trait",
            goodExampleTitle: "✅ Good Example - With isSelected Trait",
            explanation: "When an element has a visual selection state, use .accessibilityAddTraits(.isSelected) or .accessibilityRemoveTraits(.isSelected) to communicate the state to VoiceOver.",
            codeSnippet: """
@State private var selectedCards: Set<Int> = []

// Bad - only visual indicator
CardView(isSelected: selectedCards.contains(id))

// Good - with accessibility state
CardView(isSelected: selectedCards.contains(id))
    .accessibilityAddTraits(
        selectedCards.contains(id) ? .isSelected : []
    )
""",
            badExample: {
                VStack(spacing: 20) {
                    Text("Cards with visual selection only:")
                        .font(.caption)
                        .foregroundColor(.secondary)

                    VStack(spacing: 12) {
                        ForEach(1...3, id: \.self) { index in
                            BadSelectionCard(
                                number: index,
                                isSelected: badSelectedCards.contains(index)
                            )
                            .onTapGesture {
                                if badSelectedCards.contains(index) {
                                    badSelectedCards.remove(index)
                                } else {
                                    badSelectedCards.insert(index)
                                }
                            }
                        }
                    }

                    Text("⚠️ VoiceOver doesn't announce selection state")
                        .font(.caption)
                        .foregroundColor(.red)
                        .italic()
                        .multilineTextAlignment(.center)
                }
            },
            goodExample: {
                VStack(spacing: 20) {
                    Text("Cards with proper state traits:")
                        .font(.caption)
                        .foregroundColor(.secondary)

                    VStack(spacing: 12) {
                        ForEach(1...3, id: \.self) { index in
                            GoodSelectionCard(
                                number: index,
                                isSelected: goodSelectedCards.contains(index)
                            )
                            .accessibilityAddTraits(
                                goodSelectedCards.contains(index) ? .isSelected : []
                            )
                            .onTapGesture {
                                if goodSelectedCards.contains(index) {
                                    goodSelectedCards.remove(index)
                                } else {
                                    goodSelectedCards.insert(index)
                                }
                            }
                        }
                    }

                    Text("✅ VoiceOver announces 'selected' or 'not selected'")
                        .font(.caption)
                        .foregroundColor(.green)
                        .italic()
                        .multilineTextAlignment(.center)
                }
            }
        )
    }
}

struct BadSelectionCard: View {
    let number: Int
    let isSelected: Bool

    var body: some View {
        HStack {
            Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                .foregroundColor(isSelected ? .green : .gray)
                .font(.title2)

            Text("Card \(number)")
                .font(.body)
                .fontWeight(isSelected ? .bold : .regular)

            Spacer()
        }
        .padding()
        .background(isSelected ? Color.green.opacity(0.1) : Color.white)
        .cornerRadius(8)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(isSelected ? Color.green : Color.gray.opacity(0.3), lineWidth: 2)
        )
    }
}

struct GoodSelectionCard: View {
    let number: Int
    let isSelected: Bool

    var body: some View {
        HStack {
            Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                .foregroundColor(isSelected ? .green : .gray)
                .font(.title2)
                .accessibilityHidden(true)

            Text("Card \(number)")
                .font(.body)
                .fontWeight(isSelected ? .bold : .regular)

            Spacer()
        }
        .padding()
        .background(isSelected ? Color.green.opacity(0.1) : Color.white)
        .cornerRadius(8)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(isSelected ? Color.green : Color.gray.opacity(0.3), lineWidth: 2)
        )
    }
}
