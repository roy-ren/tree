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
    
//    /// 层级深度：对应树的深度
//    var level: Int { get }
    
    /// 父节点的 id
    var superIdentifier: ID? { get }
    
    /// 在同级中的排序
    var rank: Int { get }
    
    /// 展开状态
    var state: FolderState { get }
}

public struct Folder<Element: FolderElementProtocol> {
    typealias Node = BinaryNode<Element>
    let root: Node
    
    init(elements: [Element]) {
        let group = Dictionary(
            grouping: elements,
            by: { $0.superIdentifier }
        )
        
        guard let firstLevelItems = group[nil], !firstLevelItems.isEmpty else {
            self.root = .init()
            return
        }

		var stack = Stack<Element>()

		func push(items: [Element]) {
			items
				.sorted { $0.rank < $1.rank }
				.forEach { stack.push(item: $0) }
		}

		var leftNodeStack = Stack<Node>()
		var rightNodeStack = Stack<Node>()

		push(items: firstLevelItems)

		func construct(element: Element) -> Node {
			var left = Node()
			if let top = leftNodeStack.top, top.data?.superIdentifier == element.id {
				leftNodeStack.pop()
				left = top
			}

			var right = Node()
			if let top = rightNodeStack.top, top.data?.superIdentifier == element.superIdentifier {
				rightNodeStack.pop()
				right = top
			}

			return .node(left: left, element: element, right: right)
		}

		var root = Node()

		while let top = stack.top {
			if leftNodeStack.top?.data?.superIdentifier != top.id, let items = group[top.id] {
				push(items: items)
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

		self.root = root
    }
}
