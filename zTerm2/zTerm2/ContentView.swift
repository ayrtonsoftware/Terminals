//
//  ContentView.swift
//  zTerm2
//
//  Created by Michael Bergamo on 9/27/22.
//

import SwiftUI

struct TabItem: Identifiable {
    var id = UUID()
    var terminal: TerminalView
    var termNum: Int
}

struct ContentView: View {
    @State var termCount = 1
    @State var tabs: [TabItem] = [TabItem(terminal: TerminalView(), termNum: 1)]
    @State private var selectedTab = 0
        
    private func newTerminal() -> TabItem {
        termCount += 1
        let tab = TabItem(terminal: TerminalView(), termNum: termCount)
        tabs.append(tab)
        return tab
    }
    
    var body: some View {
        VStack {
            HStack {
                Image(systemName: "globe")
                    .imageScale(.large)
                    .foregroundColor(.accentColor)
                Button {
                    newTerminal()
                } label: {
                    Text("⌘T")
                }
                
            }
            TabView(selection: $selectedTab) {
                ForEach(tabs) {tab in
                    tab.terminal
                        .tabItem {
                            Label("Editor", systemImage: "pencil.circle")
                        }
                }
            }
        }
        .padding()
        .frame(minWidth: 600, minHeight: 400)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
