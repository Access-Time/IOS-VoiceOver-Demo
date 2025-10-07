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
            description: "Without setting a language, VoiceOver uses your device's language setting to pronounce text. This causes issues when your app's text language doesn't match the device language. For example, English text read with Czech pronunciation sounds incorrect.",
            badExampleTitle: "❌ Bad Example - No Language Set",
            goodExampleTitle: "✅ Good Example - English Language Set",
            explanation: """
When you don't specify a language, VoiceOver assumes the text matches your device language. If your device is set to Czech but your app has English text, VoiceOver will try to pronounce English words using Czech pronunciation rules.

To fix this, set the app's default language in your App struct so VoiceOver knows to use English pronunciation regardless of the device language.
""",
            codeSnippet: """
// Bad - no language specified
@main
struct MyApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
// VoiceOver uses device language (Czech)
// to pronounce English text ❌

// Good - English language set
@main
struct MyApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\\.locale, Locale(identifier: "en-US"))
        }
    }
}
// VoiceOver uses English pronunciation ✅
""",
            badExample: {
                VStack(spacing: 20) {
                    Text("Text without language setting:")
                        .font(.caption)
                        .foregroundColor(.secondary)

                    VStack(spacing: 16) {
                        Text("Welcome to our application")
                            .font(.title2)
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color.white)
                            .cornerRadius(8)

                        Text("This is a demonstration of accessibility features")
                            .font(.body)
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color.white)
                            .cornerRadius(8)

                        Text("VoiceOver will pronounce this using device language")
                            .font(.body)
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color.white)
                            .cornerRadius(8)
                    }

                    Text("⚠️ If device is set to Czech, this English text will sound wrong")
                        .font(.caption)
                        .foregroundColor(.red)
                        .italic()
                        .multilineTextAlignment(.center)
                }
            },
            goodExample: {
                VStack(spacing: 20) {
                    Text("Text with English language set:")
                        .font(.caption)
                        .foregroundColor(.secondary)

                    VStack(spacing: 16) {
                        Text("Welcome to our application")
                            .font(.title2)
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color.white)
                            .cornerRadius(8)

                        Text("This is a demonstration of accessibility features")
                            .font(.body)
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color.white)
                            .cornerRadius(8)

                        Text("VoiceOver will pronounce this using English pronunciation")
                            .font(.body)
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color.white)
                            .cornerRadius(8)
                    }
                    .environment(\.locale, Locale(identifier: "en-US"))

                    Text("✅ Correct English pronunciation regardless of device language")
                        .font(.caption)
                        .foregroundColor(.green)
                        .italic()
                        .multilineTextAlignment(.center)
                }
            }
        )
    }
}
