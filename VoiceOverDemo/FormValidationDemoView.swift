//
//  FormValidationDemoView.swift
//  VoiceOverDemo
//
//  Created by Bogdan Sikora on 07.10.2025.
//

import SwiftUI

struct FormValidationDemoView: View {
    // Bad form state
    @State private var badEmail = ""
    @State private var badPassword = ""
    @State private var badEmailError = ""
    @State private var badPasswordError = ""

    // Good form state
    @State private var goodEmail = ""
    @State private var goodPassword = ""
    @State private var goodEmailError = ""
    @State private var goodPasswordError = ""
    @AccessibilityFocusState private var focusedField: FormField?

    enum FormField {
        case goodEmail, goodPassword
    }

    var body: some View {
        DemoPageTemplate(
            title: "Form Validation",
            description: "When form validation fails, VoiceOver users need to know what went wrong and where. Errors must be programmatically associated with their inputs and focus should move to the first error.",
            badExampleTitle: "❌ Bad Example - Poor Error Handling",
            goodExampleTitle: "✅ Good Example - Accessible Errors",
            explanation: "Use .accessibilityLabel() and .accessibilityValue() to associate errors with inputs. Move VoiceOver focus to the first error field using @AccessibilityFocusState. Announce errors clearly with descriptive messages.",
            codeSnippet: """
@AccessibilityFocusState private var focusedField: FormField?

// Bad - error not associated with field
TextField("Email", text: $email)
if !error.isEmpty {
    Text(error).foregroundColor(.red)
}

// Good - error properly associated
TextField("Email", text: $email)
    .accessibilityLabel("Email")
    .accessibilityValue(email.isEmpty ? "Empty" : email)
    .accessibilityHint(
        emailError.isEmpty ? "" : emailError
    )
    .accessibilityFocused($focusedField, equals: .email)

if !emailError.isEmpty {
    Text(emailError)
        .accessibilityLabel("Email error: \\(emailError)")
}

// On submit - move focus to error
if !emailError.isEmpty {
    focusedField = .email
}
""",
            badExample: {
                VStack(spacing: 20) {
                    Text("Form without proper error handling:")
                        .font(.caption)
                        .foregroundColor(.secondary)

                    VStack(alignment: .leading, spacing: 16) {
                        // Email field
                        VStack(alignment: .leading, spacing: 6) {
                            Text("Email")
                                .font(.subheadline)
                            TextField("Enter email", text: $badEmail)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                            if !badEmailError.isEmpty {
                                Text(badEmailError)
                                    .font(.caption)
                                    .foregroundColor(.red)
                            }
                        }

                        // Password field
                        VStack(alignment: .leading, spacing: 6) {
                            Text("Password")
                                .font(.subheadline)
                            SecureField("Enter password", text: $badPassword)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                            if !badPasswordError.isEmpty {
                                Text(badPasswordError)
                                    .font(.caption)
                                    .foregroundColor(.red)
                            }
                        }

                        Button("Submit") {
                            validateBadForm()
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(8)

                    Text("⚠️ Errors not associated with fields, no focus management")
                        .font(.caption)
                        .foregroundColor(.red)
                        .italic()
                        .multilineTextAlignment(.center)
                }
            },
            goodExample: {
                VStack(spacing: 20) {
                    Text("Form with proper error handling:")
                        .font(.caption)
                        .foregroundColor(.secondary)

                    VStack(alignment: .leading, spacing: 16) {
                        // Email field
                        VStack(alignment: .leading, spacing: 6) {
                            TextField("Email", text: $goodEmail)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .accessibilityHint(goodEmailError.isEmpty ? "Enter your email address" : "Invalid. \(goodEmailError)")
                                .accessibilityFocused($focusedField, equals: .goodEmail)
                            if !goodEmailError.isEmpty {
                                HStack(spacing: 6) {
                                    Image(systemName: "exclamationmark.triangle.fill")
                                        .foregroundColor(.red)
                                        .accessibilityHidden(true)
                                    Text(goodEmailError)
                                        .font(.caption)
                                        .foregroundColor(.red)
                                }
                            }
                        }

                        // Password field
                        VStack(alignment: .leading, spacing: 6) {
                            SecureField("Password", text: $goodPassword)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .accessibilityHint(goodPasswordError.isEmpty ? "Enter your password" : "Invalid. \(goodPasswordError)")
                                .accessibilityFocused($focusedField, equals: .goodPassword)
                            if !goodPasswordError.isEmpty {
                                HStack(spacing: 6) {
                                    Image(systemName: "exclamationmark.triangle.fill")
                                        .foregroundColor(.red)
                                        .accessibilityHidden(true)
                                    Text(goodPasswordError)
                                        .font(.caption)
                                        .foregroundColor(.red)
                                }
                            }
                        }

                        Button("Submit") {
                            validateGoodForm()
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(8)

                    Text("✅ Errors announced with fields, focus moves to first error")
                        .font(.caption)
                        .foregroundColor(.green)
                        .italic()
                        .multilineTextAlignment(.center)
                }
            }
        )
    }

    func validateBadForm() {
        badEmailError = ""
        badPasswordError = ""

        if badEmail.isEmpty || !badEmail.contains("@") {
            badEmailError = "Please enter a valid email address"
        }

        if badPassword.isEmpty || badPassword.count < 8 {
            badPasswordError = "Password must be at least 8 characters"
        }
    }

    func validateGoodForm() {
        goodEmailError = ""
        goodPasswordError = ""

        if goodEmail.isEmpty || !goodEmail.contains("@") {
            goodEmailError = "Please enter a valid email address"
            focusedField = .goodEmail
        } else if goodPassword.isEmpty || goodPassword.count < 8 {
            goodPasswordError = "Password must be at least 8 characters"
            focusedField = .goodPassword
        }
    }
}
