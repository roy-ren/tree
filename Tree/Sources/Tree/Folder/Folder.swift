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

extension Folder {
    func item(forRowAt indexPath: IndexPath) -> Item {
        sections[indexPath.section].subItems[indexPath.row]
    }
    
    func item(for section: Int) -> Item {
        sections[section].item
    }
    
    enum InfoType {
        case rows([Item])
        case sections([Section], [Item])
        case none
    }
    
    mutating func constructTableDataSource() {
        func construct(node: Node) -> [Section] {
			let info = node.reduce(none: InfoType.none) { left , element, right in
				switch (left, right) {
				// left：none；right：none。 叶子节点
				case (.none, .none):
					return .rows([element])

				// left：none；right：right为根的右子树单链
				case (.none, .rows(let rows)):
					return .rows([element] + rows)

				// left：left为根的右子树单链；right：none
				case (.rows(let rows), .none):
					return .sections([Section(item: element, subItems: rows)], [])


				case let (.rows(leftRows), .rows(rightRows)):
					return .sections([Section(item: element, subItems: leftRows + rightRows)], [])

				// left：none；right：非右子树单链，递归的某一右子树有左子树
				case let (.none, .sections(sections, rows)):
					return .sections(sections, [element] + rows)

				// left: 非右子树单链，递归的某一右子树有左子树; right：none
				case let (.sections(sections, rows), .none):
					let section = Section(item: element, subItems: rows)
					return .sections([section] + sections, [])

				// left: 非右子树单链，递归的某一右子树有左子树; right：right为根的右子树单链
				case (.sections(var sections, let leftRows), .rows(let rightRows)):
					if !sections.isEmpty {
						var last = sections.removeLast()
						last.append(subItems: rightRows)
						sections.append(last)
					}

					let section = Section(item: element, subItems: leftRows)
					return .sections([section] + sections, [])

				// left：left为根的右子树单链；right: 非右子树单链，递归的某一右子树有左子树
				case let (.rows(leftRows), .sections(sections, rightRows)):
					let section = Section(item: element, subItems: leftRows + rightRows)
					return .sections([section] + sections, [])

				// left: 非右子树单链，递归的某一右子树有左子树; right: 非右子树单链，递归的某一右子树有左子树
				case (.sections(var leftSections, let leftRows), .sections(let rightSections, let rightRows)):
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
