// Copyright 2020 by Ryan Ferrell. All rights reserved. Contact at github.com/wingovers

import SwiftUI

struct PreferencesFeedbackScreen: View {
    
    let factory: ViewControllerFactory

    @State var showFeedback = false
    var body: some View {
        ZStack {
            preferencesLayer
                .blur(radius: showFeedback ? .feedbackBackgroundBlurOut : 0)
                .animation(.linear(duration: .feedbackViewBlurOutDuration), value: showFeedback)
            if showFeedback { feedbackOverlayLayer }
        }
    }

    var preferencesLayer: some View {
        PreferencesScreen(factory: factory)
            .background(background)
            .overlay(feedbackIcon.padding(), alignment: .bottomTrailing)
            .frame(minWidth: .preferencesMinWidth,
                   minHeight: .preferencesMinHeight)
    }

    var feedbackOverlayLayer: some View {
        FeedbackHelpScreen(showFeedback: $showFeedback,
                         vm: factory.makeFeedbackHelpVM(),
                         factory: factory)
    }

    var background: some View {
        Color.feedbackScreenBackground.edgesIgnoringSafeArea(.top)
    }

    var feedbackIcon: some View {
        FeedbackIcon(showFeedback: $showFeedback, vm: factory.makeFeedbackIconVM())
    }
}
