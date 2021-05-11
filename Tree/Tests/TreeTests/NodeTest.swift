//
//  NodeTest.swift
//  
//
//  Created by roy on 2021/5/11.
//

import XCTest
@testable import Tree

final class NodeTest: XCTestCase {
    func test_intial() {
        typealias IntNode = Node<Int>
        let aNode = IntNode.branch(
            super: .none,
            firstChild: .none,
            element: 0,
            next: .none
        )
        
        let bNode = IntNode.branch(
            super: .none,
            firstChild: .none,
            element: 0,
            next: .none
        )
    }
}
