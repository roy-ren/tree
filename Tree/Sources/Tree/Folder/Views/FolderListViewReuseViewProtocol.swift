//
//  FolderListViewReuseViewProtocol.swift
//  
//
//  Created by roy on 2021/4/23.
//

import Foundation

protocol Registrable {}

extension Registrable {
    public static var identifier: String {
        return "\(Self.self)"
    }
}

protocol FolderListViewReuseViewProtocol: Registrable {
    associatedtype ContentView: FolderListCellType
    
    var content: ContentView { get }
}

extension FolderListViewReuseViewProtocol {
    func config(_ element: FolderConfigElement<ContentView.Element>) {
        content.config(with: element)
    }
}
