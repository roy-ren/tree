//
//  FolderListView.swift
//
//
//  Created by roy on 2021/4/23.
//

import UIKit

public enum FolderElement<Element: FolderElementConstructable> {
    case normal(FolderItem<Element>)
    case folder(FolderItem<Element>)
    
    public var element: Element {
        switch self {
        case .normal(let item):
            return item.element
        case .folder(let item):
            return item.element
        }
    }
}

public protocol FolderListViewDelegate: AnyObject {
    associatedtype Cell: FolderListCellViewType
    typealias Element = Cell.Element
    
    var elements: [Element] { get }
    var itemHeight: CGFloat { get }
    
    func folderListView(didSelected element: FolderElement<Element>, of cell: Cell)
}

public final class FolderListView<Delegate: FolderListViewDelegate>: UIView, UITableViewDataSource, UITableViewDelegate {

    public typealias Element = Delegate.Element
    public weak var delegate: Delegate?

    private var dataSource: Folder<Element>
    private let table = UITableView()

    private typealias Cell = FolderListCell<Delegate.Cell>
    private typealias Header = FolderListHeader<Delegate.Cell>

    public override init(frame: CGRect) {
        dataSource = .init()
        super.init(frame: frame)
    }

    public init(elements: [Element]) {
        dataSource = .init(elements: elements)
        super.init(frame: .zero)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func constructTableViewAndConstraint() {
        table.addedAsContent(toSuper: self)
        table.dataSource = self
        table.delegate = self

        table.register(cell: Cell.self)
        table.register(headerFooter: Header.self)
    }

    // MARK: - UITableViewDataSource
    public func numberOfSections(in tableView: UITableView) -> Int {
        dataSource.constructTableDataSource()
        return dataSource.sections.count
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dataSource.sections[section].numberOfRows
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: Cell = table.dequeueReusableCell(forRowAt: indexPath)

		let item = dataSource.item(forRowAt: indexPath)

        cell.config(.normal(item))

        return cell
    }

    // MARK: - UITableViewDelegate
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header: Header = tableView.dequeueReusableHeaderFooter()

        let item = FolderElement.folder(dataSource.item(for: section))
        
        header.config(item)
        
        header.tappedClosure = { [weak self] cell in
            guard let self = self else { return }

            self.toggle(section: section) { [weak self] _ in
                guard let self = self else { return }
                self.triger(didSelected: item, of: cell)
            }
        }

        return header
    }
}

extension FolderListView {
    private func triger(didSelected item: FolderElement<Element>, of cell: Delegate.Cell) {
        delegate?.folderListView(didSelected: item, of: cell)
    }

    private func toggle(section: Int, completion: @escaping (FolderItemState) -> Void) {
        func update(_ editChange: FolderEditChange, completion: @escaping () -> Void) {
            table.isUserInteractionEnabled = false
            
            table.performBatchUpdates {
                if !editChange.removeIndexPaths.isEmpty {
                    table.deleteRows(at: editChange.removeIndexPaths, with: .fade)
                }
                
                if !editChange.removeIndexSet.isEmpty {
                    table.deleteSections(editChange.removeIndexSet, with: .fade)
                }
                
                if !editChange.insertIndexPaths.isEmpty {
                    table.insertRows(at: editChange.insertIndexPaths, with: .fade)
                }
                
                if !editChange.insertIndexSet.isEmpty {
                    table.insertSections(editChange.insertIndexSet, with: .fade)
                }
                
            } completion: { isFinished in
                if isFinished {
                    self.table.reloadData()
                    self.table.isUserInteractionEnabled = true
                    completion()
                }
            }
        }
        
        do {
            let result = try dataSource.toggle(section: section)
            
            if .none == result.change {
                completion(result.newState)
            } else {
                update(result.change) {
                    completion(result.newState)
                }
            }
            
        } catch let error {
            print(error.localizedDescription)
        }
    }
}
