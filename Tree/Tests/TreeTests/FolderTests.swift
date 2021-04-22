//
//  FolderTests.swift
//  
//
//  Created by roy on 2021/4/22.
//

import XCTest
@testable import Tree

final class FolderTests: XCTestCase {
	struct MockElement: FolderElementProtocol {
		let id: Int
		let element: Int
//		let level: Int
		let superIdentifier: Int?
		let rank: Int
		var state: FolderState = .expand
	}

	func test_initial() {
		let elementsOne: [MockElement] = [
			.init(id: 0, element: 1, superIdentifier: nil, rank: 0)
		]

		let folderOne = Folder(elements: elementsOne)

		XCTAssertEqual(
			folderOne.root,
			.node(left: .none, element: elementsOne[0], right: .none)
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
					element: elements1[1],
					right: .none
				),
				element: elements1[0],
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
					element: elements2[1],
					right: .node(
						left: .none,
						element: elements2[2],
						right: .none
					)
				),
				element: elements2[0],
				right: .none
			)
		)

		let elements: [MockElement] = [
			.init(id: 0, element: 1, superIdentifier: nil, rank: 0),
			.init(id: 1, element: 2, superIdentifier: 0, rank: 0),
			.init(id: 2, element: 3, superIdentifier: 0, rank: 1),
			.init(id: 3, element: 4, superIdentifier: 1, rank: 0),
			.init(id: 4, element: 5, superIdentifier: 1, rank: 1),
			.init(id: 5, element: 6, superIdentifier: 2, rank: 0),
		]

		let folder = Folder(elements: elements)

		XCTAssertEqual(
			folder.root,
			.node(
				left: .node(
					left: .node(
						left: .none,
						element: elements[3],
						right: .node(
							left: .none,
							element: elements[4],
							right: .none
						)
					),
					element: elements[1],
					right: .node(
						left: .node(
							left: .none,
							element: elements[5],
							right: .none
						),
						element: elements[2],
						right: .none
					)
				),
				element: elements[0],
				right: .none
			)
		)
	}
}
