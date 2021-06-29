//
//  FolderTests.swift
//
//
//  Created by roy on 2021/4/22.
//

import XCTest
@testable import Tree

final class FolderTests: XCTestCase {
	struct MockElement: FolderElementConstructable {
		static var invisableRootIdentifier: Int = -1

		let id: Int
		let element: Int
		let parentIdentifier: Int
		var rank: Int
	}

	struct MockStringElement: FolderElementConstructable {
		static var invisableRootIdentifier: String = "root"

		let id: String
		let element: String
		let parentIdentifier: String
		var rank: Int
	}

	func test_initial() {
		let elementsOne: [MockElement] = [
			.init(id: 0, element: 1, parentIdentifier: -1, rank: 0)
		]

		let folderOne = Folder(elements: elementsOne)

		XCTAssertEqual(
			folderOne.root,
			.node(left: .none, element: .init(element: elementsOne[0]), right: .none)
		)

		let elements1: [MockElement] = [
			.init(id: 0, element: 1, parentIdentifier: -1, rank: 0),
			.init(id: 1, element: 2, parentIdentifier: 0, rank: 0)
		]

		let folder1 = Folder(elements: elements1)

		XCTAssertEqual(
			folder1.root,
			.node(
				left: .node(
					left: .none,
					element: .init(element: elements1[1], depth: 1),
					right: .none
				),
				element: .init(element: elements1[0], depth: 0),
				right: .none
			)
		)

		let elements2: [MockElement] = [
			.init(id: 0, element: 1, parentIdentifier: -1, rank: 0),
			.init(id: 1, element: 2, parentIdentifier: 0, rank: 0),
			.init(id: 2, element: 3, parentIdentifier: 0, rank: 1)
		]

		let folder2 = Folder(elements: elements2)

		XCTAssertEqual(
			folder2.root,
			.node(
				left: .node(
					left: .none,
					element: .init(element: elements2[1], depth: 1),
					right: .node(
						left: .none,
						element: .init(element: elements2[2], depth: 1),
						right: .none
					)
				),
				element: .init(element: elements2[0], depth: 0),
				right: .none
			)
		)

		let elements: [MockElement] = [
			.init(id: 0, element: 0, parentIdentifier: -1, rank: 0),
			.init(id: 1, element: 1, parentIdentifier: 0, rank: 0),
			.init(id: 2, element: 2, parentIdentifier: 0, rank: 1),
			.init(id: 3, element: 3, parentIdentifier: 1, rank: 0),
			.init(id: 4, element: 4, parentIdentifier: 1, rank: 1),
			.init(id: 5, element: 5, parentIdentifier: 2, rank: 0),
		]

		let folder = Folder(elements: elements)

		XCTAssertEqual(
			folder.root,
			.node(
				left: .node(
					left: .node(
						left: .none,
						element: .init(element: elements[3], depth: 2),
						right: .node(
							left: .none,
							element: .init(element: elements[4], depth: 2),
							right: .none
						)
					),
					element: .init(element: elements[1], depth: 1),
					right: .node(
						left: .node(
							left: .none,
							element: .init(element: elements[5], depth: 2),
							right: .none
						),
						element: .init(element: elements[2], depth: 1),
						right: .none
					)
				),
				element: .init(element: elements[0], depth: 0),
				right: .none
			)
		)
	}

