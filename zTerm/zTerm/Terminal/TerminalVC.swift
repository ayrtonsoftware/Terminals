//
//  ViewController.swift
//  zTerm
//
//  Created by Michael Bergamo on 9/27/22.
//

import Cocoa
import SwiftTerm

class TerminalVC: NSViewController, LocalProcessTerminalViewDelegate {
    var changingSize = false
    
    // Returns the shell associated with the current account
    func getShell () -> String
    {
        let bufsize = sysconf(_SC_GETPW_R_SIZE_MAX)
        guard bufsize != -1 else {
            return "/bin/bash"
        }
        let buffer = UnsafeMutablePointer<Int8>.allocate(capacity: bufsize)
        defer {
            buffer.deallocate()
        }
        var pwd = passwd()
        var result: UnsafeMutablePointer<passwd>? = UnsafeMutablePointer<passwd>.allocate(capacity: 1)
        
        if getpwuid_r(getuid(), &pwd, buffer, bufsize, &result) != 0 {
            return "/bin/bash"
        }
        return String (cString: pwd.pw_shell)
    }
    
    func sizeChanged(source: SwiftTerm.LocalProcessTerminalView, newCols: Int, newRows: Int) {
    }
    
    func setTerminalTitle(source: SwiftTerm.LocalProcessTerminalView, title: String) {
    }
    
    func hostCurrentDirectoryUpdate(source: SwiftTerm.TerminalView, directory: String?) {
    }
    
    func processTerminated(source: SwiftTerm.TerminalView, exitCode: Int32?) {
        self.view.window?.close()
    }
    
    var terminal: LocalProcessTerminalView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let terminal = LocalProcessTerminalView(frame: view.frame)
        self.terminal = terminal
        // Do any additional setup after loading the view.
        let shell = getShell()
        let shellIdiom = "-" + NSString(string: shell).lastPathComponent
        FileManager.default.changeCurrentDirectoryPath (FileManager.default.homeDirectoryForCurrentUser.path)
        terminal.startProcess (executable: shell, execName: shellIdiom)
        terminal.processDelegate = self
        view.addSubview(terminal)
    }
    
    override func viewDidLayout() {
        super.viewDidLayout()
        terminal.frame = view.frame
        terminal.needsLayout = true
    }
}

