//
//  ReadingOrderDemoView.swift
//  VoiceOverDemo
//
//  Created by Bogdan Sikora on 07.10.2025.
//

import SwiftUI

struct ReadingOrderDemoView: View {
    var body: some View {
        DemoPageTemplate(
            title: "Reading Order Issues",
            description: "VoiceOver reads elements in the order they appear in code, NOT in visual position. This can cause confusion when visual layout doesn't match code structure. Users might hear content in an illogical order.",
            badExampleTitle: "❌ Bad Example - Visual ≠ Code Order",
            goodExampleTitle: "✅ Good Example - Logical Order",
            explanation: "Structure your view hierarchy to match the reading order you want. Use .accessibilitySortPriority() to adjust order when necessary. Higher priority values are read first.",
            codeSnippet: """
// Bad - code order doesn't match visual
ZStack {
    // Background (1st in code)
    Rectangle()
    // Footer (2nd in code)
    VStack {
        Spacer()
        Text("Footer")
    }
    // Header (3rd in code)
    VStack {
        Text("Header")
        Spacer()
    }
}
// VoiceOver reads: Background, Footer, Header ❌

// Good - use sort priority
ZStack {
    Rectangle()
    VStack {
        Spacer()
        Text("Footer")
            .accessibilitySortPriority(1)
    }
    VStack {
        Text("Header")
            .accessibilitySortPriority(3)
        Spacer()
    }
}
// VoiceOver reads: Header, Footer ✅
""",
            badExample: {
                VStack(spacing: 20) {
                    Text("Card with mismatched reading order:")
                        .font(.caption)
                        .foregroundColor(.secondary)

                    ZStack {
                        // Background
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.white)
                            .shadow(radius: 5)
                            .accessibilityHidden(true)

                        VStack(spacing: 0) {
                            Spacer()

                            // Price at bottom (but 2nd in code)
                            VStack(spacing: 8) {
                                Text("$29.99")
                                    .font(.title)
                                    .fontWeight(.bold)
                                    .foregroundColor(.green)

                                Button("Add to Cart") { }
                                    .padding(.horizontal, 30)
                                    .padding(.vertical, 10)
                                    .background(Color.blue)
                                    .foregroundColor(.white)
                                    .cornerRadius(8)
                            }
                            .padding(.bottom, 20)
                        }

                        VStack(spacing: 0) {
                            // Title at top (but 3rd in code)
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Premium Headphones")
                                    .font(.title2)
                                    .fontWeight(.bold)

                                HStack(spacing: 4) {
                                    ForEach(0..<5) { _ in
                                        Image(systemName: "star.fill")
                                            .foregroundColor(.yellow)
                                            .font(.caption)
                                    }
                                }
                                .accessibilityElement(children: .ignore)
                                .accessibilityLabel("Rated 5 stars")

                                Text("Wireless • Noise Cancelling • 30hr Battery")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color.blue.opacity(0.1))

                            Spacer()
                        }
                    }
                    .frame(height: 220)

                    Text("⚠️ VoiceOver reads: Price → Button → Title → Rating → Details")
                        .font(.caption)
                        .foregroundColor(.red)
                        .italic()
                        .multilineTextAlignment(.center)
                }
            },
            goodExample: {
                VStack(spacing: 20) {
                    Text("Card with correct reading order:")
                        .font(.caption)
                        .foregroundColor(.secondary)

                    VStack(spacing: 0) {
                        // Title at top (1st - highest priority)
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Premium Headphones")
                                .font(.title2)
                                .fontWeight(.bold)

                            HStack(spacing: 4) {
                                ForEach(0..<5) { _ in
                                    Image(systemName: "star.fill")
                                        .foregroundColor(.yellow)
                                        .font(.caption)
                                }
                            }
                            .accessibilityElement(children: .ignore)
                            .accessibilityLabel("Rated 5 stars")

                            Text("Wireless • Noise Cancelling • 30hr Battery")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color.green.opacity(0.1))
                        .accessibilitySortPriority(3)

                        Spacer()

                        // Price at bottom (2nd in reading order)
                        VStack(spacing: 8) {
                            Text("$29.99")
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(.green)
                                .accessibilitySortPriority(2)

                            Button("Add to Cart") { }
                                .padding(.horizontal, 30)
                                .padding(.vertical, 10)
                                .background(Color.green)
                                .foregroundColor(.white)
                                .cornerRadius(8)
                                .accessibilitySortPriority(1)
                        }
                        .padding(.bottom, 20)
                    }
                    .frame(height: 220)
                    .background(Color.white)
                    .cornerRadius(12)
                    .shadow(radius: 5)

                    Text("✅ VoiceOver reads: Title → Rating → Details → Price → Button")
                        .font(.caption)
                        .foregroundColor(.green)
                        .italic()
                        .multilineTextAlignment(.center)
                }
            }
        )
    }
}
