# VoiceOver Demo App

A comprehensive iOS demo application for teaching VoiceOver accessibility best practices in SwiftUI.

## Overview

This app demonstrates common accessibility issues and their solutions, helping developers understand how to build accessible iOS applications. Each demo page shows side-by-side comparisons of bad (inaccessible) and good (accessible) implementations with code examples.

## Features

### Demo Pages

1. **Default Language Demo** - Shows how app language defaults work and how to set explicit language
2. **Language & Localization** - Demonstrates proper pronunciation of multilingual text with locale settings
3. **Accessibility Traits** - Compares traits vs native components (.isButton, .isLink, etc.)
4. **Focus Management** - Shows VoiceOver focus control with @AccessibilityFocusState
5. **Dialog Implementation** - Demonstrates proper modal dialogs with .isModal trait and ESC key support
6. **State Traits** - Shows .isSelected trait usage for selection states
7. **Custom Accessibility Actions** - Multiple interaction methods (tap, swipe, action sheet, context menu)
8. **Grouping Elements** - Demonstrates .combine, .ignore, and .contain grouping options
9. **RTL/LTR Reading Order** - Shows proper Right-to-Left language support with locale and layoutDirection
10. **Form Validation** - Proper error handling with .accessibilityHint() and focus management
11. **Reading Order Issues** - Demonstrates proper element reading order

## Technical Details

- **Platform**: iOS (SwiftUI)
- **Language**: Swift
- **Minimum iOS Version**: iOS 14.0+
- **Architecture**: SwiftUI with reusable DemoPageTemplate component

## Key Accessibility Concepts Covered

- `.accessibilityLabel()` - Custom labels for elements
- `.accessibilityValue()` - Current values
- `.accessibilityHint()` - Usage hints and error messages
- `.accessibilityAddTraits()` - Adding semantic traits (.isButton, .isLink, .isModal, .isSelected)
- `.accessibilityElement(children:)` - Grouping elements (.combine, .ignore, .contain)
- `.accessibilityFocused()` - Focus management with @AccessibilityFocusState
- `.accessibilityHidden()` - Hiding decorative elements
- `.environment(\.locale)` - Setting language for proper pronunciation
- `.environment(\.layoutDirection)` - RTL/LTR layout adaptation
- `.accessibilityAction()` - Custom actions for VoiceOver
- `.keyboardShortcut()` - Keyboard support for dialogs

## Project Structure

```
VoiceOverDemo/
├── ContentView.swift              # Root view
├── MenuView.swift                 # Main menu with hamburger navigation
├── SideMenuView.swift            # Side drawer with demo list
├── DemoPageTemplate.swift        # Reusable template for demo pages
├── DefaultLanguageDemoView.swift
├── LanguageDemoView.swift
├── TraitsDemoView.swift
├── FocusDemoView.swift
├── DialogDemoView.swift
├── StateDemoView.swift
├── CustomActionsDemoView.swift
├── GroupingDemoView.swift
├── RTLDemoView.swift
├── FormValidationDemoView.swift
├── ReadingOrderDemoView.swift
└── Resources/
    └── Localizable.strings       # Localization files (en, fr, es)
```

## Testing with VoiceOver

1. Enable VoiceOver: Settings > Accessibility > VoiceOver
2. Navigate through each demo page
3. Compare behavior between bad and good examples
4. Test with different languages (Arabic for RTL, French/Spanish for pronunciation)

## Key Learnings

- Always use semantic components (Button, Link) or add proper traits
- Use TextField's label parameter for form labels, not separate Text views
- Associate form errors with fields using `.accessibilityHint()`
- Hide decorative images from accessibility tree with `.accessibilityHidden(true)`
- Set locale explicitly for multilingual content - it doesn't auto-detect
- Use `.environment(\.layoutDirection, .rightToLeft)` for RTL visual adaptation
- Manage focus programmatically after form validation failures
- Support keyboard shortcuts (ESC, Enter) for modal dialogs
- Provide multiple interaction methods (tap, swipe, menus) for actions

## Contributing

This is a demo/teaching project. Feel free to use as reference for your own accessibility implementations.
