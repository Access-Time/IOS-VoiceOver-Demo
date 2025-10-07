//
//  DialogDemoView.swift
//  VoiceOverDemo
//
//  Created by Bogdan Sikora on 07.10.2025.
//

import SwiftUI

struct DialogDemoView: View {
    @State private var showBadDialog = false
    @State private var showGoodDialog = false

    var body: some View {
        ZStack {
            DemoPageTemplate(
            title: "Dialog Implementation",
            description: "A dialog is a modal window that requires user interaction. Proper dialogs must: 1) Trap VoiceOver focus inside (using .isModal trait), 2) Hide background content from VoiceOver, 3) Support ESC key to dismiss, 4) Return focus to trigger element when closed. Without these, it's just a visual overlay.",
            badExampleTitle: "❌ Bad Example - No Dialog Traits or Keyboard Support",
            goodExampleTitle: "✅ Good Example - Proper Modal Dialog",
            explanation: """
A proper dialog implementation requires:

1. .accessibilityAddTraits(.isModal) - Traps VoiceOver inside the dialog
2. .accessibilityElement(children: .contain) - Groups dialog content
3. .accessibilityHidden(true) on background - Hides content behind dialog
4. .keyboardShortcut(.cancelAction) - ESC key dismisses dialog
5. .keyboardShortcut(.defaultAction) - Enter key confirms (optional)
6. .onKeyPress(.escape) - Additional ESC handler for reliability

Without these, users can access background elements and get lost.
""",
            codeSnippet: """
// Bad - just an overlay, no keyboard support
if showDialog {
    VStack {
        Text("Title")
        Text("Content")
        Button("Close") { }
    }
}

// Good - proper modal dialog
if showDialog {
    Color.black.opacity(0.4)
        .accessibilityHidden(true)

    VStack {
        Text("Title")
            .accessibilityAddTraits(.isHeader)
        Text("Content")
        Button("Cancel") { }
            .keyboardShortcut(.cancelAction)
        Button("Confirm") { }
            .keyboardShortcut(.defaultAction)
    }
    .accessibilityElement(children: .contain)
    .accessibilityAddTraits(.isModal)
    .onKeyPress(.escape) {
        // Handle ESC key
        return .handled
    }
}
""",
            badExample: {
                VStack(spacing: 20) {
                    Text("Dialog without proper traits:")
                        .font(.caption)
                        .foregroundColor(.secondary)

                    Button("Show Dialog") {
                        showBadDialog = true
                    }
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)

                    Text("⚠️ Not announced as a modal dialog")
                        .font(.caption)
                        .foregroundColor(.red)
                        .italic()
                        .multilineTextAlignment(.center)
                }
            },
            goodExample: {
                VStack(spacing: 20) {
                    Text("Dialog with proper modal trait:")
                        .font(.caption)
                        .foregroundColor(.secondary)

                    Button("Show Dialog") {
                        showGoodDialog = true
                    }
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(8)

                    Text("✅ Announced as modal, background hidden")
                        .font(.caption)
                        .foregroundColor(.green)
                        .italic()
                        .multilineTextAlignment(.center)
                }
            }
        )

        // Bad Dialog - Full Screen Overlay
        if showBadDialog {
            Color.black.opacity(0.4)
                .ignoresSafeArea()
                .onTapGesture {
                    showBadDialog = false
                }

            VStack(spacing: 20) {
                Text("Confirm Action")
                    .font(.title2)
                    .fontWeight(.bold)

                Text("This dialog doesn't have the .isModal trait. VoiceOver users can still access elements behind it.")
                    .font(.body)
                    .multilineTextAlignment(.center)

                HStack(spacing: 15) {
                    Button("Cancel") {
                        showBadDialog = false
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(8)

                    Button("Confirm") {
                        showBadDialog = false
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                }
            }
            .padding(30)
            .background(Color.white)
            .cornerRadius(12)
            .shadow(radius: 20)
            .padding(40)
        }

        // Good Dialog - Full Screen Overlay
        if showGoodDialog {
            Color.black.opacity(0.4)
                .ignoresSafeArea()
                .onTapGesture {
                    showGoodDialog = false
                }
                .accessibilityHidden(true)

            VStack(spacing: 20) {
                Text("Confirm Action")
                    .font(.title2)
                    .fontWeight(.bold)
                    .accessibilityAddTraits(.isHeader)

                Text("This dialog has the .isModal trait. VoiceOver users are confined to this dialog and cannot access elements behind it. Press ESC to cancel.")
                    .font(.body)
                    .multilineTextAlignment(.center)

                HStack(spacing: 15) {
                    Button("Cancel") {
                        showGoodDialog = false
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(8)
                    .keyboardShortcut(.cancelAction)

                    Button("Confirm") {
                        showGoodDialog = false
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                    .keyboardShortcut(.defaultAction)
                }
            }
            .padding(30)
            .background(Color.white)
            .cornerRadius(12)
            .shadow(radius: 20)
            .padding(40)
            .accessibilityElement(children: .contain)
            .accessibilityAddTraits(.isModal)
            .onKeyPress(.escape) {
                showGoodDialog = false
                return .handled
            }
        }
        }
    }
}
