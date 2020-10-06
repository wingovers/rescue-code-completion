// Copyright 2020 by Ryan Ferrell. All rights reserved. Contact at github.com/wingovers

import Cocoa
import OSLog

let logger = Logger.init(subsystem: "RescueLogin", category: "trouble")

@main
class LoginAppDelegate: NSObject, NSApplicationDelegate {
    let mainAppBundleID = "com.wingovers.rescueCodeCompletion"
    let appName = "Rescue Code Completion"

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        if mainAppIsRunning() {
            terminateHelper()
        } else {
            observeKillNotification()
            openMainApp()
        }
    }

    func applicationWillTerminate(_ aNotification: Notification) {}

}

private extension LoginAppDelegate {

    func mainAppIsRunning() -> Bool {
        let runningApps = NSWorkspace.shared.runningApplications
        let isRunning = runningApps.contains {
            $0.bundleIdentifier == mainAppBundleID
        }
        return isRunning
    }

    func openMainApp() {
        let path = Bundle.main.bundlePath as NSString
        var components = path.pathComponents
        components.removeLast(3)
        components.append("MacOS")
        components.append(appName)
        let mainAppPath = NSString.path(withComponents: components)
        let config = NSWorkspace.OpenConfiguration()
        NSWorkspace.shared.openApplication(at: URL(fileURLWithPath: mainAppPath as String),
                                           configuration: config) { (_, error) in
            if let theError = error {
                logger.error("\(#function) path: \(mainAppPath)")
                logger.error("\(#function) error: \(theError.localizedDescription)")
            }
        }
    }

    func observeKillNotification() {
        DistributedNotificationCenter.default()
            .addObserver(self,
                         selector: #selector(terminateHelper),
                         name: .killLauncher,
                         object: mainAppBundleID)
    }

    @objc func terminateHelper() {
        NSApp.terminate(nil)
    }
}

extension Notification.Name {
    static let killLauncher = Notification.Name("killLauncher")
}
