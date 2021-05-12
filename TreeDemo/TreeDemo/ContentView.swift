//
//  ContentView.swift
//  TreeDemo
//
//  Created by roy on 2021/5/12.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            List(Feature.allCases) { feature in
                if .folder == feature {
                    NavigationLink(destination: ViewWrapper<TestFolderViewController>()) {
                        Text(feature.rawValue)
                            .fontWeight(.bold)
                    }
                } else {
                    NavigationLink(destination: ViewWrapper<FolderListViewController>()) {
                        Text(feature.rawValue)
                            .fontWeight(.bold)
                    }
                }
            }
        }
    }
}

enum Feature: String, CaseIterable, Identifiable {
    case treeListView = "Tree list view."
    case folder = "Xim Folder"
    
    var id: String { rawValue }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
