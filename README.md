# Tree

![badge-languages](https://img.shields.io/badge/languages-Swift-orange.svg)
[![Swift Package Manager compatible](https://img.shields.io/badge/Swift%20Package%20Manager-compatible-brightgreen.svg)](https://github.com/apple/swift-package-manager)

![](https://github.com/royit/tree/blob/main/filename.gif)

# How to use


```swift
class FolderListViewController: UIViewController {
    private let folderView = FolderListView<FolderListViewController>()
    // ...
}

struct Element: FolderElementConstructable {
    let id: Int
    let element: Int
    let parentIdentifier: Int
    let rank: Int
    
    static let invisableRootIdentifier = -1
}

extension FolderListViewController: FolderListViewDelegate {
    var elements: [Element] {
        [
            .init(id: 0, element: 0, parentIdentifier: -1, rank: 0),
            .init(id: 1, element: 1, parentIdentifier: 0, rank: 0),
            .init(id: 11, element: 11, parentIdentifier: 1, rank: 0),
            // ...
		]
    }
    
    func folderListView(didSelected element: FolderElement<Element>, of cell: Cell) {
        switch element {
        case .normal:
            // ...
        case .folder:
            // ...
        }
    }
    
    var itemHeight: CGFloat { 60 }
}

class Cell: UIView, FolderListCellViewType {
	// ....
}

```


# Requirements

Xcode >= 12.0 or Swift >= 5.3.


# Quick Start

In your `Package.swift`:

```swift
package.dependencies.append(
    .package(url: "https://github.com/royit/tree.git", from: "0.1.0")
)
```


## License
Moya is released under an MIT license. See [License.md](https://github.com/royit/tree/blob/main/License.md) for more information.