	func test_initial_string() {
		let stringElements: [MockStringElement] = [
			.init(id: "a", element: "A", parentIdentifier: "root", rank: 0), // 0
			.init(id: "d", element: "D", parentIdentifier: "a", rank: 0), // 1
			.init(id: "e", element: "E", parentIdentifier: "a", rank: 1), // 2
			.init(id: "b", element: "B", parentIdentifier: "root", rank: 1), // 3
			.init(id: "f", element: "F", parentIdentifier: "b", rank: 0), // 4
			.init(id: "i", element: "I", parentIdentifier: "f", rank: 0), // 5
			.init(id: "j", element: "J", parentIdentifier: "f", rank: 1), // 6
			.init(id: "c", element: "C", parentIdentifier: "root", rank: 2), // 7
			.init(id: "g", element: "G", parentIdentifier: "c", rank: 0), // 8
			.init(id: "h", element: "H", parentIdentifier: "c", rank: 1), // 9
		]

		let stringFolder = Folder(elements: stringElements)
		XCTAssertEqual(
			stringFolder.root,
			.node(
				left: .node(
					left: .none,
					element: .init(element: stringElements[1], depth: 1), // d
					right: .node(
						left: .none,
						element: .init(element: stringElements[2], depth: 1), // e
						right: .none
					)
				),
				element: .init(element: stringElements[0], depth: 0), // a
				right: .node(
					left: .node(
						left: .node(
							left: .none,
							element: .init(element: stringElements[5], depth: 2), // i
							right: .node(
								left: .none,
								element: .init(element: stringElements[6], depth: 2), // j
								right: .none
							)
						),
						element: .init(element: stringElements[4], depth: 1), // f
						right: .none
					),
					element: .init(element: stringElements[3], depth: 0), // b
					right: .node(
						left: .node(
							left: .none,
							element: .init(element: stringElements[8], depth: 1), // g
							right: .node(
								left: .none,
								element: .init(element: stringElements[9], depth: 1), // h
								right: .none
							)
						),
						element: .init(element: stringElements[7], depth: 0), // c
						right: .none
					)
				)
			)
		)
	}

	func test_initial_string2() {
		let elements: [MockStringElement] = [
			.init(id: "a", element: "A", parentIdentifier: "root", rank: 0), // 0
			.init(id: "b", element: "B", parentIdentifier: "root", rank: 1), // 1
			.init(id: "c", element: "C", parentIdentifier: "root", rank: 2), // 2
			.init(id: "d", element: "D", parentIdentifier: "root", rank: 3), // 3
			.init(id: "e", element: "E", parentIdentifier: "b", rank: 0), // 4
			.init(id: "f", element: "F", parentIdentifier: "b", rank: 1), // 5
			.init(id: "g", element: "G", parentIdentifier: "c", rank: 1), // 6
			.init(id: "h", element: "H", parentIdentifier: "c", rank: 0), // 7
			.init(id: "i", element: "I", parentIdentifier: "e", rank: 0), // 8
			.init(id: "j", element: "J", parentIdentifier: "e", rank: 1), // 9
			.init(id: "k", element: "K", parentIdentifier: "h", rank: 0), // 10
			.init(id: "l", element: "L", parentIdentifier: "h", rank: 1), // 11
			.init(id: "m", element: "M", parentIdentifier: "l", rank: 0), // 12
			.init(id: "n", element: "N", parentIdentifier: "l", rank: 1), // 13
			.init(id: "o", element: "O", parentIdentifier: "l", rank: 2), // 14
			.init(id: "p", element: "P", parentIdentifier: "l", rank: 3), // 15
			//			.init(id: "<#T##Int#>", element: "<#T##Int#>", parentIdentifier: "<#T##Int#>", rank: <#T##Int#>)
		]

		let infos = Dictionary(grouping: elements, by: { $0.id })

		typealias StringFolder = Folder<MockStringElement>
		let folder = StringFolder(elements: elements)

		typealias Section = StringFolder.Section

		XCTAssertEqual(
			folder.root,
			.node(
				left: .none,
				element: .init(element: infos["a"]!.first!, depth: 0), // a
				right: .node(
					left: .node(
						left: .node(
							left: .none,
							element: .init(element: infos["i"]!.first!, depth: 2), // i
							right: .node(
								left: .none,
								element: .init(element: infos["j"]!.first!, depth: 2), // j
								right: .none
							)
						),
						element: .init(element: infos["e"]!.first!, depth: 1), // e
						right: .node(
							left: .none,
							element: .init(element: infos["f"]!.first!, depth: 1), // f
							right: .none
						)
					),
					element: .init(element: infos["b"]!.first!, depth: 0), // b
					right: .node(
						left: .node(
							left: .node(
								left: .none,
								element: .init(element: infos["k"]!.first!, depth: 2), // k
								right: .node(
									left: .node(
										left: .none,
										element: .init(element: infos["m"]!.first!, depth: 3), // m
										right: .node(
											left: .none,
											element: .init(element: infos["n"]!.first!, depth: 3), // n
											right: .node(
												left: .none,
												element: .init(element: infos["o"]!.first!, depth: 3), // o
												right: .node(
													left: .none,
													element: .init(element: infos["p"]!.first!, depth: 3), // p
													right: .none
												)
											)
										)
									),
									element: .init(element: infos["l"]!.first!, depth: 2), // l
									right: .none
								)
							),
							element: .init(element: infos["h"]!.first!, depth: 1), // h
							right: .node(
								left: .none,
								element: .init(element: infos["g"]!.first!, depth: 1), // g
								right: .none
							)
						),
						element: .init(element: infos["c"]!.first!, depth: 0), // c
						right: .node(
							left: .none,
							element: .init(element: infos["d"]!.first!, depth: 0), // d
							right: .none
						)
					)
				)
			)
		)

		let items = folder.root
			.elements
			.sorted {
				$0.element.id < $1.element.id
			}

		let sections = [
			Section(item: items[0]),
			Section(item: items[1]),
			Section(item: items[4], subItems: [items[8], items[9], items[5]]),
			Section(item: items[2]),
			Section(item: items[7], subItems: [items[10]]),
			Section(item: items[11], subItems: [items[12], items[13], items[14], items[15], items[6], items[3]]),
		]

		XCTAssertEqual(folder.sections, sections)
	}

