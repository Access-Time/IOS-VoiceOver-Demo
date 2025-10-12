//
//  TimeoutDemoView.swift
//  VoiceOverDemo
//
//  Created by Bogdan Sikora on 07.10.2025.
//

import SwiftUI

struct TimeoutDemoView: View {
    @State private var showBadModal = false
    @State private var showGoodModal = false
    @State private var badTimeRemaining = 3
    @State private var goodTimeRemaining = 15
    @State private var badTimer: Timer?
    @State private var goodTimer: Timer?

    var body: some View {
        ZStack {
            DemoPageTemplate(
                title: "Action Timeouts",
                description: "Auto-dismissing alerts and time-limited actions can expire before Voice Control users complete multi-step voice commands. Voice Control requires extra time because users must say 'Show numbers', identify the button number, then say 'Tap [number]'.",
                badExampleTitle: "❌ Bad Example - 3 Second Auto-Dismiss",
                goodExampleTitle: "✅ Good Example - Extended Time with Option to Add More",
                explanation: """
Voice Control timeout requirements:

1. Provide at least 10-15 seconds for actionable alerts
2. Show visual countdown so users know time is limited
3. Offer "Need More Time?" button when time runs low
4. Consider requiring explicit dismissal instead of auto-dismiss
5. Pause timers when dialogs/modals appear

Voice Control workflow takes time: "Show numbers" → identify → "Tap [number]"
""",
                codeSnippet: """
// Bad - auto-dismisses too quickly
@State var showModal = false

Button("Submit") {
    showModal = true
    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
        showModal = false  // Gone before Voice Control can act
    }
}

// Good - sufficient time with extension option
@State var showModal = false
@State var timeRemaining = 15

func startTimer() {
    timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
        if timeRemaining > 0 {
            timeRemaining -= 1
        } else {
            showModal = false
        }
    }
}

Button("Submit") {
    showModal = true
    startTimer()
}

// Custom modal with dynamic timer display
if showModal {
    TimeoutModal(
        timeRemaining: $timeRemaining,
        onConfirm: { handleConfirm() },
        onCancel: { showModal = false },
        onExtend: { timeRemaining = 15 }
    )
}
""",
                badExample: {
                    VStack(spacing: 20) {
                        Text("Modal dismisses after 3 seconds:")
                            .font(.caption)
                            .foregroundColor(.secondary)

                        Button("Submit Form") {
                            showBadModal = true
                            badTimeRemaining = 3
                            startBadTimer()
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 12)
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                        .accessibilityLabel("Submit Form - Bad Example")

                        Text("⚠️ Too fast for Voice Control workflow")
                            .font(.caption)
                            .foregroundColor(.red)
                            .italic()
                            .multilineTextAlignment(.center)
                    }
                },
                goodExample: {
                    VStack(spacing: 20) {
                        Text("Modal with 15 seconds + extension option:")
                            .font(.caption)
                            .foregroundColor(.secondary)

                        Button("Submit Form") {
                            showGoodModal = true
                            goodTimeRemaining = 15
                            startGoodTimer()
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 12)
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                        .accessibilityLabel("Submit Form - Good Example")

                        Text("✅ Sufficient time with option to extend")
                            .font(.caption)
                            .foregroundColor(.green)
                            .italic()
                            .multilineTextAlignment(.center)
                    }
                }
            )
            .onDisappear {
                stopBadTimer()
                stopGoodTimer()
            }

            // Bad example modal
            if showBadModal {
                TimeoutModalView(
                    title: "Confirm Submission",
                    message: "Please confirm your submission.",
                    timeRemaining: badTimeRemaining,
                    showExtendButton: false,
                    onConfirm: {
                        stopBadTimer()
                        showBadModal = false
                    },
                    onCancel: {
                        stopBadTimer()
                        showBadModal = false
                    },
                    onExtend: nil
                )
            }

            // Good example modal
            if showGoodModal {
                TimeoutModalView(
                    title: "Confirm Submission",
                    message: "Please confirm your submission.",
                    timeRemaining: goodTimeRemaining,
                    showExtendButton: goodTimeRemaining <= 5,
                    onConfirm: {
                        stopGoodTimer()
                        showGoodModal = false
                    },
                    onCancel: {
                        stopGoodTimer()
                        showGoodModal = false
                    },
                    onExtend: {
                        goodTimeRemaining = 15
                    }
                )
            }
        }
    }

