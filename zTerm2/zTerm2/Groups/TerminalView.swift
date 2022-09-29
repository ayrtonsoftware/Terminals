//
//  TerminalView.swift
//  zTerm2
//
//  Created by Michael Bergamo on 9/27/22.
//

import SwiftUI
import SwiftTerm

struct TerminalView: NSViewRepresentable {
    typealias NSViewType = LocalProcessTerminalView
    @State var delegate: LocalProcessTerminalViewDelegate = TerminalProcessDelegate()
    
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
    
    func makeNSView(context: Context) -> SwiftTerm.LocalProcessTerminalView {
        print("makeNSView")
        let terminal = LocalProcessTerminalView(frame: CGRect.zero)
        let shell = getShell()
        let shellIdiom = "-" + NSString(string: shell).lastPathComponent
        FileManager.default.changeCurrentDirectoryPath (FileManager.default.homeDirectoryForCurrentUser.path)
        terminal.startProcess (executable: shell, execName: shellIdiom)
        terminal.processDelegate = delegate
        terminal.getTerminal().setCursorStyle(.blinkUnderline)
        terminal.getTerminal().foregroundColor = SwiftTerm.Color(red: 65000, green: 65000, blue: 65000)
        terminal.getTerminal().backgroundColor = SwiftTerm.Color(red: 30000, green: 30000, blue: 30000)
        terminal.getTerminal().cursorColor = SwiftTerm.Color(red: 65000, green: 65000, blue: 65000)
        return terminal
    }
    
    func updateNSView(_ nsView: SwiftTerm.LocalProcessTerminalView, context: Context) {
        print("updateNSView")
    }
}

class TerminalProcessDelegate: LocalProcessTerminalViewDelegate {
    func sizeChanged(source: SwiftTerm.LocalProcessTerminalView, newCols: Int, newRows: Int) {
        
    }
    
    func setTerminalTitle(source: SwiftTerm.LocalProcessTerminalView, title: String) {
        
    }
    
    func hostCurrentDirectoryUpdate(source: SwiftTerm.TerminalView, directory: String?) {
        
    }
    
    func processTerminated(source: SwiftTerm.TerminalView, exitCode: Int32?) {
        source.window?.close()
    }
}
