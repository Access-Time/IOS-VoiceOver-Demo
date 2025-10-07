//
//  TraitsDemoView.swift
//  VoiceOverDemo
//
//  Created by Bogdan Sikora on 07.10.2025.
//

import SwiftUI

struct TraitsDemoView: View {
    @State private var toggleBad = false
    @State private var toggleGood = false
    @State private var showBadButtonAlert = false
    @State private var showGoodButtonAlert = false
    @State private var showBadLinkAlert = false
    @State private var showCustomButtonAlert = false

    var body: some View {
        DemoPageTemplate(
            title: "Accessibility Traits",
            description: "Traits tell VoiceOver what type of element the user is interacting with. Without proper traits, VoiceOver users won't understand if something is a button, link, toggle, or other interactive element.",
            badExampleTitle: "❌ Bad Example - Missing Traits",
            goodExampleTitle: "✅ Good Example - With Traits",
            explanation: "Always use proper SwiftUI components (Button, Toggle, Link) or add .accessibilityAddTraits() modifier to custom views. This helps VoiceOver announce the element type correctly.",
            codeSnippet: """
// Bad - Text with tap gesture (no button trait)
Text("Submit")
    .onTapGesture { submit() }

// Good - Proper Button
Button("Submit") { submit() }

// Bad - Custom view without traits
CustomView()
    .onTapGesture { action() }

// Good - Custom view with traits
CustomView()
    .accessibilityAddTraits(.isButton)
    .onTapGesture { action() }
""",
            badExample: {
                VStack(spacing: 20) {
                    // Fake button (just text with gesture)
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Text with tap gesture (no button trait):")
                            .font(.caption)
                            .foregroundColor(.secondary)

                        Text("Click Me")
                            .font(.body)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                            .onTapGesture {
                                showBadButtonAlert = true
                            }
                    }

                    // Fake link (no link trait)
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Text styled as link (no link trait):")
                            .font(.caption)
                            .foregroundColor(.secondary)

                        Text("Visit our website")
                            .foregroundColor(.blue)
                            .underline()
                            .onTapGesture {
                                showBadLinkAlert = true
                            }
                    }

                    // Toggle without proper component
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Custom toggle (no toggle trait):")
                            .font(.caption)
                            .foregroundColor(.secondary)

                        HStack {
                            Text("Notifications")
                            Spacer()
                            Text(toggleBad ? "ON" : "OFF")
                                .foregroundColor(toggleBad ? .green : .gray)
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(8)
                        .onTapGesture {
                            toggleBad.toggle()
                        }
                    }

                    Text("⚠️ VoiceOver won't announce element types")
                        .font(.caption)
                        .foregroundColor(.red)
                        .italic()
                }
            },
            goodExample: {
                VStack(spacing: 20) {
                    Text("Compare: Trait vs Component")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(.secondary)

                    // BUTTON comparison
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Button - Using trait:")
                            .font(.caption)
                            .foregroundColor(.secondary)

                        Text("Click Me (Trait)")
                            .font(.body)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                            .accessibilityAddTraits(.isButton)
                            .onTapGesture {
                                showGoodButtonAlert = true
                            }

                        Text("Button - Using component:")
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .padding(.top, 4)

                        Button(action: {
                            showGoodButtonAlert = true
                        }) {
                            Text("Click Me (Component)")
                                .font(.body)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(8)
                        }
                        .buttonStyle(.plain)
                    }

                    Divider()

                    // LINK comparison
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Link - Using trait:")
                            .font(.caption)
                            .foregroundColor(.secondary)

                        Text("Visit website (Trait)")
                            .foregroundColor(.blue)
                            .underline()
                            .accessibilityAddTraits(.isLink)
                            .onTapGesture {
                                showBadLinkAlert = true
                            }

                        Text("Link - Using component:")
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .padding(.top, 4)

                        Link("Visit website (Component)", destination: URL(string: "https://example.com")!)
                            .font(.body)
                    }

                    Divider()

                    // TOGGLE comparison
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Toggle - Using traits:")
                            .font(.caption)
                            .foregroundColor(.secondary)

                        HStack {
                            Text("Notifications")
                            Spacer()
                            Text(toggleGood ? "ON" : "OFF")
                                .foregroundColor(toggleGood ? .green : .gray)
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(8)
                        .accessibilityElement(children: .combine)
                        .accessibilityAddTraits(.isButton)
                        .accessibilityLabel("Notifications")
                        .accessibilityValue(toggleGood ? "On" : "Off")
                        .onTapGesture {
                            toggleGood.toggle()
                        }

                        Text("Toggle - Using component:")
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .padding(.top, 4)

                        Toggle("Notifications", isOn: $toggleGood)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(8)
                    }

                    Text("✅ Both approaches work! Traits give flexibility, components are simpler.")
                        .font(.caption)
                        .foregroundColor(.green)
                        .italic()
                        .multilineTextAlignment(.center)
                }
            }
        )
        .alert("Button Tapped!", isPresented: $showBadButtonAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("You tapped the text with tap gesture (no button trait)")
        }
        .alert("Button Tapped!", isPresented: $showGoodButtonAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("You tapped the proper Button component")
        }
        .alert("Link Tapped!", isPresented: $showBadLinkAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("You tapped the text styled as link (no link trait)")
        }
        .alert("Custom Button Tapped!", isPresented: $showCustomButtonAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("You tapped the custom view with button trait")
        }
    }
}
