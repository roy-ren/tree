//
//  Folder.swift
//  
//
//  Created by roy on 2021/4/22.
//

import Foundation

public struct FolderEditChange: Equatable {
	static let none = FolderEditChange()

	let insertIndexPaths: [IndexPath]
	let removeIndexPaths: [IndexPath]
	let insertIndexSet: IndexSet
	let removeIndexSet: IndexSet
    
    init(
        insertIndexPaths: [IndexPath] = [],
        removeIndexPaths: [IndexPath] = [],
        insertIndexSet: IndexSet = [],
        removeIndexSet: IndexSet = []
    ) {
        self.insertIndexPaths = insertIndexPaths
        self.removeIndexPaths = removeIndexPaths
        self.insertIndexSet = insertIndexSet
        self.removeIndexSet = removeIndexSet
    }
}

public struct Folder<Element: FolderElementConstructable> {
    public typealias Item = FolderItem<Element>
    
    typealias Node = BinaryNode<Item>
    private(set) var root: Node
    private(set) var sections = [Section]()
    
    var numberOfSections: Int { sections.count }
    
    public init(elements: [Element] = []) {
        self.root = Item.recursiveConstructNode(with: elements)

		constructTableDataSource()
    }
}

extension Folder {
	func item(forRowAt indexPath: IndexPath) -> Item {
		sections[indexPath.section].subItems[indexPath.row]
	}

	func item(for section: Int) -> Item {
		sections[section].item
	}
}

public extension Folder {
	struct Section: Equatable {
        let item: Item
        var subItems: [Item]
        
        init(item: Item, subItems: [Item] = []) {
            self.item = item
            self.subItems = subItems
        }
        
        var numberOfRows: Int {
            subItems.count
        }
        
        mutating func append(subItems new: [Item]) {
            subItems += new
        }
    }
}

// MARK: - Toggle
extension Folder {
	public typealias ToogleTreeResult = (change: FolderEditChange, newState: FolderItemState)
	public mutating func toggle(section: Int) throws -> ToogleTreeResult {
		@discardableResult
		func toggle() throws -> ToggleResult {
			// 1. search node
			// 每个section的superSection一定在它的前面
			let secitonInfos = Dictionary(grouping: sections[0..<section], by: { $0.item.id })

			var pathIdentifiers = [sections[section].item.id]
			var element: Element? = sections[section].item.element

			while let id = element?.superIdentifier {
				pathIdentifiers.append(id)
				element = secitonInfos[id]?.first?.item.element
			}

            let result = try toggleNode(for: pathIdentifiers, in: root)
            return result
		}

		let result = try toggle()
        
        guard let newState = result.destinationNode.element?.state else {
            throw FolderError.toggle("destinationNode should be branch")
        }
        
        var expandedSections = sections
        
        root = result.node
        constructTableDataSource()
        
        if newState == .expand {
            expandedSections = sections
        }
        
        let change = caculateChange(
            of: result.destinationNode,
            at: section,
            with: newState,
            expandedSections: expandedSections
        )

        return (change, .expand)
	}
    
    /// 计算节点状态变更后的 tableDateSource Change
    /// - Parameters:
    ///   - node: 状态发生转变的节点
    ///   - section: 节点对用的section index
    ///   - state: 改变后的状态
    /// - Returns: 对应tableView产生的变化
    private func caculateChange(
        of node: Node,
        at section: Int,
        with state: FolderItemState,
        expandedSections: [Section]
    ) -> FolderEditChange {
        let left = constructDataSource(node: node.left, isOnlyExpand: true)
        
        var insertIndexPaths = [IndexPath]()
        var removeIndexPaths = [IndexPath]()
        var insertIndexSet = IndexSet()
        var removeIndexSet = IndexSet()
        
        switch left {
        case .none:
            return .none
        case .rows(let rows):
            switch state {
            case .collapse:
                removeIndexPaths = (0..<rows.count).map { .init(row: $0, section: section) }
            case .expand:
                insertIndexPaths = (0..<rows.count).map { .init(row: $0, section: section) }
            }
        case let .sections(sections, rows):
            let indexSet = IndexSet((1...sections.count).map { $0 + section })
            let indexPathes = (0..<rows.count).map { IndexPath(row: $0, section: section) }
            
            // 不属于该 node 子孙节点 的rows，但是会在该node中最后一个section中展示
            var otherIndexPathes = [IndexPath]()
            if let last = sections.last,
               let expandSection = expandedSections.first(where: { $0.item.id == last.item.id }),
               last.subItems.count < expandSection.subItems.count {
                
                otherIndexPathes = (0..<(expandSection.subItems.count - last.subItems.count))
                    .map { IndexPath(row: $0, section: section) }
            }
            
            switch state {
            case .collapse:
                removeIndexSet = indexSet
                removeIndexPaths = indexPathes
                insertIndexPaths = otherIndexPathes
            case .expand:
                insertIndexSet = indexSet
                insertIndexPaths = indexPathes
                removeIndexPaths = otherIndexPathes
            }
        }
        
        return .init(
            insertIndexPaths: insertIndexPaths,
            removeIndexPaths: removeIndexPaths,
            insertIndexSet: insertIndexSet,
            removeIndexSet: removeIndexSet
        )
    }

	/// node：根据path已执行切换后的node，destinationNode：执行切换状态的节点（切换之前）
	typealias ToggleResult = (node: Node, destinationNode: Node)