	func test_construct_section() {
		let stringElements: [MockStringElement] = [
			.init(id: "a", element: "A", parentIdentifier: "root", rank: 0), // 0
			.init(id: "b", element: "B", parentIdentifier: "root", rank: 1), // 1
			.init(id: "c", element: "C", parentIdentifier: "root", rank: 2), // 2
			.init(id: "d", element: "D", parentIdentifier: "a", rank: 0), // 3
			.init(id: "e", element: "E", parentIdentifier: "a", rank: 1), // 4
			.init(id: "f", element: "F", parentIdentifier: "b", rank: 0), // 5
			.init(id: "g", element: "G", parentIdentifier: "c", rank: 0), // 6
			.init(id: "h", element: "H", parentIdentifier: "c", rank: 1), // 7
			.init(id: "i", element: "I", parentIdentifier: "f", rank: 0), // 8
			.init(id: "j", element: "J", parentIdentifier: "f", rank: 1), // 9
		]

		typealias StringFolder = Folder<MockStringElement>
		let folder = StringFolder(elements: stringElements)

		typealias Section = StringFolder.Section

		let items = folder.root
			.elements
			.sorted {
				$0.element.element < $1.element.element
			}

		let sections = [
			Section(item: items[0], subItems: [items[3], items[4]]),
			Section(item: items[1]),
			Section(item: items[5], subItems: [items[8], items[9]]),
			Section(item: items[2], subItems: [items[6], items[7]]),
		]

		XCTAssertEqual(folder.sections, sections)
	}

