//
//  launchdaddyApp.swift
//  launchdaddy
//
//  Created by Sayan Goswami on 05/11/22.
//

import SwiftUI
import System

struct LaunchdFolder: Identifiable {
    let id = UUID()
    let path: String
    let name: String
    let description: String
}

final class LaunchdFolders : ObservableObject {
    @Published var paths = [
        "Agents": [
            LaunchdFolder(path: "/System/Library/LaunchAgents", name: "Apple", description: "Apple-supplied agents that apply to all users on a per-user basis"),
            LaunchdFolder(path: "/Library/LaunchAgents", name: "Third Party", description: "Third-party agents that apply to all users on a per-user basis"),
            LaunchdFolder(path: "~/Library/LaunchAgents", name: "Third Party (User)", description: "Third-party agents that apply only to the logged-in user")
        ],
        "Daemons": [
            LaunchdFolder(path: "/System/Library/LaunchDaemons", name: "Apple", description: "Apple-supplied system daemons"),
            LaunchdFolder(path: "/Library/LaunchDaemons", name: "Third Party", description: "Third-party system daemons"),
        ]
    ]
}


@main
struct launchdaddyApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationSplitView {
                SidebarNav(folders: LaunchdFolders())
                    .navigationSplitViewColumnWidth(min: 150, ideal: 150, max: 150)
                
            } detail: {
            }
        }
    }
}
