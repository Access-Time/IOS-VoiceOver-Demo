//
//  FocusDemoView.swift
//  VoiceOverDemo
//
//  Created by Bogdan Sikora on 07.10.2025.
//

import SwiftUI

struct FocusDemoView: View {
    @State private var showBadDialog = false
    @State private var showGoodDialog = false
    @State private var showBadAlert = false
    @State private var showGoodAlert = false
    @AccessibilityFocusState private var focusedField: FocusField?

    enum FocusField {
        case dialogButton, dialogTitle, closeButton, alertButton, alertOKButton
    }

    var body: some View {
        ZStack {
            DemoPageTemplate(
            title: "Focus Management",
            description: "When a dialog opens, VoiceOver focus should move to the dialog. When it closes, focus should return to the element that triggered it. Without proper focus management, users can get lost in the UI. Native alerts handle this automatically, but custom dialogs require manual focus management.",
            badExampleTitle: "❌ Bad Example - Custom Dialog Without Focus",
            goodExampleTitle: "✅ Good Examples - Native Alert & Custom Dialog With Focus",
            explanation: "Native alerts (.alert()) automatically manage focus - use them when possible! For custom dialogs, use @AccessibilityFocusState to manage VoiceOver focus. When a dialog appears, set focus to an element inside it. When it closes, return focus to the trigger button.",
            codeSnippet: """
// Native alert - handles ESC & focus automatically ✅
Button("Open Alert") {
    showAlert = true
}
.alert("Title", isPresented: $showAlert) {
    Button("OK") { }
}

// Custom dialog - manual focus & ESC handling
@AccessibilityFocusState private var focusedField: FocusField?

if showDialog {
    VStack {
        Text("Title")
            .accessibilityAddTraits(.isHeader)
            .accessibilityFocused($focusedField, equals: .dialogTitle)
        Text("Content")
        Button("Close") {
            showDialog = false
            focusedField = .dialogButton // Return to trigger
        }
        .keyboardShortcut(.cancelAction)
    }
    .accessibilityElement(children: .contain)
    .accessibilityAddTraits(.isModal) // Mark as modal dialog
    .onKeyPress(.escape) {
        showDialog = false
        focusedField = .dialogButton
        return .handled
    }
}
// When opening: focusedField = .dialogTitle
""",
            badExample: {
                VStack(spacing: 20) {
                    Text("Custom dialog without focus management:")
                        .font(.caption)
                        .foregroundColor(.secondary)

                    Button("Open Bad Custom Dialog") {
                        showBadDialog = true
                    }
                    .padding()
                    .background(Color.red)
                    .foregroundColor(.white)
                    .cornerRadius(8)

                    Text("⚠️ Focus stays on button, dialog content is not announced")
                        .font(.caption)
                        .foregroundColor(.red)
                        .italic()
                        .multilineTextAlignment(.center)
                }
            },
            goodExample: {
                VStack(spacing: 20) {
                    Text("Native alert (handles focus automatically):")
                        .font(.caption)
                        .foregroundColor(.secondary)

                    Button("Open Native Alert") {
                        showGoodAlert = true
                    }
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                    .alert("Native Alert Dialog", isPresented: $showGoodAlert) {
                        Button("OK") {
                            showGoodAlert = false
                        }
                        Button("Cancel", role: .cancel) {
                            showGoodAlert = false
                        }
                    } message: {
                        Text("Native alerts automatically handle focus management. VoiceOver moves to the alert and returns to the button on dismiss.")
                    }

                    Divider()

                    Text("Custom dialog with focus management:")
                        .font(.caption)
                        .foregroundColor(.secondary)

                    Button("Open Good Custom Dialog") {
                        showGoodDialog = true
                        // Set focus to the dialog title (logical starting point)
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            focusedField = .dialogTitle
                        }
                    }
                    .accessibilityFocused($focusedField, equals: .dialogButton)
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(8)

                    Text("✅ Both properly manage VoiceOver focus")
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
                Text("Dialog Without Focus")
                    .font(.headline)

                Text("This dialog doesn't manage VoiceOver focus. The focus remains on the button that opened it.")
                    .font(.body)
                    .multilineTextAlignment(.center)

                Button("Close") {
                    showBadDialog = false
                }
                .padding(.horizontal, 30)
                .padding(.vertical, 10)
                .background(Color.red)
                .foregroundColor(.white)
                .cornerRadius(8)
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
                    focusedField = .dialogButton
                }
                .accessibilityHidden(true)

            VStack(spacing: 20) {
                Text("Dialog With Focus")
                    .font(.headline)
                    .accessibilityAddTraits(.isHeader)
                    .accessibilityFocused($focusedField, equals: .dialogTitle)

                Text("This dialog properly manages VoiceOver focus. When opened, focus moves to the title (this dialog's logical starting point). The modal trait helps contain focus. When closed, focus returns to the button. Press ESC to dismiss.")
                    .font(.body)
                    .multilineTextAlignment(.center)

                Button("Close") {
                    showGoodDialog = false
                    // Return focus to the trigger button
                    focusedField = .dialogButton
                }
                .padding(.horizontal, 30)
                .padding(.vertical, 10)
                .background(Color.green)
                .foregroundColor(.white)
                .cornerRadius(8)
                .keyboardShortcut(.cancelAction)
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
                focusedField = .dialogButton
                return .handled
            }
        }
        }
    }
}
