//
//  Folder.swift
//  
//
//  Created by roy on 2021/4/22.
//

import Foundation

public protocol Identifiable {
    associatedtype ID : Hashable
    
    /// 唯一 id
    var id: Self.ID { get }
}

public enum FolderState {
    /// 展开状态
    case expand
    /// 闭合状态
    case collapse
    
    mutating func toggle() {
        self = .expand == self ? .collapse : .expand
    }
}

public protocol FolderElementProtocol: Identifiable, Equatable {
    associatedtype Element
    
    /// 数据
    var element: Self.Element { get }
    
    /// 层级深度：对应数的深度
    var level: Int { get }
    
    /// 父节点的 id
    var superIdentifier: ID? { get }
    
    /// 在同级中的排序
    var rank: Int { get }
    
    /// 展开状态
    var state: FolderState { get }
}

public struct Folder<Element: FolderElementProtocol> {
    typealias Node = BinaryNode<Element>
    private let root: Node
    
    init(elements: [Element]) {
        var root = Node()
        
        let group = Dictionary(
            grouping: elements,
            by: { $0.superIdentifier }
        )
        
        guard let firstLevelItems = group[nil], !firstLevelItems.isEmpty else {
            self.root = .init()
            return
        }
        
        func insertSameLevel(element new: Element, to node: Node) -> Node {
            var node = node
            while case let .node(_, data, right) = node {
                if data.rank <= new.rank {
                    if case let .node(_, rightData, nextRight) = right {
                        if 
                        
                    } else {
                        try! node.update(right: .init(element: new))
                    }
                } else {
                    
                }
            }
        }
        
        var firstNode: Node
        firstLevelItems.enumerated().forEach { (offset, element) in
            if 0 == offset {
                firstNode = Node(element: element)
            } else if let firstElement = firstNode.data {
                while <#condition#> {
                    <#code#>
                }
            }
        }
        
        self.root = root
    }
}
