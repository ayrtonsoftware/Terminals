//
//  AppDelegate.swift
//  zTerm
//
//  Created by Michael Bergamo on 9/27/22.
//

import Cocoa

@main
class AppDelegate: NSObject, NSApplicationDelegate {

    
    @IBAction func onNewWindow(sender: AnyObject) {
        let mainWindowController = NSStoryboard(name: "Terminal", bundle: nil).instantiateController(withIdentifier: "Terminal") as? NSWindowController
                mainWindowController?.showWindow(nil)
    }

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
        return true
    }


}

