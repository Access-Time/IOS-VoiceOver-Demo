//
//  DictationDemoView.swift
//  VoiceOverDemo
//
//  Created by Bogdan Sikora on 07.10.2025.
//

import SwiftUI

struct DictationDemoView: View {
    @State private var badSelectedValue = 5
    @State private var badDragOffset: CGFloat = 0
    @State private var badIsDragging = false

    @State private var goodSelectedValue = 5

    let values = Array(1...10)
    let itemHeight: CGFloat = 44

    var body: some View {
        DemoPageTemplate(
            title: "Voice Control Custom Pickers",
            description: "Custom wheel pickers that only respond to drag gestures are completely inaccessible to Voice Control users. Voice Control cannot perform precise drag operations, leaving users unable to select values. Native pickers or pickers with discrete tap targets are required.",
            badExampleTitle: "❌ Bad Example - Drag-Only Wheel Picker",
            goodExampleTitle: "✅ Good Example - Native Picker with Buttons",
            explanation: """
Voice Control custom picker requirements:

1. Avoid custom drag-only wheel pickers - Voice Control cannot drag precisely
2. Use native Picker with .wheel style when possible - it has built-in accessibility
3. Provide discrete tap targets (buttons) for incrementing/decrementing
4. Add .accessibilityAdjustableAction for VoiceOver increment/decrement
5. Ensure clear labels on all interactive elements

Voice Control users need to say "Tap [button name]" - drag gestures don't work reliably.
""",
            codeSnippet: """
// Bad - custom drag-only wheel picker
ScrollView {
    VStack(spacing: 0) {
        ForEach(values, id: \\.self) { value in
            Text("\\(value)")
                .frame(height: 44)
        }
    }
    .offset(y: dragOffset)
    .gesture(
        DragGesture()
            .onChanged { value in
                dragOffset = value.translation.height
            }
    )
}
// No tap targets, Voice Control users are stuck!

// Good - native picker or buttons
VStack {
    // Option 1: Native picker (best for many values)
    Picker("Select value", selection: $value) {
        ForEach(values, id: \\.self) { num in
            Text("\\(num)").tag(num)
        }
    }
    .pickerStyle(.menu) // or .wheel

    // Option 2: Increment/decrement buttons (best for ranges)
    HStack {
        Button("Decrease") { value -= 1 }
            .disabled(value <= minValue)
        Text("\\(value)")
        Button("Increase") { value += 1 }
            .disabled(value >= maxValue)
    }
}
""",
            badExample: {
                VStack(spacing: 20) {
                    Text("Drag-only custom wheel picker:")
                        .font(.caption)
                        .foregroundColor(.secondary)

                    VStack(spacing: 16) {
                        Text("Select a number (1-10)")
                            .font(.headline)

                        // Custom drag-only wheel picker
                        ZStack {
                            // Selection indicator
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.red.opacity(0.1))
                                .frame(height: itemHeight)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.red.opacity(0.3), lineWidth: 2)
                                )

                            // Scrollable values
                            GeometryReader { geometry in
                                VStack(spacing: 0) {
                                    ForEach(values, id: \.self) { value in
                                        Text("\(value)")
                                            .font(.title2)
                                            .frame(height: itemHeight)
                                            .foregroundColor(value == badSelectedValue ? .primary : .secondary)
                                    }
                                }
                                .offset(y: calculateOffset(for: badSelectedValue, in: geometry))
                                .offset(y: badDragOffset)
                                .gesture(
                                    DragGesture()
                                        .onChanged { gesture in
                                            badIsDragging = true
                                            badDragOffset = gesture.translation.height
                                        }
                                        .onEnded { gesture in
                                            let offset = gesture.translation.height
                                            let itemsScrolled = round(offset / itemHeight)
                                            let newIndex = max(0, min(values.count - 1, values.firstIndex(of: badSelectedValue)! - Int(itemsScrolled)))
                                            badSelectedValue = values[newIndex]
                                            badDragOffset = 0
                                            badIsDragging = false
                                        }
                                )
                            }
                        }
                        .frame(height: itemHeight * 5)
                        .clipped()

                        Text("Selected: \(badSelectedValue)")
                            .font(.title3)
                            .fontWeight(.semibold)
                    }
                    .padding()
                    .background(Color.gray.opacity(0.05))
                    .cornerRadius(12)

                    VStack(alignment: .leading, spacing: 8) {
                        Text("⚠️ Issues:")
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundColor(.red)
                        Text("• Voice Control cannot perform drag gestures reliably")
                            .font(.caption)
                            .foregroundColor(.red)
                        Text("• No tap targets - users cannot select values")
                            .font(.caption)
                            .foregroundColor(.red)
                        Text("• VoiceOver reads as unlabeled text, no adjustment actions")
                            .font(.caption)
                            .foregroundColor(.red)
                        Text("• Completely unusable without touch")
                            .font(.caption)
                            .foregroundColor(.red)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
            },
            goodExample: {
                VStack(spacing: 20) {
                    Text("Native picker with stepper buttons:")
                        .font(.caption)
                        .foregroundColor(.secondary)

                    VStack(spacing: 20) {
                        // Native picker option
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Option 1: Native Picker")
                                .font(.caption)
                                .fontWeight(.medium)
                                .foregroundColor(.secondary)

                            Picker("Select a number", selection: $goodSelectedValue) {
                                ForEach(values, id: \.self) { value in
                                    Text("\(value)").tag(value)
                                }
                            }
                            .pickerStyle(.menu)
                            .accessibilityLabel("Number picker")
                        }

                        Divider()

                        // Stepper with buttons option
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Option 2: Stepper Buttons")
                                .font(.caption)
                                .fontWeight(.medium)
                                .foregroundColor(.secondary)

                            HStack(spacing: 20) {
                                Button(action: {
                                    if goodSelectedValue > values.first! {
                                        goodSelectedValue -= 1
                                    }
                                }) {
                                    Image(systemName: "minus.circle.fill")
                                        .font(.title2)
                                        .foregroundColor(goodSelectedValue > values.first! ? .green : .gray)
                                }
                                .disabled(goodSelectedValue <= values.first!)
                                .accessibilityLabel("Decrease number")

                                Text("\(goodSelectedValue)")
                                    .font(.title)
                                    .fontWeight(.bold)
                                    .frame(minWidth: 50)
                                    .accessibilityLabel("Selected number \(goodSelectedValue)")

                                Button(action: {
                                    if goodSelectedValue < values.last! {
                                        goodSelectedValue += 1
                                    }
                                }) {
                                    Image(systemName: "plus.circle.fill")
                                        .font(.title2)
                                        .foregroundColor(goodSelectedValue < values.last! ? .green : .gray)
                                }
                                .disabled(goodSelectedValue >= values.last!)
                                .accessibilityLabel("Increase number")
                            }
                            .padding()
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(12)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.green.opacity(0.3), lineWidth: 1)
                            )
                        }
                    }
                    .padding()
                    .background(Color.gray.opacity(0.05))
                    .cornerRadius(12)

                    VStack(alignment: .leading, spacing: 8) {
                        Text("✅ Benefits:")
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundColor(.green)
                        Text("• Voice Control: 'Tap increase' or 'Tap decrease' works")
                            .font(.caption)
                            .foregroundColor(.green)
                        Text("• Native picker provides system accessibility support")
                            .font(.caption)
                            .foregroundColor(.green)
                        Text("• Clear tap targets with labels")
                            .font(.caption)
                            .foregroundColor(.green)
                        Text("• VoiceOver can increment/decrement with swipe gestures")
                            .font(.caption)
                            .foregroundColor(.green)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
        )
    }

    // Helper to calculate offset for centering selected value
    private func calculateOffset(for value: Int, in geometry: GeometryProxy) -> CGFloat {
        let centerY = geometry.size.height / 2
        let index = values.firstIndex(of: value) ?? 0
        return centerY - (CGFloat(index) * itemHeight) - (itemHeight / 2)
    }
}
