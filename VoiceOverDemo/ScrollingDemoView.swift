//
//  ScrollingDemoView.swift
//  VoiceOverDemo
//
//  Created by Bogdan Sikora on 07.10.2025.
//

import SwiftUI

struct ScrollingDemoView: View {
    var body: some View {
        DemoPageTemplate(
            title: "Scrollable Areas",
            description: "Nested scrolling in the same direction (vertical inside vertical) creates accessibility conflicts. VoiceOver users struggle when ScrollViews in the same direction are nested because the system can't determine which ScrollView should handle gestures. Instead, use horizontal scrolling within vertical layouts to avoid conflicts.",
            badExampleTitle: "❌ Bad Example - Nested Vertical Scrolling",
            goodExampleTitle: "✅ Good Example - Horizontal Scrolling",
            explanation: """
The critical rule for accessible scrolling: NEVER nest ScrollViews in the same direction.

Why nested vertical scrolling fails:
• Vertical ScrollView inside another vertical ScrollView creates gesture ambiguity
• VoiceOver users can't reliably navigate when two vertical scrolls compete
• The system doesn't know which ScrollView should respond to scroll gestures
• Unpredictable behavior frustrates users trying to access content

The solution: Use perpendicular scrolling directions:
• Horizontal ScrollViews inside vertical layouts work perfectly
• This creates clear gestural boundaries - vertical vs horizontal swipes
• VoiceOver users can swipe vertically through items and horizontally within carousels
• Touch users get intuitive, predictable scrolling behavior

Best practices:
• Design layouts with horizontal carousels in vertical pages (Pinterest, App Store style)
• Avoid modal sheets with vertical ScrollViews if parent already scrolls vertically
• Consider paginated views or expandable sections instead of nested vertical scrolls
• Test with VoiceOver enabled to verify gesture boundaries work as expected
""",
            codeSnippet: """
// ❌ BAD - Nested vertical scrolling creates conflicts
// This page already scrolls vertically, and we add another vertical ScrollView
ScrollView {  // Nested vertical scroll - PROBLEMATIC!
    VStack(spacing: 10) {
        ForEach(1...20, id: \\.self) { index in
            Text("Item \\(index)")
                .padding()
                .background(Color.white)
        }
    }
}
.frame(height: 250)
// Problem: Two vertical ScrollViews compete for gesture handling
// VoiceOver users experience unpredictable behavior
// The system can't determine which ScrollView should handle vertical swipes

// ✅ GOOD - Horizontal scrolling within vertical layout
// Clear gestural boundaries: vertical page scroll vs horizontal carousel
ScrollView(.horizontal, showsIndicators: true) {
    HStack(spacing: 10) {
        ForEach(1...20, id: \\.self) { index in
            VStack {
                Image(systemName: "photo.fill")
                Text("Item \\(index)")
            }
            .frame(width: 120, height: 120)
            .background(Color.white)
            .cornerRadius(8)
        }
    }
    .padding(8)
}
.frame(height: 140)
// Clear gesture separation: swipe left/right for carousel, up/down for page
// VoiceOver users can navigate vertically and horizontally without conflicts
// Common pattern in iOS: App Store, Photos app, Pinterest, etc.
""",
            badExample: {
                VStack(spacing: 10) {
                    Text("⚠️ Nested vertical scroll within vertical page")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)

                    BadScrollExample()

                    Text("Gesture conflicts - which scroll should respond?")
                        .font(.caption)
                        .foregroundColor(.red)
                        .italic()
                        .multilineTextAlignment(.center)
                }
            },
            goodExample: {
                VStack(spacing: 10) {
                    Text("✅ Horizontal carousel - clear gesture separation")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)

                    GoodScrollExample()

                    Text("Swipe left/right for carousel, up/down for page")
                        .font(.caption)
                        .foregroundColor(.green)
                        .italic()
                        .multilineTextAlignment(.center)
                }
            }
        )
    }
}

// Bad ScrollView - nested vertical scroll creates conflicts
struct BadScrollExample: View {
    var body: some View {
        VStack(spacing: 0) {
            // Warning indicator
            HStack {
                Image(systemName: "exclamationmark.triangle.fill")
                    .foregroundColor(.red)
                Text("Nested Vertical Scroll")
                    .font(.caption)
                    .fontWeight(.semibold)
            }
            .padding(8)
            .frame(maxWidth: .infinity)
            .background(Color.red.opacity(0.1))
            
            // Nested vertical ScrollView - PROBLEMATIC
            ScrollView {
                VStack(spacing: 10) {
                    ForEach(1...15, id: \.self) { index in
                        HStack {
                            Image(systemName: "arrow.up.arrow.down.circle.fill")
                                .foregroundColor(.red.opacity(0.7))
                            Text("Item \(index)")
                                .font(.body)
                            Spacer()
                            Image(systemName: "xmark.circle")
                                .foregroundColor(.red)
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(8)
                    }
                }
                .padding(.horizontal, 8)
                .padding(.top, 8)
            }
            .background(Color(.systemGray6))
        }
        .frame(height: 250)
        .cornerRadius(10)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.red, lineWidth: 2)
        )
        // Nested vertical scroll - conflicts with page's vertical scroll
        // VoiceOver users can't reliably navigate
        // Gesture ambiguity causes unpredictable scrolling
    }
}

// Good ScrollView - horizontal carousel avoids nesting conflicts
struct GoodScrollExample: View {
    var body: some View {
        VStack(spacing: 0) {
            // Success indicator
            HStack {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(.green)
                Text("Horizontal Carousel")
                    .font(.caption)
                    .fontWeight(.semibold)
            }
            .padding(8)
            .frame(maxWidth: .infinity)
            .background(Color.green.opacity(0.1))
            
            // Horizontal ScrollView - GOOD for nested scrolling
            ScrollView(.horizontal, showsIndicators: true) {
                HStack(spacing: 12) {
                    ForEach(1...20, id: \.self) { index in
                        VStack(spacing: 8) {
                            Image(systemName: "photo.fill")
                                .font(.system(size: 40))
                                .foregroundColor(.green.opacity(0.7))
                            Text("Photo \(index)")
                                .font(.caption)
                                .fontWeight(.medium)
                        }
                        .frame(width: 100, height: 100)
                        .background(Color.white)
                        .cornerRadius(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.green.opacity(0.3), lineWidth: 1)
                        )
                    }
                }
                .padding(12)
            }
            .frame(height: 140)
            .background(Color(.systemGray6))
        }
        .cornerRadius(10)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.green, lineWidth: 2)
        )
        // Horizontal carousel works perfectly in vertical page
        // Clear gesture boundaries: swipe left/right for carousel, up/down for page
        // VoiceOver users can navigate without conflicts
        // Common pattern: App Store, Photos, Pinterest, etc.
    }
}
