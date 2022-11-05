//
//  SidebarNav.swift
//  launchdaddy
//
//  Created by Sayan Goswami on 05/11/22.
//

import SwiftUI

struct SidebarNav: View {
    @ObservedObject var folders: LaunchdFolders
    
    var body: some View {
        List{
            ForEach(Array(folders.paths.keys), id: \.self) { folder in
                Section{
                    ForEach(folders.paths[folder, default: []]) { item in
                        NavigationLink(item.name) {
                            
                        }
                            .help(item.description)
                    }
                } header: {
                    Text(folder)
                }
            }
        }
    }
}

struct SidebarNav_Previews: PreviewProvider {
    static var previews: some View {
        let folders = LaunchdFolders()
        SidebarNav(folders: folders)
    }
}
