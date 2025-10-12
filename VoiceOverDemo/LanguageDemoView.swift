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
            description: "VoiceOver needs to know which language to use for correct pronunciation. When mixing languages or using non-English text, always use the accessibilityLanguage modifier to tell VoiceOver which voice to use.",
            badExampleTitle: "❌ Bad Example - No Language Specified",
            goodExampleTitle: "✅ Good Example - Language Specified",
            explanation: """
VoiceOver attempts to auto-detect the language of text, but this can be unreliable, especially with mixed content, proper nouns, or short phrases. Always explicitly specify the language using Text(verbatim:) combined with .environment(\\.locale, ...) modifier.

Use verbatim to prevent localization and set the locale environment with language codes like "en" (English), "fr" (French), "es" (Spanish), "de" (German), etc.
""",
            codeSnippet: """
// Bad - no language specified for mixed content
Text("Bonjour le monde")
// VoiceOver may guess wrong or use device language ❌

// Good - language specified using verbatim and locale
Text(verbatim: "Bonjour le monde")
    .environment(\\.locale, .init(identifier: "fr"))
// VoiceOver uses French pronunciation ✅

// For entire view sections with same language
VStack {
    Text(verbatim: "Hola")
    Text(verbatim: "¿Cómo estás?")
}
.environment(\\.locale, .init(identifier: "es"))
// All child elements use Spanish pronunciation ✅

// Mixed language content
VStack {
    Text(verbatim: "Welcome")
        .environment(\\.locale, .init(identifier: "en"))
    Text(verbatim: "Bienvenue")
        .environment(\\.locale, .init(identifier: "fr"))
    Text(verbatim: "Willkommen")
        .environment(\\.locale, .init(identifier: "de"))
}
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

                    Text("⚠️ VoiceOver may mispronounce or use wrong language")
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
                        Text(verbatim: "Bonjour le monde")
                            .font(.title3)
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color.white)
                            .cornerRadius(8)
                            .environment(\.locale, .init(identifier: "fr"))
                    }

                    VStack(alignment: .leading, spacing: 8) {
                        Text("Spanish (with language):")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Text(verbatim: "Hola, ¿cómo estás?")
                            .font(.title3)
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color.white)
                            .cornerRadius(8)
                            .environment(\.locale, .init(identifier: "es"))
                    }

                    VStack(alignment: .leading, spacing: 8) {
                        Text("German (with language):")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Text(verbatim: "Guten Tag, wie geht es Ihnen?")
                            .font(.title3)
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color.white)
                            .cornerRadius(8)
                            .environment(\.locale, .init(identifier: "de"))
                    }

                    Text("✅ VoiceOver will pronounce each language correctly")
                        .font(.caption)
                        .foregroundColor(.green)
                        .italic()
                }
            }
        )
    }
}
