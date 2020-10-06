// Copyright 2020 by Ryan Ferrell. All rights reserved. Contact at github.com/wingovers

import SwiftUI

extension Font {
    static let standardTipText: Font = .system(.body, design: .rounded)
    static let iconSubtitle: Font = .system(.footnote, design: .rounded)

    // PreferencesSectionComponent, AboutAppHeadline
    static let sectionTitle: Font = .system(.title3, design: .rounded)

    // RootDirectorySection, TempDirectoryLabel,
    static let directoryStandard: Font = .system(.title3, design: .rounded)
    static let olderDirectoriesTextImage: Font =  .system(.subheadline, design: .rounded)

    static let prefsItemHeader: Font = .system(.headline, design: .rounded)
    static let prefsItemCaption: Font = .system(.callout, design: .rounded)
    static let prefsMenubarIconsLabel: Font = .system(.footnote, design: .rounded)

    static let feedbackHelpIcons: Font = .system(.title2, design: .rounded)
    static let feedbackHelpCaption: Font = .system(.body, design: .rounded)

    static let faqHeadline: Font = .system(.headline, design: .rounded)
    static let aboutColumnText: Font = .system(.caption, design: .rounded)

    static let onboardingHeader: Font = .system(.title2, design: .rounded)
    static let onboardingChecklist: Font = .system(.title3, design: .rounded)
    static let onboardingChecklistImage: Font = .system(.headline, design: .rounded)
    static let onboardingButtonLabel: Font = .system(.headline, design: .rounded)

}

extension Font.Weight {
    static let onboardingHeader: Font.Weight = .semibold
    static let onboardingChecklist: Font.Weight = .medium
}
