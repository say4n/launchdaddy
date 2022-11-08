//
//  launchdaddyApp.swift
//  launchdaddy
//
//  Created by Sayan Goswami on 05/11/22.
//

import SwiftUI
import System
import OSLog
import CodeMirror_SwiftUI

let logger = Logger()

class LaunchdFolder: Identifiable, Hashable {
    let id = UUID()
    let path: String
    let name: String
    let description: String
    var contents: [String] = []
    
    init(path: String, name: String, description: String) {
        self.path = path
        self.name = name
        self.description = description
        
        self.contents = self.getFolderItems()
    }
    
    static func == (lhs: LaunchdFolder, rhs: LaunchdFolder) -> Bool {
        lhs.path == rhs.path && lhs.name == rhs.name && lhs.description == rhs.description
    }
    
    func hash(into hasher: inout Hasher) {
        return hasher.combine(ObjectIdentifier(self))
    }
    
    private func getFolderItems() -> [String] {
        let fm = FileManager.default
        
        do {
            return try fm.contentsOfDirectory(atPath: self.path).sorted()
        } catch {
            logger.error("Failed to list directory contents.")
            return ["An error occured."]
        }
    }
}

let paths = [
    "Agents": [
        LaunchdFolder(path: "/System/Library/LaunchAgents", name: "Apple", description: "Apple-supplied agents that apply to all users on a per-user basis"),
        LaunchdFolder(path: "/Library/LaunchAgents", name: "Third Party", description: "Third-party agents that apply to all users on a per-user basis"),
        LaunchdFolder(path: "\(FileManager.default.homeDirectoryForCurrentUser.path)/Library/LaunchAgents", name: "Third Party (User)", description: "Third-party agents that apply only to the logged-in user")
    ],
    "Daemons": [
        LaunchdFolder(path: "/System/Library/LaunchDaemons", name: "Apple", description: "Apple-supplied system daemons"),
        LaunchdFolder(path: "/Library/LaunchDaemons", name: "Third Party", description: "Third-party system daemons"),
    ]
]


@main
struct launchdaddyApp: App {
    @State private var columnVisibility = NavigationSplitViewVisibility.all
    @State var selectedFolder: LaunchdFolder?
    @State var selectedItem: String?
    @State var selectedItemContent: String = ""
    
    var body: some Scene {
        WindowGroup {
            NavigationSplitView(columnVisibility: $columnVisibility) {
                List {
                    ForEach(Array(paths.keys), id: \.self) { folder in
                        Section{
                            ForEach(paths[folder, default: []]) { item in
                                Button(item.name, action: {
                                    selectedFolder = item
                                })
                                .help(item.description)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .buttonStyle(.plain)
                            }
                        } header: {
                            Text(folder)
                        }
                    }
                }
                .navigationSplitViewColumnWidth(min: 150, ideal: 150, max: 150)
            } content: {
                if selectedFolder != nil {
                    List {
                        ForEach(selectedFolder!.contents, id: \.self) { folderItem in
                            Button(folderItem, action:{
                                selectedItem = folderItem
                                do {
                                    let urlpath = URL(string: "\(selectedFolder!.path)/\(selectedItem!)")
                                    selectedItemContent = try String(contentsOfFile: urlpath!.absoluteString, encoding: String.Encoding.utf8)
                                } catch let error as NSError {
                                    selectedItemContent = "An error occured trying to read the file.\n\n\(error)"
                                }
                                
                            })
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .buttonStyle(.plain)
                            .fontWeight(selectedItem == folderItem ? Font.Weight.bold : Font.Weight.regular)
                        }
                    }
                } else {
                    Text("Make a selection")
                }
            } detail: {
                if selectedFolder == nil {
                    Text("Select a category")
                } else if (selectedItem == nil) {
                    Text("Select an item")
                } else {
                    CodeView(theme: CodeViewTheme.material, code: $selectedItemContent, mode: CodeMode.xml.mode())
                        .navigationTitle("launchd item")
                        .font(.monospaced(.body)())
                }
            }
        }
    }
}
