//
//  BinaryNodeTests.swift
//  
//
//  Created by roy on 2021/4/22.
//

import XCTest
@testable import Tree

final class BinaryNodeTests: XCTestCase {
    
    func test_binaryNode_initial() {
        XCTAssertEqual(.none, BinaryNode<Int>())
        XCTAssertEqual(.node(left: .none, element: 2, right: .none), BinaryNode<Int>(element: 2))
    }
    
    func test_binaryNode_properties() {
        XCTAssertTrue(BinaryNode<Int>().isEmpty)
        XCTAssertFalse(BinaryNode(element: 2).isEmpty)
        
        XCTAssertEqual(BinaryNode<String>(element: "Hello").data, "Hello")
        XCTAssertEqual(.none, BinaryNode<Int>().left)
        XCTAssertEqual(.none, BinaryNode(element: 0).left)
        XCTAssertEqual(.none, BinaryNode<Int>().right)
        XCTAssertEqual(.none, BinaryNode(element: 0).right)
        
        XCTAssertEqual(0, BinaryNode<Int>().count)
        XCTAssertEqual(1, BinaryNode(element: 0).count)
        
        let one = BinaryNode(element: 1)
        let two = BinaryNode(element: 2)
        
        let tree1 = BinaryNode.node(left: one, element: 3, right: two)
        let tree11 = BinaryNode.node(left: one, element: 3, right: two)
        let tree2 = BinaryNode.node(left: two, element: 3, right: one)
        
        XCTAssertEqual(tree1, tree11)
        XCTAssertNotEqual(tree1, tree2)
        XCTAssertEqual(tree2.elements, [2, 3, 1])
        XCTAssertEqual(tree1.left.elements, [1])
    }
    
    func test_binaryNode_update() {
        var first = BinaryNode(element: 10)
        first.update(element: 100)
        let second = BinaryNode(element: 100)
        XCTAssertEqual(first, second)
        
        let left = BinaryNode(element: 99)
        try! first.update(left: left)
        XCTAssertEqual(first, .node(left: left, element: 100, right: .none))
        
        let right = BinaryNode(element: 98)
        try! first.update(right: right)
        XCTAssertEqual(first, .node(left: left, element: 100, right: right))
        
        try! first.removeRight()
        XCTAssertEqual(first, .node(left: left, element: 100, right: .none))
        
        try! first.removeLeft()
        XCTAssertEqual(first, second)
        
        first.clearn()
        XCTAssertEqual(.none, first)
        
        XCTAssertThrowsError(try first.update(left: left))
        XCTAssertThrowsError(try first.update(right: right))
    }
}
