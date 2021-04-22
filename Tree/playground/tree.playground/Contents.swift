import UIKit
import Tree

var str = "Hello, playground"

print(Tree().text)

indirect enum BinarySearchTree<Element: Comparable> {
    case leaf
    case node(BinarySearchTree<Element>,
              Element,
              BinarySearchTree<Element>)
}

extension BinarySearchTree {
    func reduce<A>(leaf leafF: A, node nodeF: (A, Element, A) -> A) -> A {
        switch self {
        case .leaf:
            return leafF
        case let .node(left, x, right):
            return nodeF(
                left.reduce(leaf: leafF, node: nodeF),
                x,
                right.reduce(leaf: leafF, node: nodeF)
            )
        }
    }
}

extension BinarySearchTree {
    var elementsR: [Element] {
        return reduce(leaf: []) { $0 + [$1] + $2 }
    }
    var countR: Int {
        return reduce(leaf: 0) { 1 + $0 + $2 }
    }
}
