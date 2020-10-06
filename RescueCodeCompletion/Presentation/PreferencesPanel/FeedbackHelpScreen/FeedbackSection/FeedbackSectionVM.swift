//
//  FeedbackSectionVM.swift
//  Rescue Code Completion
//
//  Created by Ryan on 11/4/20.
//

import Foundation

struct FeedbackSectionVM {
    let feedbackTitle = NSLocalizedString("feedback_title", comment: "header")
    let feedbackLine1 = NSLocalizedString("feedback_line1", comment: "body text")
    let feedbackLine2 = NSLocalizedString("feedback_line2", comment: "body text")

    let githubPrompt = NSLocalizedString("github_open", comment: "button")
    let githubSymbolOn = Symbols.githubOn.name
    let githubSymbolOff = Symbols.githubOff.name
    let githubURL = URL(string: "https://github.com/wingovers/rescue-code-completion/issues/new")!

    let emailSymbolOn = Symbols.feedbackOn.name
    let emailSymbolOff = Symbols.feedbackOff.name
    let emailPrompt = NSLocalizedString("email_me", comment: "button")

    var emailURL: URL {
        var email = URLComponents(string: "mailto:wingoversdeveloper@gmail.com")!
        email.queryItems = [URLQueryItem(name: "subject", value: "Rescue Code Completion Feedback")]
        return email.url!
    }
}
