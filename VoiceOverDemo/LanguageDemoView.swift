//
//  LanguageDemoView.swift
//  VoiceOverDemo
//
//  Created by Bogdan Sikora on 07.10.2025.
//

import SwiftUI

struct LanguageDemoView: View {
    var body: some View {
        DemoPageTemplate(
            title: "Language & Localization",
            description: "VoiceOver uses the language settings to pronounce text correctly. When mixing languages or using non-English text, you should specify the language so VoiceOver can pronounce it properly. You can also set your app's default language.",
            badExampleTitle: "❌ Bad Example",
            goodExampleTitle: "✅ Good Example",
            explanation: """
To set the default language for your entire app, configure it in your App struct:

@main
struct YourApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\\.locale, Locale(identifier: "fr-FR"))
        }
    }
}

For individual text elements with different languages, use .environment(\\.locale) on specific views. This ensures VoiceOver pronounces the text with the correct accent and pronunciation rules.
""",
            codeSnippet: """
// Set app-wide default language
@main
struct MyApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\\.locale, Locale(identifier: "en-US"))
        }
    }
}

// Bad - no language specified for mixed content
Text("Bonjour le monde")

// Good - language specified using locale
Text("Bonjour le monde")
    .environment(\\.locale, Locale(identifier: "fr-FR"))

// For entire view sections
VStack {
    Text("Hola")
    Text("¿Cómo estás?")
}
.environment(\\.locale, Locale(identifier: "es-ES"))
""",
            badExample: {
                VStack(spacing: 20) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("French (no language set):")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Text("Bonjour le monde")
                            .font(.title3)
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color.white)
                            .cornerRadius(8)
                    }

                    VStack(alignment: .leading, spacing: 8) {
                        Text("Spanish (no language set):")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Text("Hola, ¿cómo estás?")
                            .font(.title3)
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color.white)
                            .cornerRadius(8)
                    }

                    VStack(alignment: .leading, spacing: 8) {
                        Text("German (no language set):")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Text("Guten Tag, wie geht es Ihnen?")
                            .font(.title3)
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color.white)
                            .cornerRadius(8)
                    }

                    Text("⚠️ VoiceOver will use English pronunciation")
                        .font(.caption)
                        .foregroundColor(.red)
                        .italic()
                }
            },
            goodExample: {
                VStack(spacing: 20) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("French (with language):")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Text("Bonjour le monde")
                            .font(.title3)
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color.white)
                            .cornerRadius(8)
                            .environment(\.locale, Locale(identifier: "fr-FR"))
                    }

                    VStack(alignment: .leading, spacing: 8) {
                        Text("Spanish (with language):")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Text("Hola, ¿cómo estás?")
                            .font(.title3)
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color.white)
                            .cornerRadius(8)
                            .environment(\.locale, Locale(identifier: "es-ES"))
                    }

                    VStack(alignment: .leading, spacing: 8) {
                        Text("German (with language):")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Text("Guten Tag, wie geht es Ihnen?")
                            .font(.title3)
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color.white)
                            .cornerRadius(8)
                            .environment(\.locale, Locale(identifier: "de-DE"))
                    }

                    Text("✅ VoiceOver will pronounce correctly")
                        .font(.caption)
                        .foregroundColor(.green)
                        .italic()
                }
            }
        )
    }
}