	/// 根据数据的 id 的数组对一个node中的某个指定node执行切换
	/// - Parameters:
	///   - ids: 数据的 id 数组，第一个id为最终需要切换状态的节点的id，最后一个id是参数node中的subnodes的某一个节点
	///   - node: path需要在该node中查找需要切换的node
	/// - Returns:
	private func toggleNode(for ids: [Element.ID], in node: Node) throws -> ToggleResult {
		guard let id = ids.last else {
            throw FolderError.toggle("ids should not empty")
		}

		var node = node
		let destinationNode: Node

		if id == node.element?.id {
			if ids.count > 1 {
				var ids = ids
				ids.removeLast()
				let result = try toggleNode(for: ids, in: node.left)
                try node.update(left: result.node)
                destinationNode = result.destinationNode
			} else {
                node = toggle(node: node)
                destinationNode = node
			}
		} else {
			let result = try toggleNode(for: ids, in: node.right)
            try node.update(right: result.node)
			destinationNode = result.destinationNode
		}

		return (node, destinationNode)
	}

	/// 切换节点展开状态
	/// - Parameter node: 节点
	/// - Returns: 切换后的节点
	private func toggle(node: Node) -> Node {
		guard let element = node.element else {
			return node
		}

		var node = node
		node.update(element: Item(element: element.element, depth: element.depth, state: element.state.toggled))
		return node
	}
}

// MARK: - Construct
extension Folder {
    enum NodeDataSource {
		/// 只有rows：右子树单链
        case rows([Item])
		/// 非右子树单链
        case sections([Section], [Item])
		/// 空树
        case none
        
        var rows: [Item] {
            switch self {
            case .rows(let rows):
                return rows
            case .sections(_, let rows):
                return rows
            case .none:
                return []
            }
        }
    }
    
    mutating func constructTableDataSource() {
        self.sections = construct(node: root)
    }
    
    private func construct(node: Node, isOnlyExpand flag: Bool = true) -> [Section] {
        let info = constructDataSource(node: node, isOnlyExpand: flag)
        
        switch info {
        // 空树
        case .none:
            return []
        // 右子树单链
        case .rows(let rows):
            return rows.map { .init(item: $0) }
        case let .sections(sections, rows):
            return rows.map { .init(item: $0) } + sections
        }
    }
    
    private func constructDataSource(node: Node, isOnlyExpand flag: Bool) -> NodeDataSource {
        node.reduce(none: NodeDataSource.none) { left , element, right in
            switch (left, right) {
            // left：none；right：none。 叶子节点
            case (.none, .none):
                return .rows([element])
                
            // left：none；right：right为根的右子树单链
            case (.none, .rows(let rows)):
                return .rows([element] + rows)
                
            // left：left为根的右子树单链；right：none
            case (.rows(let leftRows), .none):
                let rows = (!flag || element.state.isExpand) ? leftRows : []
                return .sections([Section(item: element, subItems: rows)], [])
                
            case let (.rows(leftRows), .rows(rightRows)):
                let rows = (!flag || element.state.isExpand) ? leftRows + rightRows : rightRows
                let section = Section(item: element, subItems: rows)
                return .sections([section], [])
                
            // left：none；right：非右子树单链，递归的某一右子树有左子树
            case let (.none, .sections(sections, rows)):
                return .sections(sections, [element] + rows)
                
            // left: 非右子树单链，递归的某一右子树有左子树; right：none
            case let (.sections(sections, leftRows), .none):
                guard !flag || element.state.isExpand else {
                    return .sections([Section(item: element)], [])
                }
                
                let section = Section(item: element, subItems: leftRows)
                return .sections([section] + sections, [])
                
            // left: 非右子树单链，递归的某一右子树有左子树; right：right为根的右子树单链
            case (.sections(var sections, let leftRows), .rows(let rightRows)):
                guard !flag || element.state.isExpand else {
                    let section = Section(item: element, subItems: rightRows)
                    return .sections([section] , [])
                }
                
                if !sections.isEmpty {
                    var last = sections.removeLast()
                    last.append(subItems: rightRows)
                    sections.append(last)
                }
                
                let section = Section(item: element, subItems: leftRows)
                return .sections([section] + sections, [])
                
            // left：left为根的右子树单链；right: 非右子树单链，递归的某一右子树有左子树
            case let (.rows(leftRows), .sections(sections, rightRows)):
                let rows = (!flag || element.state.isExpand) ? leftRows + rightRows : rightRows
                let section = Section(item: element, subItems: rows)
                return .sections([section] + sections, [])
                
            // left: 非右子树单链，递归的某一右子树有左子树; right: 非右子树单链，递归的某一右子树有左子树
            case (.sections(var leftSections, let leftRows), .sections(let rightSections, let rightRows)):
                guard !flag || element.state.isExpand else {
                    let section = Section(item: element, subItems: rightRows)
                    return .sections([section] + rightSections, [])
                }
                
                if !leftSections.isEmpty {
                    var last = leftSections.removeLast()
                    last.append(subItems: rightRows)
                    leftSections.append(last)
                }
                
                let section = Section(item: element, subItems: leftRows)
                return .sections([section] + leftSections + rightSections, [])
            }
        }
    }
}

extension Folder {
    enum FolderError: Error {
        case toggle(String)
    }
}
