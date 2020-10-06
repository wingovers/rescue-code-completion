//
//  AboutColumnVM.swift
//  Rescue Code Completion
//
//  Created by Ryan on 11/4/20.
//

import Foundation

struct AboutColumnVM {
    let appName = NSLocalizedString("app_name", comment: "proper app name")
    let appIconBundleName = "AppIcon"
    let copyright = NSLocalizedString("copyright_statement", comment: "legal")

    let automationJoke = NSLocalizedString("automation_joke", comment: "joke")
    let xkcdLinkLabel = "xkcd"
    let xkcdLink = URL(string: "https://xkcd.com/1205/")!

    let outsideCopyrights = NSLocalizedString("copyrights_outside", comment: "legal")
}
