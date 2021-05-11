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
}
