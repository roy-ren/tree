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
		let id: Int
		let element: Int
		let superIdentifier: Int?
		var rank: Int
	}

	struct MockStringElement: FolderElementConstructable {
		let id: String
		let element: String
		let superIdentifier: String?
		var rank: Int
	}

	func test_initial() {
		let elementsOne: [MockElement] = [
			.init(id: 0, element: 1, superIdentifier: nil, rank: 0)
		]

		let folderOne = Folder(elements: elementsOne)

		XCTAssertEqual(
			folderOne.root,
			.node(left: .none, element: .init(element: elementsOne[0]), right: .none)
		)

		let elements1: [MockElement] = [
			.init(id: 0, element: 1, superIdentifier: nil, rank: 0),
			.init(id: 1, element: 2, superIdentifier: 0, rank: 0)
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
			.init(id: 0, element: 1, superIdentifier: nil, rank: 0),
			.init(id: 1, element: 2, superIdentifier: 0, rank: 0),
			.init(id: 2, element: 3, superIdentifier: 0, rank: 1)
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
			.init(id: 0, element: 0, superIdentifier: nil, rank: 0),
			.init(id: 1, element: 1, superIdentifier: 0, rank: 0),
			.init(id: 2, element: 2, superIdentifier: 0, rank: 1),
			.init(id: 3, element: 3, superIdentifier: 1, rank: 0),
			.init(id: 4, element: 4, superIdentifier: 1, rank: 1),
			.init(id: 5, element: 5, superIdentifier: 2, rank: 0),
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
			.init(id: "a", element: "A", superIdentifier: nil, rank: 0), // 0
			.init(id: "d", element: "D", superIdentifier: "a", rank: 0), // 1
			.init(id: "e", element: "E", superIdentifier: "a", rank: 1), // 2
			.init(id: "b", element: "B", superIdentifier: nil, rank: 1), // 3
			.init(id: "f", element: "F", superIdentifier: "b", rank: 0), // 4
			.init(id: "i", element: "I", superIdentifier: "f", rank: 0), // 5
			.init(id: "j", element: "J", superIdentifier: "f", rank: 1), // 6
			.init(id: "c", element: "C", superIdentifier: nil, rank: 2), // 7
			.init(id: "g", element: "G", superIdentifier: "c", rank: 0), // 8
			.init(id: "h", element: "H", superIdentifier: "c", rank: 1), // 9
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
			.init(id: "a", element: "A", superIdentifier: nil, rank: 0), // 0
			.init(id: "b", element: "B", superIdentifier: nil, rank: 1), // 1
			.init(id: "c", element: "C", superIdentifier: nil, rank: 2), // 2
			.init(id: "d", element: "D", superIdentifier: nil, rank: 3), // 3
			.init(id: "e", element: "E", superIdentifier: "b", rank: 0), // 4
			.init(id: "f", element: "F", superIdentifier: "b", rank: 1), // 5
			.init(id: "g", element: "G", superIdentifier: "c", rank: 1), // 6
			.init(id: "h", element: "H", superIdentifier: "c", rank: 0), // 7
			.init(id: "i", element: "I", superIdentifier: "e", rank: 0), // 8
			.init(id: "j", element: "J", superIdentifier: "e", rank: 1), // 9
			.init(id: "k", element: "K", superIdentifier: "h", rank: 0), // 10
			.init(id: "l", element: "L", superIdentifier: "h", rank: 1), // 11
			.init(id: "m", element: "M", superIdentifier: "l", rank: 0), // 12
			.init(id: "n", element: "N", superIdentifier: "l", rank: 1), // 13
			.init(id: "o", element: "O", superIdentifier: "l", rank: 2), // 14
			.init(id: "p", element: "P", superIdentifier: "l", rank: 3), // 15
			//			.init(id: "<#T##Int#>", element: "<#T##Int#>", superIdentifier: "<#T##Int#>", rank: <#T##Int#>)
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
			.init(id: "a", element: "A", superIdentifier: nil, rank: 0), // 0
			.init(id: "b", element: "B", superIdentifier: nil, rank: 1), // 1
			.init(id: "c", element: "C", superIdentifier: nil, rank: 2), // 2
			.init(id: "d", element: "D", superIdentifier: "a", rank: 0), // 3
			.init(id: "e", element: "E", superIdentifier: "a", rank: 1), // 4
			.init(id: "f", element: "F", superIdentifier: "b", rank: 0), // 5
			.init(id: "g", element: "G", superIdentifier: "c", rank: 0), // 6
			.init(id: "h", element: "H", superIdentifier: "c", rank: 1), // 7
			.init(id: "i", element: "I", superIdentifier: "f", rank: 0), // 8
			.init(id: "j", element: "J", superIdentifier: "f", rank: 1), // 9
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
}
