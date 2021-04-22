//
//  BinaryNode.swift
//  
//
//  Created by roy on 2021/4/22.
//

import Foundation

public indirect enum BinaryNode<Element> {
    case none
    case node(left: Self, element: Element, right: Self)
    
    init() {
        self = .none
    }
    
    init(element: Element) {
        self = .node(left: .none, element: element, right: .none)
    }
}

public extension BinaryNode {
    var isEmpty: Bool {
        switch self {
        case .none:
            return true
        default:
            return false
        }
    }
    
    var data: Element? {
        guard case .node(_, let data, _) = self else {
            return nil
        }
        
        return data
    }
    
    var left: Self {
        guard case .node(let left, _, _) = self else {
            return .none
        }
        
        return left
    }
    
    var right: Self {
        guard case .node(_, _, let right) = self else {
            return .none
        }
        
        return right
    }
}

public extension BinaryNode {
    func reduce<T>(none: T, branch node: (T, Element, T) -> T) -> T {
        switch self {
        case .none:
            return none
        case let .node(left, element, right):
            return node(
                left.reduce(none: none, branch: node),
                element,
                right.reduce(none: none, branch: node)
            )
        }
    }
}

public extension BinaryNode {
    var count: Int {
        reduce(none: 0, branch: { $0 + 1 + $2 })
    }
    
    var elements: [Element] {
        reduce(none: [], branch: { $0 + [$1] + $2 })
    }
}

public enum BinaryNodeError: Error, CustomStringConvertible {
    case invalidUpdate(String)
    
    public var description: String {
        switch self {
        case .invalidUpdate(let des):
            return des
        }
    }
}

public extension BinaryNode {
    mutating func update(element: Element) {
        self = .node(left: left, element: element, right: right)
    }
    
    mutating func update(left node: Self) throws {
        guard let element = data else {
            throw BinaryNodeError.invalidUpdate("none has no left")
        }
        
        self = .node(left: node, element: element, right: right)
    }
    
    mutating func update(right node: Self) throws {
        guard let element = data else {
            throw BinaryNodeError.invalidUpdate("none has no right")
        }
        
        self = .node(left: left, element: element, right: node)
    }
    
    mutating func clearn() {
        self = .none
    }
    
    mutating func removeLeft() throws {
        try update(left: .none)
    }
    
    mutating func removeRight() throws {
        try update(right: .none)
    }
}

extension BinaryNode: Equatable where Element: Equatable {}
