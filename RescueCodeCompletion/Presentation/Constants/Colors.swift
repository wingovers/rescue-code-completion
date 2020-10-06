// Copyright 2020 by Ryan Ferrell. All rights reserved. Contact at github.com/wingovers

import SwiftUI

extension Color {


    static let textNormal: Color = Color(.textColor)
    static let textSoftened: Color = Color(.labelColor)
    static let textFaded: Color = Color(.tertiaryLabelColor)
    static let textMoreFaded: Color = Color(.systemGray)
    static let onboardingText: Color = textSoftened

    static let linkColor: Color = Color(.linkColor)
    static let defaultIDEsansIcon: Color = Color(.systemBlue)
    static let error: Color = Color(.systemYellow)

    static let hoverBlue: Color = Color(.systemBlue)
    static let hoverRedDelete: Color = Color(.systemRed).opacity(0.75)
    static let hoverOnGrayscale: Color = Color(.labelColor)
    static let hoverOffGrayscale: Color = Color(.secondaryLabelColor)
    static let hoverMenubar: Color = Color(.controlAccentColor)
    static let hoverMenubarDeleted: Color = Color(.systemRed)

    static let preferencesSectionTitleBackground: Color = Color(.windowBackgroundColor)
        .opacity(0.7)
    static let feedbackScreenBackground: Color = Color(.textBackgroundColor)
}

extension Double {
    static let brightenOnHover: Double = 0.15
}