	func test_toggle_section() {
        let stringElements: [MockStringElement] = [
            .init(id: "a", element: "A", parentIdentifier: "root", rank: 0), // 0
            .init(id: "b", element: "B", parentIdentifier: "root", rank: 1), // 1
            .init(id: "c", element: "C", parentIdentifier: "root", rank: 2), // 2
            .init(id: "d", element: "D", parentIdentifier: "root", rank: 3), // 3
            .init(id: "e", element: "E", parentIdentifier: "a", rank: 0), // 4
            .init(id: "f", element: "F", parentIdentifier: "a", rank: 1), // 5
            .init(id: "g", element: "G", parentIdentifier: "c", rank: 0), // 6
            .init(id: "h", element: "H", parentIdentifier: "g", rank: 0), // 7
            .init(id: "i", element: "I", parentIdentifier: "g", rank: 1), // 8
            .init(id: "j", element: "J", parentIdentifier: "h", rank: 0), // 9
        ]
        
		typealias StringFolder = Folder<MockStringElement>
		var folder = StringFolder(elements: stringElements)

		typealias Section = StringFolder.Section

		let elements = folder.root
			.elements
			.sorted {
				$0.element.element < $1.element.element
			}

        let infos = Dictionary(grouping: elements, by: { $0.id })
        
        func item(_ id: String) -> FolderItem<MockStringElement> {
            infos[id]!.first!
        }
        
        func items(_ ids: [String]) -> [FolderItem<MockStringElement>] {
            ids.map(item(_:))
        }
        
		let sections = [
			Section(item: item("a"), subItems: items(["e", "f", "b"])),
			Section(item: item("c")),
            Section(item: item("g")),
			Section(item: item("h"), subItems: items(["j", "i", "d"])),
		]

        // construct
		XCTAssertEqual(folder.sections, sections)

        // 1. collapse A
        let collapseResult_a = try! folder.toggle(section: 0)
        
        var folderItem_a = item("a")
        folderItem_a.state = .collapse
        
        let sections_collapse_a = [
            Section(item: folderItem_a, subItems: items(["b"])),
            Section(item: item("c")),
            Section(item: item("g")),
            Section(item: item("h"), subItems: items(["j", "i", "d"])),
        ]
        
        XCTAssertEqual(folder.sections, sections_collapse_a)

        XCTAssertEqual(
            FolderEditChange(
                removeIndexPaths: [.init(row: 0, section: 0), .init(row: 1, section: 0)]
            ),
            collapseResult_a.change
        )
        
        // 2. collapse G
        let collapseResult_a_g = try! folder.toggle(section: 2)
        
        var folderItem_g = item("g")
        folderItem_g.state = .collapse
        
        let sections_collapse_a_g = [
            Section(item: folderItem_a, subItems: items(["b"])),
            Section(item: item("c")),
            Section(item: folderItem_g, subItems: items(["d"])),
        ]
        
        XCTAssertEqual(folder.sections, sections_collapse_a_g)
        XCTAssertEqual(
            FolderEditChange(
                insertIndexPaths: [.init(row: 0, section: 2)],
                removeIndexSet: [3]
            ),
            collapseResult_a_g.change
        )
        
        // 3. expand G
        let expandResult_a_g = try! folder.toggle(section: 2)
        folderItem_g.state = .expand
        
        let sections_expand_g = [
            Section(item: folderItem_a, subItems: items(["b"])),
            Section(item: item("c")),
            Section(item: folderItem_g),
            Section(item: item("h"), subItems: items(["j", "i", "d"])),
        ]
        XCTAssertEqual(folder.sections, sections_expand_g)
        
        XCTAssertEqual(
            FolderEditChange(
                removeIndexPaths: [.init(row: 0, section: 2)],
                insertIndexSet: [3]
            ),
            expandResult_a_g.change
        )
        
        // 4. collapse H
        let collapseResult_h = try! folder.toggle(section: 3)
        
        var folderItem_h = item("h")
        folderItem_h.state = .collapse
        
        let sections_collapse_h = [
            Section(item: folderItem_a, subItems: items(["b"])),
            Section(item: item("c")),
            Section(item: folderItem_g),
            Section(item: folderItem_h, subItems: items(["i", "d"])),
        ]
        
        XCTAssertEqual(folder.sections, sections_collapse_h)
        XCTAssertEqual(
            FolderEditChange(
                removeIndexPaths: [.init(row: 0, section: 3)]
            ),
            collapseResult_h.change
        )
        
        // 5. collapse C
        let collapseResult_c = try! folder.toggle(section: 1)
        
        var folderItem_c = item("c")
        folderItem_c.state = .collapse
        
        let sections_collapse_c = [
            Section(item: folderItem_a, subItems: items(["b"])),
            Section(item: folderItem_c, subItems: items(["d"])),
        ]
        
        XCTAssertEqual(folder.sections, sections_collapse_c)
        XCTAssertEqual(
            FolderEditChange(
                insertIndexPaths: [.init(row: 0, section: 1)],
                removeIndexSet: [2, 3]
            ),
            collapseResult_c.change
        )
	}
}
