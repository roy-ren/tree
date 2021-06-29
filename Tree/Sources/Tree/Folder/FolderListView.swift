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
    
    public var item: FolderItem<Element> {
        switch self {
        case .normal(let item):
            return item
        case .folder(let item):
            return item
        }
    }
    
    public var element: Element {
        item.element
    }
    
    /// 层级深度（与树的深度不同）, 根节点的深度为 0
    public var depth: Int {
        item.depth
    }
    
    /// 展开状态
    public var state: FolderItemState {
        item.state
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
    public var enabledFold: Bool = true

    private var dataSource = Folder<Element>()
    private let tableView = UITableView(frame: .zero, style: .grouped)

    private var didContructedSubView = false
    
    private typealias Cell = FolderListCell<Delegate.Cell>
    private typealias Header = FolderListHeader<Delegate.Cell>

    private var _isNotInToggle = true
    private let fetchToggleStateQeuue = DispatchQueue(label: "com.tree.FolderListView.toggle")
    private var isNotInToggle: Bool {
        get { fetchToggleStateQeuue.sync { _isNotInToggle } }
        set { fetchToggleStateQeuue.async { self._isNotInToggle = newValue } }
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func didMoveToWindow() {
        super.didMoveToWindow()
        
        guard !didContructedSubView else { return }
        
        if let delegate = delegate {
            dataSource = .init(elements: delegate.elements, enabledFold: enabledFold)
        }
        
        constractViewHierarchyAndConstraint()
    }

    private func constractViewHierarchyAndConstraint() {
        addSubview(tableView)
        
        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(cell: Cell.self)
        tableView.register(headerFooter: Header.self)
        tableView.addedAsContent(toSuper: self)
        tableView.tableFooterView = .init()
        
        if let height = delegate?.itemHeight {
            tableView.rowHeight = height
            tableView.sectionHeaderHeight = height
        }
        
        didContructedSubView = true
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
        let cell: Cell = tableView.dequeueReusableCell(forRowAt: indexPath)

		let item = dataSource.item(forRowAt: indexPath)

        cell.config(.normal(item))

        return cell
    }
    
    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        0
    }
    
    public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        nil
    }

    // MARK: - UITableViewDelegate
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header: Header = tableView.dequeueReusableHeaderFooter()

        let item = FolderElement.folder(dataSource.item(for: section))
        
        header.config(item)
        
        header.tappedClosure = { [weak self] cell in
            guard let self = self else { return }

            if self.enabledFold {
                self.toggle(section: section) { [weak self] _ in
                    guard let self = self else { return }
                    self.triger(didSelected: item, of: cell)
                }
            } else {
                self.triger(didSelected: item, of: cell)
            }
        }

        return header
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let cell = tableView.cellForRow(at: indexPath) as? Cell else { return }
        
        let item = FolderElement.normal(dataSource.item(forRowAt: indexPath))
        triger(didSelected: item, of: cell.content)
    }
}

extension FolderListView {
    private func triger(didSelected item: FolderElement<Element>, of cell: Delegate.Cell) {
        delegate?.folderListView(didSelected: item, of: cell)
    }

    private func toggle(section: Int, completion: @escaping (FolderItemState) -> Void) {
        guard isNotInToggle else {
            return
        }
        
        isNotInToggle = false
        
        do {
            let result = try dataSource.toggle(section: section)
            
            if .none == result.change {
                completion(result.newState)
                isNotInToggle = true
            } else {
                update(result.change) {
                    completion(result.newState)
                    self.isNotInToggle = true
                }
            }
        } catch let error {
            isNotInToggle = true
            print(error.localizedDescription)
        }
    }
    
    private func update(_ editChange: FolderEditChange, completion: @escaping () -> Void) {
        func update() {
            tableView.isUserInteractionEnabled = false
            
            tableView.performBatchUpdates {
                if !editChange.removeIndexSet.isEmpty {
                    tableView.deleteSections(editChange.removeIndexSet, with: .fade)
                }
                
                if !editChange.removeIndexPaths.isEmpty {
                    tableView.deleteRows(at: editChange.removeIndexPaths, with: .fade)
                }
                
                if !editChange.insertIndexSet.isEmpty {
                    tableView.insertSections(editChange.insertIndexSet, with: .fade)
                }
                
                if !editChange.insertIndexPaths.isEmpty {
                    tableView.insertRows(at: editChange.insertIndexPaths, with: .fade)
                }
            } completion: { isFinished in
                if isFinished {
                    self.tableView.isUserInteractionEnabled = true
                    completion()
                }
            }
        }
        
        DispatchQueue.main.async {
            update()
        }
    }
}
