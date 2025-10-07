//
//  RTLDemoView.swift
//  VoiceOverDemo
//
//  Created by Bogdan Sikora on 07.10.2025.
//

import SwiftUI

struct RTLDemoView: View {
    var body: some View {
        DemoPageTemplate(
            title: "RTL/LTR Reading Order",
            description: "VoiceOver reads text in the correct direction when you properly set the language. Right-to-Left (RTL) languages like Arabic and Hebrew are read from right to left, while Left-to-Right (LTR) languages like English are read from left to right.",
            badExampleTitle: "❌ Bad Example - No Locale Set",
            goodExampleTitle: "✅ Good Example - Proper Locale & RTL",
            explanation: "Set the locale with .environment(\\.locale, Locale(identifier: \"ar\")) for correct pronunciation and reading direction. Use .environment(\\.layoutDirection, .rightToLeft) to make your layout adapt visually. SwiftUI's HStack and layout containers automatically flip for RTL.",
            codeSnippet: """
// Bad - no locale set, hardcoded LTR
HStack(spacing: 0) {
    Image(systemName: "person")
        .padding(.leading, 12)
    Text("أحمد")
        .padding(.leading, 12)
    Spacer()
}
// VoiceOver reads with English pronunciation

// Option 1: Locale only (correct pronunciation)
HStack(spacing: 12) {
    Image(systemName: "person")
    Text("أحمد")
    Spacer()
}
.environment(\\.locale, Locale(identifier: "ar"))
// VoiceOver reads RTL, but layout stays LTR

// Option 2: Locale + RTL layout (best)
HStack(spacing: 12) {
    Image(systemName: "person")
    Text("أحمد")
    Spacer()
}
.environment(\\.locale, Locale(identifier: "ar"))
.environment(\\.layoutDirection, .rightToLeft)
// VoiceOver reads RTL AND layout flips
""",
            badExample: {
                VStack(spacing: 20) {
                    Text("Hardcoded LTR layout for all languages:")
                        .font(.caption)
                        .foregroundColor(.secondary)

                    VStack(spacing: 12) {
                        // English - correct in LTR
                        HStack(spacing: 0) {
                            Image(systemName: "person.circle.fill")
                                .font(.title)
                                .foregroundColor(.blue)
                                .padding(.leading, 12)

                            VStack(alignment: .leading, spacing: 4) {
                                Text("John Smith")
                                    .font(.headline)
                                Text("[dʒɑn smɪθ]")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                Text("Hello, how are you?")
                                    .font(.body)
                            }
                            .padding(.leading, 12)
                            .padding(.vertical, 8)

                            Spacer()
                        }
                        .background(Color.blue.opacity(0.1))
                        .cornerRadius(8)

                        // Arabic - incorrect in LTR
                        HStack(spacing: 0) {
                            Image(systemName: "person.circle.fill")
                                .font(.title)
                                .foregroundColor(.green)
                                .padding(.leading, 12)

                            VStack(alignment: .leading, spacing: 4) {
                                Text("أحمد")
                                    .font(.headline)
                                Text("[ʔaħmad]")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                Text("مرحبا، كيف حالك؟")
                                    .font(.body)
                            }
                            .padding(.leading, 12)
                            .padding(.vertical, 8)

                            Spacer()
                        }
                        .background(Color.green.opacity(0.1))
                        .cornerRadius(8)
                    }

                    VStack(spacing: 2) {
                        Text("⚠️ VoiceOver reads English left-to-right ✓")
                            .font(.caption)
                            .foregroundColor(.orange)
                        Text("⚠️ VoiceOver tries to read Arabic with English")
                            .font(.caption)
                            .foregroundColor(.red)
                            .fontWeight(.bold)
                        Text("⚠️ Layout doesn't adapt (visual issue)")
                            .font(.caption)
                            .foregroundColor(.red)
                    }
                    .italic()
                    .multilineTextAlignment(.center)
                }
            },
            goodExample: {
                VStack(spacing: 20) {
                    Text("Adaptive layout with RTL/LTR support:")
                        .font(.caption)
                        .foregroundColor(.secondary)

                    VStack(spacing: 12) {
                        // English - LTR
                        HStack(spacing: 12) {
                            Image(systemName: "person.circle.fill")
                                .font(.title)
                                .foregroundColor(.blue)

                            VStack(alignment: .leading, spacing: 4) {
                                Text("John Smith")
                                    .font(.headline)
                                Text("[dʒɑn smɪθ]")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                Text("Hello, how are you?")
                                    .font(.body)
                            }

                            Spacer()
                        }
                        .padding(12)
                        .background(Color.blue.opacity(0.1))
                        .cornerRadius(8)

                        // Arabic - Language only (no RTL layout)
                        HStack(spacing: 12) {
                            Image(systemName: "person.circle.fill")
                                .font(.title)
                                .foregroundColor(.orange)

                            VStack(alignment: .leading, spacing: 4) {
                                Text("أحمد")
                                    .font(.headline)
                                Text("[ʔaħmad]")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                Text("مرحبا، كيف حالك؟")
                                    .font(.body)
                            }
                            .environment(\.locale, Locale(identifier: "ar"))

                            Spacer()
                        }
                        .padding(12)
                        .background(Color.orange.opacity(0.1))
                        .cornerRadius(8)

                        // Arabic - RTL layout + language
                        HStack(spacing: 12) {
                            Image(systemName: "person.circle.fill")
                                .font(.title)
                                .foregroundColor(.green)

                            VStack(alignment: .leading, spacing: 4) {
                                Text("أحمد")
                                    .font(.headline)
                                Text("[ʔaħmad]")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                Text("مرحبا، كيف حالك؟")
                                    .font(.body)
                            }

                            Spacer()
                        }
                        .padding(12)
                        .background(Color.green.opacity(0.1))
                        .cornerRadius(8)
                        .environment(\.layoutDirection, .rightToLeft)
                        .environment(\.locale, Locale(identifier: "ar"))
                    }

                    VStack(spacing: 2) {
                        Text("✅ VoiceOver reads English left-to-right")
                            .font(.caption)
                            .foregroundColor(.green)
                        Text("✅ Arabic with locale: VoiceOver reads RTL")
                            .font(.caption)
                            .foregroundColor(.green)
                        Text("✅ Arabic with locale + layout: Visual RTL too")
                            .font(.caption)
                            .foregroundColor(.green)
                            .fontWeight(.bold)
                    }
                    .italic()
                    .multilineTextAlignment(.center)
                }
            }
        )
    }
}
