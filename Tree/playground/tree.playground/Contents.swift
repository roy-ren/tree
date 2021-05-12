import UIKit
import Tree

let one = BinaryNode(element: 1)
let two = BinaryNode(element: 2)

//print(one.treeDescription())

let tree1 = BinaryNode.node(left: one, element: 101, right: two)
let tree2 = BinaryNode.node(left: two, element: 102, right: one)


let tree3 = BinaryNode.node(left: tree1, element: 103, right: tree2)
let tree4 = BinaryNode.node(left: tree1, element: 104, right: tree3)
let tree5 = BinaryNode.node(left: tree1, element: 105, right: tree4)

print(tree3.treeDescription())
print(tree4.treeDescription())

struct item: FolderElementConstructable {
    var id: Int
    var parentIdentifier: Int?
    var rank: Int
    var element: Int
}
