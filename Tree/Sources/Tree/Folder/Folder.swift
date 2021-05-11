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

public struct EditChange: Equatable {
	static let none = EditChange(
		insertIndexPaths: [],
		removeIndexPaths: [],
		insertIndexSet: .init(),
		removeIndexSet: .init()
	)

	let insertIndexPaths: [IndexPath]
	let removeIndexPaths: [IndexPath]
	let insertIndexSet: IndexSet
	let removeIndexSet: IndexSet
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
	public typealias ToogleTreeResult = (change: EditChange, newState: FolderItemState)
	public mutating func toggle(
		section: Int
//		completion: @escaping (ToogleTreeResult) -> Void
	) {
		@discardableResult
		func toggle() -> ToggleResult {
			// 1. search node
			// 每个section的superSection一定在它的前面
			let secitonInfos = Dictionary(grouping: sections[0..<section], by: { $0.item.id })

			var pathIdentifiers = [sections[section].item.id]
			var element: Element? = sections[section].item.element

			while let id = element?.superIdentifier {
				pathIdentifiers.append(id)
				element = secitonInfos[id]?.first?.item.element
			}

			do {
				let result = try toggleNode(for: pathIdentifiers, in: root)
				return result
			} catch {
				fatalError("Shit")
			}
		}

		toggle()

		constructTableDataSource()

//		completion((.none, .collapse))
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
			fatalError("Path should not empty")
		}

		var node = node
		let destinationNode: Node

		if id == node.element?.id {
			if ids.count > 1 {
				var ids = ids
				ids.removeLast()
				let result = try toggleNode(for: ids, in: node.left)
				destinationNode = result.destinationNode
				try node.update(left: result.node)
			} else {
				destinationNode = toggle(node: node)
				node = destinationNode
			}
		} else {
			let result = try toggleNode(for: ids, in: node.right)
			destinationNode = result.destinationNode
			try node.update(right: result.node)
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
    }
    
    mutating func constructTableDataSource() {
		func construct(node: Node, isOnlyExpand flag: Bool = true) -> [Section] {
			let info = node.reduce(none: NodeDataSource.none) { left , element, right in
				switch (left, right) {
				// left：none；right：none。 叶子节点
				case (.none, .none):
					return .rows([element])

				// left：none；right：right为根的右子树单链
				case (.none, .rows(let rows)):
					return .rows([element] + rows)

				// left：left为根的右子树单链；right：none
				case (.rows(let rows), .none):
					// state is collapse => left = none
					guard !flag || element.state.isExpand else {
						return .rows([element])
					}

					return .sections([Section(item: element, subItems: rows)], [])

				case let (.rows(leftRows), .rows(rightRows)):
					// state is collapse => left = none
					guard !flag || element.state.isExpand else {
						return .rows([element] + rightRows)
					}

					return .sections([Section(item: element, subItems: leftRows + rightRows)], [])

				// left：none；right：非右子树单链，递归的某一右子树有左子树
				case let (.none, .sections(sections, rows)):
					return .sections(sections, [element] + rows)

				// left: 非右子树单链，递归的某一右子树有左子树; right：none
				case let (.sections(sections, rows), .none):
					// state is collapse => left = none
					guard !flag || element.state.isExpand else {
						return .rows([element])
					}

					let section = Section(item: element, subItems: rows)
					return .sections([section] + sections, [])

				// left: 非右子树单链，递归的某一右子树有左子树; right：right为根的右子树单链
				case (.sections(var sections, let leftRows), .rows(let rightRows)):
					// state is collapse => left = none
					guard !flag || element.state.isExpand else {
						return .rows([element] + rightRows)
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
					// state is collapse => left = none
					guard !flag || element.state.isExpand else {
						return .sections(sections, [element] + rightRows)
					}

					let section = Section(item: element, subItems: leftRows + rightRows)
					return .sections([section] + sections, [])

				// left: 非右子树单链，递归的某一右子树有左子树; right: 非右子树单链，递归的某一右子树有左子树
				case (.sections(var leftSections, let leftRows), .sections(let rightSections, let rightRows)):
					// state is collapse => left = none
					guard !flag || element.state.isExpand else {
						return .sections(sections, [element] + rightRows)
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
        
		self.sections = construct(node: root)
    }
}
