//
//  GroupingDemoView.swift
//  VoiceOverDemo
//
//  Created by Bogdan Sikora on 07.10.2025.
//

import SwiftUI

struct GroupingDemoView: View {
    var body: some View {
        DemoPageTemplate(
            title: "Accessibility Grouping",
            description: "Grouping controls how VoiceOver navigates through elements. Without grouping, VoiceOver reads each element separately. With grouping, related elements are combined into a single VoiceOver focus point.",
            badExampleTitle: "❌ Bad Example - No Grouping",
            goodExampleTitle: "✅ Good Examples - All Grouping Options",
            explanation: """
Use .accessibilityElement(children:) to control grouping:

• .combine - Merges all child text into one announcement
• .ignore - Completely ignores children, requires custom label
• .contain - Treats as container, children remain separate but grouped
""",
            codeSnippet: """
// Bad - each element separate
HStack {
    Image(systemName: "star.fill")
    Text("Rating")
    Text("4.5")
}

// Option 1: .combine - merges all text
HStack {
    Image(systemName: "star.fill")
    Text("Rating")
    Text("4.5")
}
.accessibilityElement(children: .combine)

// Option 2: .ignore - custom label
HStack {
    Image(systemName: "star.fill")
    Text("Rating")
    Text("4.5")
}
.accessibilityElement(children: .ignore)
.accessibilityLabel("Rating: 4.5 out of 5 stars")

// Option 3: .contain - grouped container
HStack {
    Image(systemName: "star.fill")
    Text("Rating")
    Text("4.5")
}
.accessibilityElement(children: .contain)
""",
            badExample: {
                VStack(spacing: 20) {
                    Text("Products without grouping (each element separate):")
                        .font(.caption)
                        .foregroundColor(.secondary)

                    VStack(spacing: 12) {
                        // Product 1
                        HStack(alignment: .top, spacing: 12) {
                            Image(systemName: "app.fill")
                                .font(.system(size: 40))
                                .foregroundColor(.blue)

                            VStack(alignment: .leading, spacing: 4) {
                                Text("Premium App")
                                    .font(.headline)

                                HStack(spacing: 4) {
                                    Image(systemName: "star.fill")
                                        .foregroundColor(.yellow)
                                    Text("4.8")
                                        .font(.subheadline)
                                }

                                Text("$9.99")
                                    .font(.title3)
                                    .foregroundColor(.green)
                            }

                            Spacer()

                            Button("Buy") { }
                                .padding(.horizontal, 16)
                                .padding(.vertical, 8)
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(8)
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(8)

                        // Product 2
                        HStack(alignment: .top, spacing: 12) {
                            Image(systemName: "gamecontroller.fill")
                                .font(.system(size: 40))
                                .foregroundColor(.purple)

                            VStack(alignment: .leading, spacing: 4) {
                                Text("Action Game")
                                    .font(.headline)

                                HStack(spacing: 4) {
                                    Image(systemName: "star.fill")
                                        .foregroundColor(.yellow)
                                    Text("4.2")
                                        .font(.subheadline)
                                }

                                Text("$14.99")
                                    .font(.title3)
                                    .foregroundColor(.green)
                            }

                            Spacer()

                            Button("Buy") { }
                                .padding(.horizontal, 16)
                                .padding(.vertical, 8)
                                .background(Color.purple)
                                .foregroundColor(.white)
                                .cornerRadius(8)
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(8)
                    }

                    Text("⚠️ VoiceOver reads icon, title, star, rating, price, button separately")
                        .font(.caption)
                        .foregroundColor(.red)
                        .italic()
                        .multilineTextAlignment(.center)
                }
            },
            goodExample: {
                VStack(spacing: 20) {
                    Text("Three ways to group elements:")
                        .font(.caption)
                        .foregroundColor(.secondary)

                    VStack(spacing: 16) {
                        // Option 1: .combine
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Option 1: .combine")
                                .font(.caption2)
                                .foregroundColor(.blue)
                                .fontWeight(.semibold)

                            HStack(alignment: .top, spacing: 12) {
                                Image(systemName: "app.fill")
                                    .font(.system(size: 30))
                                    .foregroundColor(.blue)
                                    .accessibilityHidden(true)

                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Premium App")
                                        .font(.subheadline)
                                        .fontWeight(.semibold)

                                    HStack(spacing: 4) {
                                        Image(systemName: "star.fill")
                                            .foregroundColor(.yellow)
                                            .accessibilityHidden(true)
                                        Text("4.8")
                                            .font(.caption)
                                    }

                                    Text("$9.99")
                                        .font(.callout)
                                        .foregroundColor(.green)
                                }
                                .accessibilityElement(children: .combine)

                                Spacer()
                            }
                            .padding()
                            .background(Color.white)
                            .cornerRadius(8)
                        }

                        // Option 2: .ignore
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Option 2: .ignore")
                                .font(.caption2)
                                .foregroundColor(.blue)
                                .fontWeight(.semibold)

                            HStack(alignment: .top, spacing: 12) {
                                Image(systemName: "gamecontroller.fill")
                                    .font(.system(size: 30))
                                    .foregroundColor(.purple)
                                    .accessibilityHidden(true)

                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Action Game")
                                        .font(.subheadline)
                                        .fontWeight(.semibold)

                                    HStack(spacing: 4) {
                                        Image(systemName: "star.fill")
                                            .foregroundColor(.yellow)
                                            .accessibilityHidden(true)
                                        Text("4.2")
                                            .font(.caption)
                                    }

                                    Text("$14.99")
                                        .font(.callout)
                                        .foregroundColor(.green)
                                }
                                .accessibilityElement(children: .ignore)
                                .accessibilityLabel("Action Game, rated 4.2 stars, price $14.99")

                                Spacer()
                            }
                            .padding()
                            .background(Color.white)
                            .cornerRadius(8)
                        }

                        // Option 3: .contain
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Option 3: .contain")
                                .font(.caption2)
                                .foregroundColor(.blue)
                                .fontWeight(.semibold)

                            HStack(alignment: .top, spacing: 12) {
                                Image(systemName: "book.fill")
                                    .font(.system(size: 30))
                                    .foregroundColor(.orange)
                                    .accessibilityHidden(true)

                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Study App")
                                        .font(.subheadline)
                                        .fontWeight(.semibold)

                                    HStack(spacing: 4) {
                                        Image(systemName: "star.fill")
                                            .foregroundColor(.yellow)
                                            .accessibilityHidden(true)
                                        Text("4.9")
                                            .font(.caption)
                                    }

                                    Text("$4.99")
                                        .font(.callout)
                                        .foregroundColor(.green)
                                }
                                .accessibilityElement(children: .contain)

                                Spacer()
                            }
                            .padding()
                            .background(Color.white)
                            .cornerRadius(8)
                        }
                    }

                    VStack(spacing: 4) {
                        Text("✅ .combine: Reads as one item")
                            .font(.caption)
                            .foregroundColor(.green)
                        Text("✅ .ignore: Reads custom label only")
                            .font(.caption)
                            .foregroundColor(.green)
                        Text("✅ .contain: Container with 3 sub-items")
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
