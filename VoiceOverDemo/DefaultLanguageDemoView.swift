//
//  DefaultLanguageDemoView.swift
//  VoiceOverDemo
//
//  Created by Bogdan Sikora on 07.10.2025.
//

import SwiftUI

struct DefaultLanguageDemoView: View {
    var body: some View {
        DemoPageTemplate(
            title: "Default App Language",
            description: "Without specifying the language for VoiceOver, it may use incorrect pronunciation. If you don't set accessibilityLanguage, VoiceOver tries to auto-detect the language, but this can fail. Always explicitly set the language to ensure correct pronunciation.",
            badExampleTitle: "❌ Bad Example - Wrong Language Set",
            goodExampleTitle: "✅ Good Example - Correct Language Set",
            explanation: """
When you don't explicitly set the accessibility language, VoiceOver attempts to auto-detect the language. However, this can lead to incorrect pronunciation, especially with mixed content or ambiguous text.

To fix this, always use Text(verbatim:) combined with .environment(\\.locale, .init(identifier: "en")) on your views to explicitly tell VoiceOver which language voice to use for pronunciation.
""",
            codeSnippet: """
// Bad - Czech language forced on English text
Text(verbatim: "Welcome to our application")
    .environment(\\.locale, .init(identifier: "cs"))
// VoiceOver will pronounce English words
// using Czech pronunciation rules ❌

// Good - Explicit English language set
Text(verbatim: "Welcome to our application")
    .environment(\\.locale, .init(identifier: "en"))
// VoiceOver uses correct English pronunciation ✅

// Best practice for entire view
VStack {
    Text(verbatim: "Welcome")
    Text(verbatim: "Hello World")
}
.environment(\\.locale, .init(identifier: "en"))
// All child elements inherit English pronunciation ✅
""",
            badExample: {
                VStack(spacing: 20) {
                    Text("English text with Czech pronunciation:")
                        .font(.caption)
                        .foregroundColor(.secondary)

                    VStack(spacing: 16) {
                        Text(verbatim: "Welcome to our application")
                            .font(.title2)
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color.white)
                            .cornerRadius(8)

                        Text(verbatim: "This is a demonstration of accessibility features")
                            .font(.body)
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color.white)
                            .cornerRadius(8)

                        Text(verbatim: "VoiceOver will pronounce this using Czech pronunciation")
                            .font(.body)
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color.white)
                            .cornerRadius(8)
                    }
                    .environment(\.locale, .init(identifier: "cs"))

                    Text("⚠️ English text forced to use Czech pronunciation sounds wrong")
                        .font(.caption)
                        .foregroundColor(.red)
                        .italic()
                        .multilineTextAlignment(.center)
                }
            },
            goodExample: {
                VStack(spacing: 20) {
                    Text("English text with English pronunciation:")
                        .font(.caption)
                        .foregroundColor(.secondary)

                    VStack(spacing: 16) {
                        Text(verbatim: "Welcome to our application")
                            .font(.title2)
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color.white)
                            .cornerRadius(8)

                        Text(verbatim: "This is a demonstration of accessibility features")
                            .font(.body)
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color.white)
                            .cornerRadius(8)

                        Text(verbatim: "VoiceOver will pronounce this using English pronunciation")
                            .font(.body)
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color.white)
                            .cornerRadius(8)
                    }
                    .environment(\.locale, .init(identifier: "en"))

                    Text("✅ Correct English pronunciation with explicit language setting")
                        .font(.caption)
                        .foregroundColor(.green)
                        .italic()
                        .multilineTextAlignment(.center)
                }
            }
        )
    }
}
