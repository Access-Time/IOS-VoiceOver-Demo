//
//  DemoPageTemplate.swift
//  VoiceOverDemo
//
//  Created by Bogdan Sikora on 07.10.2025.
//

import SwiftUI

struct DemoPageTemplate<BadExample: View, GoodExample: View>: View {
    let title: String
    let description: String
    let badExampleTitle: String
    let goodExampleTitle: String
    let explanation: String
    let codeSnippet: String
    @ViewBuilder let badExample: BadExample
    @ViewBuilder let goodExample: GoodExample

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 25) {
                // Description section
                VStack(alignment: .leading, spacing: 10) {
                    Text("About This Demo")
                        .font(.headline)
                        .foregroundColor(.primary)

                    Text(description)
                        .font(.body)
                        .foregroundColor(.secondary)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.blue.opacity(0.1))
                .cornerRadius(12)

                // Bad example
                VStack(alignment: .leading, spacing: 15) {
                    HStack {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.red)
                        Text(badExampleTitle)
                            .font(.title3)
                            .fontWeight(.semibold)
                    }
                    .accessibilityElement(children: .combine)

                    badExample
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.red.opacity(0.1))
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.red.opacity(0.3), lineWidth: 2)
                        )
                }

                // Good example
                VStack(alignment: .leading, spacing: 15) {
                    HStack {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.green)
                        Text(goodExampleTitle)
                            .font(.title3)
                            .fontWeight(.semibold)
                    }
                    .accessibilityElement(children: .combine)

                    goodExample
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.green.opacity(0.1))
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.green.opacity(0.3), lineWidth: 2)
                        )
                }

                // Explanation
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Image(systemName: "lightbulb.fill")
                            .foregroundColor(.orange)
                        Text("How to Fix")
                            .font(.headline)
                    }
                    .accessibilityElement(children: .combine)

                    Text(explanation)
                        .font(.body)
                        .foregroundColor(.primary)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.orange.opacity(0.1))
                .cornerRadius(12)

                // Code snippet
                if !codeSnippet.isEmpty {
                    VStack(alignment: .leading, spacing: 10) {
                        HStack {
                            Image(systemName: "chevron.left.forwardslash.chevron.right")
                                .foregroundColor(.purple)
                            Text("Code Example")
                                .font(.headline)
                        }
                        .accessibilityElement(children: .combine)

                        Text(codeSnippet)
                            .font(.system(.caption, design: .monospaced))
                            .foregroundColor(.primary)
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color(.systemGray6))
                            .cornerRadius(8)
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color.purple.opacity(0.1))
                    .cornerRadius(12)
                }
            }
            .padding()
        }
    }
}

// Simple example card for demonstrations
struct ExampleCard: View {
    let text: String
    let backgroundColor: Color

    var body: some View {
        Text(text)
            .padding()
            .frame(maxWidth: .infinity)
            .background(backgroundColor)
            .cornerRadius(8)
    }
}