    private func startBadTimer() {
        stopBadTimer()
        badTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            if badTimeRemaining > 0 {
                badTimeRemaining -= 1
            } else {
                showBadModal = false
                stopBadTimer()
            }
        }
    }

    private func stopBadTimer() {
        badTimer?.invalidate()
        badTimer = nil
    }

    private func startGoodTimer() {
        stopGoodTimer()
        goodTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            if goodTimeRemaining > 0 {
                goodTimeRemaining -= 1
            } else {
                showGoodModal = false
                stopGoodTimer()
            }
        }
    }

    private func stopGoodTimer() {
        goodTimer?.invalidate()
        goodTimer = nil
    }
}

// MARK: - Custom Timeout Modal
struct TimeoutModalView: View {
    let title: String
    let message: String
    let timeRemaining: Int
    let showExtendButton: Bool
    let onConfirm: () -> Void
    let onCancel: () -> Void
    let onExtend: (() -> Void)?

    var body: some View {
        ZStack {
            // Dimmed background
            Color.black.opacity(0.4)
                .edgesIgnoringSafeArea(.all)
                .accessibilityHidden(true)

            // Modal content
            VStack(spacing: 20) {
                // Title
                Text(title)
                    .font(.headline)
                    .multilineTextAlignment(.center)

                // Message
                VStack(spacing: 8) {
                    Text(message)
                        .multilineTextAlignment(.center)

                    // Timer display with visual indicator
                    HStack(spacing: 8) {
                        Image(systemName: "clock.fill")
                            .foregroundColor(timeRemaining <= 5 ? .red : .orange)

                        Text("Time remaining: \(timeRemaining) seconds")
                            .font(.subheadline)
                            .foregroundColor(timeRemaining <= 5 ? .red : .secondary)
                    }
                    .accessibilityElement(children: .combine)
                    .accessibilityLabel("Time remaining \(timeRemaining) seconds")

                    // Visual progress bar
                    GeometryReader { geometry in
                        ZStack(alignment: .leading) {
                            // Background
                            Rectangle()
                                .fill(Color.gray.opacity(0.3))
                                .frame(height: 4)
                                .cornerRadius(2)

                            // Progress
                            Rectangle()
                                .fill(timeRemaining <= 5 ? Color.red : Color.orange)
                                .frame(width: geometry.size.width * CGFloat(timeRemaining) / (showExtendButton ? 15.0 : 3.0), height: 4)
                                .cornerRadius(2)
                                .animation(.linear(duration: 1), value: timeRemaining)
                        }
                    }
                    .frame(height: 4)
                    .accessibilityHidden(true)
                }

                // Buttons
                VStack(spacing: 12) {
                    // Confirm button
                    Button(action: onConfirm) {
                        Text("Confirm")
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                    .accessibilityLabel("Confirm submission")

                    // Cancel button
                    Button(action: onCancel) {
                        Text("Cancel")
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                            .background(Color.gray.opacity(0.2))
                            .foregroundColor(.primary)
                            .cornerRadius(8)
                    }
                    .accessibilityLabel("Cancel submission")

                    // Extend time button (conditional)
                    if showExtendButton, let extend = onExtend {
                        Button(action: extend) {
                            HStack {
                                Image(systemName: "plus.circle.fill")
                                Text("Need More Time")
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                            .background(Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                        }
                        .accessibilityLabel("Need more time, add 15 seconds")
                        .accessibilityHint("Extends the timer by 15 seconds")
                    }
                }
            }
            .padding(24)
            .background(Color(UIColor.systemBackground))
            .cornerRadius(16)
            .shadow(radius: 20)
            .padding(.horizontal, 40)
            .accessibilityElement(children: .contain)
            .accessibilityAddTraits(.isModal)
        }
    }
}
