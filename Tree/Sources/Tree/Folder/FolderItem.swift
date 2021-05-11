//
//  FolderItem.swift
//  
//
//  Created by roy on 2021/5/11.
//

import Foundation

public enum FolderItemState {
    /// 展开状态
    case expand
    /// 闭合状态
    case collapse
    
    var toggled: Self {
        .expand == self ? .collapse : .expand
    }
    
    mutating func toggle() {
        self = self.toggled
    }
}

struct FolderItem<Element: FolderElementConstructable>: Equatable {
    /// 数据
    var element: Element
    
    /// 层级深度（与树的深度不同）, 根节点的深度为 0
    var depth: Int
    
    /// 展开状态
    var state: FolderItemState
    
    init(element: Element, depth: Int = 0, state: FolderItemState = .expand) {
        self.element = element
        self.depth = depth
        self.state = state
    }
}

extension FolderItem {
    /// 唯一 id
    var id: Element.ID { element.id }
    
    /// 父节点的 id
    var superIdentifier: Element.ID? { element.superIdentifier }
    
    /// 在同级中的排序
    var rank: Int { element.rank }
}

extension FolderItem: CustomStringConvertible {
    var description: String {
        "\(element.element)"
    }
}

extension FolderItem {
    static func recursiveConstructNode<T: FolderElementConstructable>(
        with elements: [T]
    ) -> BinaryNode<FolderItem<T>> {
        typealias Element = FolderItem<T>
        typealias Node = BinaryNode<Element>
        
        var leftNodeInfos = [T.ID: T]()
        var rightNodeInfos = [T.ID: T]()
        
        var rootElement: T?
        
        Dictionary(grouping: elements, by: { $0.superIdentifier })
            .forEach { superID, list in
                var previousElement: T?
                
                list.sorted { $0.rank < $1.rank }
                    .enumerated()
                    .forEach { index, element in
                        if 0 == index { // 父节点的左子树
                            if let id = superID {
                                leftNodeInfos.updateValue(element, forKey: id)
                            } else {
                                rootElement = element
                            }
                        } else { // 兄弟节点的右子树
                            if let id = previousElement?.id {
                                rightNodeInfos.updateValue(element, forKey: id)
                            }
                        }
                        previousElement = element
                    }
        }
        
        guard let rootElement = rootElement else {
            return .init()
        }
        
        func constructNode(of element: T, and depth: Int) -> Node {
            var left = Node()
            if let leftElement = leftNodeInfos[element.id] {
                left = constructNode(of: leftElement, and: depth + 1)
            }
            
            var right = Node()
            if let rightElement = rightNodeInfos[element.id] {
                right = constructNode(of: rightElement, and: depth)
            }
            
            return .node(
                left: left,
                element: .init(element: element, depth: depth),
                right: right
            )
        }
        
        return constructNode(of: rootElement, and: 0)
    }
}

extension FolderItem {
    
    /// 根据已有数据构建二叉树
    /// - Parameter elements: folder 数据（FolderElementConstructable）
    /// - Returns: 二叉树
    static func cyclicalConstructNode<T: FolderElementConstructable>(
        with elements: [T]
    ) -> BinaryNode<FolderItem<T>> {
        typealias Element = FolderItem<T>
        typealias Node = BinaryNode<Element>
        
        let group = Dictionary(
            grouping: elements,
            by: { $0.superIdentifier }
        )
        
        guard let firstLevelItems = group[nil], !firstLevelItems.isEmpty else {
            return .init()
        }
        
        var stack = Stack<Element>()
        
        func push(items: [Element]) {
            items
                .sorted { $0.rank < $1.rank }
                .forEach { stack.push(item: $0) }
        }
        
        var leftNodeStack = Stack<Node>()
        var rightNodeStack = Stack<Node>()
        
        push(items: firstLevelItems.map {
            Element(element: $0, depth: 0, state: .expand)
        })
        
        func construct(element: Element) -> Node {
            var left = Node()
            if let top = leftNodeStack.top, top.element?.superIdentifier == element.id {
                leftNodeStack.pop()
                left = top
            }
            
            var right = Node()
            if let top = rightNodeStack.top, top.element?.superIdentifier == element.superIdentifier {
                rightNodeStack.pop()
                right = top
            }
            
            return .node(left: left, element: element, right: right)
        }
        
        var root = Node()
        
        while let top = stack.top {
            if leftNodeStack.top?.element?.superIdentifier != top.id, let items = group[top.id] {
                push(items: items.map {
                    Element(element: $0, depth: 0, state: .expand)
                })
                continue
            }
            
            stack.pop()
            
            let node = construct(element: top)
            guard let currentTop = stack.top else {
                root = node
                break
            }
            
            if top.superIdentifier == currentTop.id {
                leftNodeStack.push(item: node)
            } else if top.superIdentifier == currentTop.superIdentifier {
                rightNodeStack.push(item: node)
            }
        }
        
        return root
    }
}
