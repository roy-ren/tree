//
//  FolderListView.swift
//  
//
//  Created by roy on 2021/4/23.
//

import UIKit

public protocol FolderListViewDelegate: AnyObject {
    var itemHeight: CGFloat { get }
    
    func folderListView<Element: FolderElementConstructable>(didSelected element: Element)
}


public final class FolderListView<
    Cell: FolderListCellType
>: UIView, UITableViewDataSource, UITableViewDelegate {
    
    public typealias Element = Cell.Element
    public weak var delegate: FolderListViewDelegate?
    
    private var dataSource: Folder<Element>
    private let table = UITableView()

    private typealias ListCell = FolderListCell<Cell>
    private typealias Header = FolderListHeader<Cell>
    
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
        
        table.register(cell: ListCell.self)
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
        let cell = table.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! Cell
        
        cell.config(with: .normal(dataSource.element(forRowAt: indexPath)))
        
        return cell
    }
    
    // MARK: - UITableViewDelegate
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header: Header = tableView.dequeueReusableHeaderFooter()
        
        let element = dataSource.element(for: section)
        header.config(.folder(element))
        header.tappedClosure = { [weak self] cell in
            guard let self = self else { return }
            
            self.toggle(section: section) { [weak self] isCompletion in
                guard let self = self else { return }
                
                if isCompletion { self.triger(didSelected: element) }
            }
        }
        
        return header
    }
}

extension FolderListView {
    private func triger(didSelected item: Element) {
        delegate?.folderListView(didSelected: item)
    }

    private func toggle(section: Int, completion: @escaping (Bool) -> Void) {
        
    }
}
