//
//  SideMenuView.swift
//  VoiceOverDemo
//
//  Created by Bogdan Sikora on 07.10.2025.
//

import SwiftUI

struct DemoPage: Identifiable {
    let id = UUID()
    let title: String
    let icon: String
    let destination: AnyView
}

struct SideMenuView: View {
    @Binding var isShowing: Bool
    @Binding var selectedPage: DemoPage?

    let demoPages: [DemoPage] = [
        DemoPage(title: "Default App Language", icon: "globe.badge.chevron.backward", destination: AnyView(DefaultLanguageDemoView())),
        DemoPage(title: "Language & Localization", icon: "globe", destination: AnyView(LanguageDemoView().environment(\.locale, Locale(identifier: "en-US")))),
        DemoPage(title: "Accessibility Traits", icon: "hand.tap", destination: AnyView(TraitsDemoView().environment(\.locale, Locale(identifier: "en-US")))),
        DemoPage(title: "Focus Management", icon: "eye", destination: AnyView(FocusDemoView().environment(\.locale, Locale(identifier: "en-US")))),
        DemoPage(title: "Dialog Implementation", icon: "message", destination: AnyView(DialogDemoView().environment(\.locale, Locale(identifier: "en-US")))),
        DemoPage(title: "State Traits", icon: "checkmark.circle", destination: AnyView(StateDemoView().environment(\.locale, Locale(identifier: "en-US")))),
        DemoPage(title: "Custom Actions", icon: "hand.raised", destination: AnyView(CustomActionsDemoView().environment(\.locale, Locale(identifier: "en-US")))),
        DemoPage(title: "Grouping Elements", icon: "square.grid.2x2", destination: AnyView(GroupingDemoView().environment(\.locale, Locale(identifier: "en-US")))),
        DemoPage(title: "RTL/LTR Reading Order", icon: "arrow.left.arrow.right", destination: AnyView(RTLDemoView().environment(\.locale, Locale(identifier: "en-US")))),
        DemoPage(title: "Form Validation", icon: "checkmark.seal", destination: AnyView(FormValidationDemoView().environment(\.locale, Locale(identifier: "en-US")))),
        DemoPage(title: "Reading Order Issues", icon: "list.number", destination: AnyView(ReadingOrderDemoView().environment(\.locale, Locale(identifier: "en-US"))))
    ]

    var body: some View {
        ZStack {
            if isShowing {
                // Dimmed background
                Color.black
                    .opacity(0.3)
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation {
                            isShowing = false
                        }
                    }
                    .accessibilityHidden(true)

                // Menu content
                HStack {
                    VStack(alignment: .leading, spacing: 0) {
                        // Header
                        VStack(alignment: .leading, spacing: 8) {
                            Text("VoiceOver Demo")
                                .font(.title2)
                                .fontWeight(.bold)
                            Text("Accessibility Examples")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 30)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color(.systemGray6))

                        // Menu items
                        ScrollView {
                            VStack(spacing: 0) {
                                ForEach(demoPages) { page in
                                    Button(action: {
                                        selectedPage = page
                                        withAnimation {
                                            isShowing = false
                                        }
                                    }) {
                                        HStack(spacing: 15) {
                                            Image(systemName: page.icon)
                                                .font(.title3)
                                                .frame(width: 30)
                                                .foregroundColor(.blue)

                                            Text(page.title)
                                                .font(.body)
                                                .foregroundColor(.primary)

                                            Spacer()

                                            Image(systemName: "chevron.right")
                                                .font(.caption)
                                                .foregroundColor(.secondary)
                                        }
                                        .padding(.horizontal, 20)
                                        .padding(.vertical, 16)
                                        .background(selectedPage?.id == page.id ? Color.blue.opacity(0.1) : Color.clear)
                                    }
                                    .accessibilityElement(children: .combine)
                                    .accessibilityAddTraits(.isButton)
                                    .accessibilityLabel(page.title)
                                    .accessibilityHint("Double tap to view this demo")

                                    Divider()
                                        .padding(.leading, 65)
                                }
                            }
                        }

                        Spacer()
                    }
                    .frame(width: 300)
                    .background(Color(.systemBackground))
                    .shadow(radius: 10)

                    Spacer()
                }
                .transition(.move(edge: .leading))
            }
        }
        .animation(.easeInOut, value: isShowing)
    }
}
