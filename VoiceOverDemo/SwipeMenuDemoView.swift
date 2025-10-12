//
//  SwipeMenuDemoView.swift
//  VoiceOverDemo
//
//  Created by Bogdan Sikora on 07.10.2025.
//

import SwiftUI

struct MessageItem: Identifiable {
    let id: Int
    let title: String
    let subtitle: String
}

struct SwipeMenuDemoView: View {
    @State private var badSwipeOffset: [Int: CGFloat] = [:]
    @State private var messages: [MessageItem] = [
        MessageItem(id: 1, title: "Meeting Tomorrow", subtitle: "Don't forget the 9am call"),
        MessageItem(id: 2, title: "Project Update", subtitle: "Review the latest changes"),
        MessageItem(id: 3, title: "Lunch Plans", subtitle: "Let's grab lunch at noon")
    ]

    var body: some View {
        DemoPageTemplate(
            title: "Swipe to Reveal Menu",
            description: "Hidden menus that appear only through swipe gestures are completely inaccessible to VoiceOver and Voice Control users. Use SwiftUI's .swipeActions() with proper accessibility labels for full accessibility support.",
            badExampleTitle: "❌ Bad Example - Custom Swipe Gesture Only",
            goodExampleTitle: "✅ Good Example - System swipeActions()",
            explanation: """
Swipe-to-reveal menu accessibility requirements:

1. Never rely solely on custom swipe gestures to reveal actions
2. Use system .swipeActions() which provides automatic accessibility support
3. Combine list row content with .accessibilityElement(children: .combine)
4. Add clear .accessibilityLabel() to action buttons (just "Delete", "Archive")
5. The system announces "Actions available" when swipe actions are present

VoiceOver and Voice Control users cannot perform swipe gestures. Custom swipe implementations leave those users completely unable to access the hidden actions. SwiftUI's .swipeActions() with proper accessibility makes actions discoverable through the VoiceOver rotor and accessible to Voice Control.
""",
            codeSnippet: """
// Bad - custom swipe gesture only
@State private var offset: CGFloat = 0

ZStack {
    // Hidden buttons (only accessible via swipe)
    HStack {
        Button("Archive") { }
        Button("Delete") { }
    }

    // Main content with custom drag gesture
    Text("Message")
        .offset(x: offset)
        .gesture(DragGesture().onChanged { ... })
}

// Good - system swipeActions with accessibility
List {
    ForEach(messages) { message in
        VStack(alignment: .leading) {
            Text(message.title)
            Text(message.subtitle)
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\\(message.title), \\(message.subtitle)")
        .swipeActions(edge: .trailing) {
            Button(role: .destructive) {
                // Delete action
            } label: {
                Label("Delete", systemImage: "trash")
            }
            .accessibilityLabel("Delete")

            Button {
                // Archive action
            } label: {
                Label("Archive", systemImage: "archivebox")
            }
            .accessibilityLabel("Archive")
        }
    }
}
// VoiceOver reads: "Meeting Tomorrow, Don't forget the 9am call"
// Then announces available actions: "Actions available"
// User can access actions via rotor: "Delete, button" "Archive, button"
""",
            badExample: {
                VStack(spacing: 20) {
                    Text("Swipe left to reveal actions:")
                        .font(.caption)
                        .foregroundColor(.secondary)

                    VStack(spacing: 12) {
                        ForEach(1...3, id: \.self) { index in
                            BadSwipeCard(
                                title: "Message \(index)",
                                subtitle: "Swipe to see options",
                                offset: badSwipeOffset[index] ?? 0,
                                onOffsetChange: { newOffset in
                                    badSwipeOffset[index] = newOffset
                                }
                            )
                        }
                    }

                    Text("⚠️ No visible action buttons - menu hidden behind swipe")
                        .font(.caption)
                        .foregroundColor(.red)
                        .italic()
                        .multilineTextAlignment(.center)
                }
            },
            goodExample: {
                VStack(spacing: 15) {
                    Text("Swipe or use Voice Control actions:")
                        .font(.caption)
                        .foregroundColor(.secondary)

                    List {
                        ForEach(messages) { message in
                            VStack(alignment: .leading, spacing: 4) {
                                Text(message.title)
                                    .font(.headline)
                                Text(message.subtitle)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            .padding(.vertical, 4)
                            .accessibilityElement(children: .combine)
                            .accessibilityLabel("\(message.title), \(message.subtitle)")
                            .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                Button(role: .destructive) {
                                    withAnimation {
                                        messages.removeAll { $0.id == message.id }
                                    }
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }
                                .accessibilityLabel("Delete")

                                Button {
                                    // Archive action
                                } label: {
                                    Label("Archive", systemImage: "archivebox")
                                }
                                .tint(.orange)
                                .accessibilityLabel("Archive")
                            }
                        }
                        .listRowBackground(Color.white)
                    }
                    .listStyle(.plain)
                    .frame(height: 250)
                    .cornerRadius(10)

                    Text("✅ Voice Control can access swipe actions automatically")
                        .font(.caption)
                        .foregroundColor(.green)
                        .italic()
                        .multilineTextAlignment(.center)
                }
            }
        )
    }
}

// Bad swipe card - hidden menu revealed by swipe gesture only
struct BadSwipeCard: View {
    let title: String
    let subtitle: String
    let offset: CGFloat
    let onOffsetChange: (CGFloat) -> Void

    var body: some View {
        ZStack(alignment: .trailing) {
            // Hidden action buttons (revealed by swipe)
            HStack(spacing: 0) {
                Button(action: {}) {
                    ZStack {
                        Color.orange
                        Image(systemName: "archivebox.fill")
                            .foregroundColor(.white)
                    }
                }
                .frame(width: 80)

                Button(action: {}) {
                    ZStack {
                        Color.red
                        Image(systemName: "trash.fill")
                            .foregroundColor(.white)
                    }
                }
                .frame(width: 80)
            }
            .frame(height: 80)

            // Main card content
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.headline)
                    Text(subtitle)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                Spacer()
                Image(systemName: "chevron.left")
                    .foregroundColor(.gray)
                    .font(.caption)
            }
            .padding()
            .frame(height: 80)
            .background(Color.white)
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
            )
            .offset(x: offset)
            .gesture(
                DragGesture()
                    .onChanged { value in
                        let translation = value.translation.width
                        if translation < 0 {
                            onOffsetChange(max(translation, -160))
                        }
                    }
                    .onEnded { value in
                        if value.translation.width < -80 {
                            withAnimation(.spring()) {
                                onOffsetChange(-160)
                            }
                        } else {
                            withAnimation(.spring()) {
                                onOffsetChange(0)
                            }
                        }
                    }
            )
        }
    }
}

