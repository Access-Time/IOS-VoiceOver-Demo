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

    // Good example 1 state
    @State private var goodSearchText = ""
    @State private var searchResultsAnnouncement = ""

    // Good example 2 state (searchable)
    @State private var nativeSearchText = ""

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

    var nativeFilteredItems: [String] {
        if nativeSearchText.isEmpty {
            return sampleItems
        }
        return sampleItems.filter { $0.localizedCaseInsensitiveContains(nativeSearchText) }
    }

    var body: some View {
        DemoPageTemplate(
            title: "Search Results",
            description: "When search results change, VoiceOver users need to be notified about the number of results found. Without announcements, users have no feedback that the search executed or how many results were found.",
            badExampleTitle: "❌ Bad Example - No Announcements",
            goodExampleTitle: "✅ Good Examples - With Announcements",
            explanation: "Use AccessibilityNotification to announce search results, or use SwiftUI's native .searchable() modifier which handles announcements automatically.",
            codeSnippet: """
// Bad - no announcement
TextField("Search", text: $searchText)
List(filteredItems) { item in
    Text(item)
}

// Good Option 1 - manual announcement
TextField("Search", text: $searchText)
    .onChange(of: searchText) { oldValue, newValue in
        let count = filteredItems.count
        let message = "\\(count) results found"
        AccessibilityNotification.Announcement(message)
            .post()
    }

// Good Option 2 - native .searchable()
List(filteredItems) { item in
    Text(item)
}
.searchable(text: $searchText)
// Automatically announces results!
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
                VStack(spacing: 16) {
                    Text("Two ways to announce search results:")
                        .font(.caption)
                        .foregroundColor(.secondary)

                    // Option 1: Manual announcement
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Option 1: Manual Announcement")
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundColor(.blue)

                        VStack(spacing: 8) {
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
                                VStack(spacing: 6) {
                                    ForEach(goodFilteredItems, id: \.self) { item in
                                        HStack {
                                            Image(systemName: "leaf.fill")
                                                .foregroundColor(.green)
                                                .font(.caption)
                                                .accessibilityHidden(true)
                                            Text(item)
                                                .font(.subheadline)
                                            Spacer()
                                        }
                                        .padding(.horizontal, 12)
                                        .padding(.vertical, 6)
                                        .background(Color.white)
                                        .cornerRadius(6)
                                    }
                                }
                                .padding(.horizontal)
                            }
                            .frame(height: 100)
                        }
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(8)
                    }

                    // Option 2: Native .searchable()
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Option 2: Native .searchable()")
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundColor(.blue)

                        SearchableListView(searchText: $nativeSearchText, items: nativeFilteredItems)
                            .frame(height: 150)
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(8)
                    }

                    Text("✅ Both announce results to VoiceOver")
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
        let message = count == 1 ? "1 result found" : "\(count) results found"
        searchResultsAnnouncement = message

        AccessibilityNotification.Announcement(message)
            .post()
    }
}

// Helper view for native searchable demo
struct SearchableListView: View {
    @Binding var searchText: String
    let items: [String]

    var body: some View {
        NavigationStack {
            List(items, id: \.self) { item in
                HStack {
                    Image(systemName: "leaf.fill")
                        .foregroundColor(.green)
                        .font(.caption)
                        .accessibilityHidden(true)
                    Text(item)
                        .font(.subheadline)
                }
            }
            .searchable(text: $searchText, prompt: "Search fruits")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
