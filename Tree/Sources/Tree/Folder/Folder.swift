//
//  Folder.swift
//  
//
//  Created by roy on 2021/4/22.
//

import Foundation

public enum FolderConfigElement<Element: FolderElementConstructable> {
    case normal(Element)
    case folder(Element)
    
    public var element: Element {
        switch self {
        case .normal(let element):
            return element
        case .folder(let element):
            return element
        }
    }
}

public struct Folder<Element: FolderElementConstructable> {
    typealias Item = FolderItem<Element>
    typealias Node = BinaryNode<Item>
    private(set) var root: Node
    private(set) var sections = [Section]()
    
    var numberOfSections: Int { sections.count }
    
    public init(elements: [Element] = []) {
        self.root = Item.recursiveConstructNode(with: elements)
    }
}

public extension Folder {
    struct Section {
        let item: Element
        let subItems: [Element]
        
        var numberOfRows: Int {
            subItems.count
        }
    }
    
    func element(forRowAt indexPath: IndexPath) -> Element {
        sections[indexPath.section].subItems[indexPath.row]
    }
    
    func element(for section: Int) -> Element {
        sections[section].item
    }
    
    mutating func constructTableDataSource() {
        var sections = [Section]()
        
        func construct(node: Node) {
            
        }
        
        self.sections = sections
    }
}
