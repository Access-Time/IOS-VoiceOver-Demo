//
//  SearchDemoView.swift
//  VoiceOverDemo
//
//  Created by Bogdan Sikora on 08.10.2025.
//

import SwiftUI

struct SearchDemoView: View {
    // Bad example state
    @State private var badSearchText = ""

    // Good example state
    @State private var goodSearchText = ""
    @State private var searchResultsAnnouncement = ""

    let sampleItems = [
        "Apple", "Banana", "Cherry", "Date", "Elderberry",
        "Fig", "Grape", "Honeydew", "Kiwi", "Lemon",
        "Mango", "Orange", "Papaya", "Raspberry", "Strawberry"
    ]

    var badFilteredItems: [String] {
        if badSearchText.isEmpty {
            return sampleItems
        }
        return sampleItems.filter { $0.localizedCaseInsensitiveContains(badSearchText) }
    }

    var goodFilteredItems: [String] {
        if goodSearchText.isEmpty {
            return sampleItems
        }
        return sampleItems.filter { $0.localizedCaseInsensitiveContains(goodSearchText) }
    }


    var body: some View {
        DemoPageTemplate(
            title: "Search Results",
            description: "When search results change, VoiceOver users need to be notified about the number of results found. Without announcements, users have no feedback that the search executed or how many results were found.",
            badExampleTitle: "❌ Bad Example - No Announcements",
            goodExampleTitle: "✅ Good Examples - With Announcements",
            explanation: "Use AccessibilityNotification to announce search results when the search text changes. Use .low priority so announcements don't interrupt other VoiceOver speech.",
            codeSnippet: """
// Bad - no announcement
TextField("Search", text: $searchText)
List(filteredItems) { item in
    Text(item)
}

// Good - with announcement
TextField("Search", text: $searchText)
    .onChange(of: searchText) { oldValue, newValue in
        let count = filteredItems.count
        var message = AttributedString("\\(count) results found")
        message.accessibilitySpeechAnnouncementPriority = .low
        AccessibilityNotification.Announcement(message)
            .post()
    }
""",
            badExample: {
                VStack(spacing: 20) {
                    Text("Search without announcements:")
                        .font(.caption)
                        .foregroundColor(.secondary)

                    VStack(spacing: 12) {
                        TextField("Search fruits", text: $badSearchText)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.horizontal)

                        ScrollView {
                            VStack(spacing: 8) {
                                ForEach(badFilteredItems, id: \.self) { item in
                                    HStack {
                                        Image(systemName: "leaf.fill")
                                            .foregroundColor(.green)
                                            .accessibilityHidden(true)
                                        Text(item)
                                        Spacer()
                                    }
                                    .padding(.horizontal)
                                    .padding(.vertical, 8)
                                    .background(Color.white)
                                    .cornerRadius(6)
                                }
                            }
                            .padding(.horizontal)
                        }
                        .frame(height: 200)
                    }
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(8)

                    Text("⚠️ No feedback when results change")
                        .font(.caption)
                        .foregroundColor(.red)
                        .italic()
                        .multilineTextAlignment(.center)
                }
            },
            goodExample: {
                VStack(spacing: 20) {
                    Text("Search with announcements:")
                        .font(.caption)
                        .foregroundColor(.secondary)

                    VStack(spacing: 12) {
                        TextField("Search fruits", text: $goodSearchText)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.horizontal)
                            .onChange(of: goodSearchText) { oldValue, newValue in
                                announceSearchResults()
                            }

                        Text(searchResultsAnnouncement)
                            .font(.caption)
                            .foregroundColor(.blue)
                            .padding(.horizontal)

                        ScrollView {
                            VStack(spacing: 8) {
                                ForEach(goodFilteredItems, id: \.self) { item in
                                    HStack {
                                        Image(systemName: "leaf.fill")
                                            .foregroundColor(.green)
                                            .accessibilityHidden(true)
                                        Text(item)
                                        Spacer()
                                    }
                                    .padding(.horizontal)
                                    .padding(.vertical, 8)
                                    .background(Color.white)
                                    .cornerRadius(6)
                                }
                            }
                            .padding(.horizontal)
                        }
                        .frame(height: 200)
                    }
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(8)

                    Text("✅ Announces results to VoiceOver")
                        .font(.caption)
                        .foregroundColor(.green)
                        .italic()
                        .multilineTextAlignment(.center)
                }
            }
        )
    }

    func announceSearchResults() {
        let count = goodFilteredItems.count
        let messageText = count == 1 ? "1 result found" : "\(count) results found"
        searchResultsAnnouncement = messageText

        var message = AttributedString(messageText)
        message.accessibilitySpeechAnnouncementPriority = .low

        AccessibilityNotification.Announcement(message)
            .post()
    }
}

