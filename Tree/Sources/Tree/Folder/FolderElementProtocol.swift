//
//  FolderElementProtocol.swift
//  
//
//  Created by roy on 2021/5/11.
//

import Foundation

public protocol Identifiable {
    associatedtype ID: Hashable
    
    /// 唯一 id
    var id: Self.ID { get }
}

public protocol FolderElementConstructable: Identifiable, Equatable {
    associatedtype Element
    
    /// 数据
    var element: Self.Element { get }
    
    /// 父节点的 id
    var superIdentifier: ID? { get }
    
    /// 在同级中的排序
    var rank: Int { get set }
}

//extension BinaryNode where Element: FolderElementConstructable {
//    static func constructNode(with elements: [Element]) -> BinaryNode {
//        typealias Node = BinaryNode<Element>
//
//        let group = Dictionary(
//            grouping: elements,
//            by: { $0.superIdentifier }
//        )
//
//        guard let firstLevelItems = group[nil], !firstLevelItems.isEmpty else {
//            return .init()
//        }
//
//        var stack = Stack<Element>()
//
//        func push(items: [Element]) {
//            items
//                .sorted { $0.rank < $1.rank }
//                .forEach { stack.push(item: $0) }
//        }
//
//        var leftNodeStack = Stack<Node>()
//        var rightNodeStack = Stack<Node>()
//
//        push(items: firstLevelItems)
//
//        func construct(element: Element) -> Node {
//            var left = Node()
//            if let top = leftNodeStack.top, top.element?.superIdentifier == element.id {
//                leftNodeStack.pop()
//                left = top
//            }
//
//            var right = Node()
//            if let top = rightNodeStack.top, top.element?.superIdentifier == element.superIdentifier {
//                rightNodeStack.pop()
//                right = top
//            }
//
//            return .node(left: left, element: element, right: right)
//        }
//
//        var root = Node()
//
//        while let top = stack.top {
//            if leftNodeStack.top?.element?.superIdentifier != top.id, let items = group[top.id] {
//                push(items: items)
//                continue
//            }
//
//            stack.pop()
//
//            let node = construct(element: top)
//            guard let currentTop = stack.top else {
//                root = node
//                break
//            }
//
//            if top.superIdentifier == currentTop.id {
//                leftNodeStack.push(item: node)
//            } else if top.superIdentifier == currentTop.superIdentifier {
//                rightNodeStack.push(item: node)
//            }
//        }
//
//        return root
//    }
//}
