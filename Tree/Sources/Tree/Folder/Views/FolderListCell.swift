//
//  FolderListCell.swift
//  
//
//  Created by roy on 2021/4/23.
//

import UIKit

public protocol FolderListCellType: UITableViewCell {
    associatedtype Element: FolderElementConstructable
    
    func config(with element: FolderConfigElement<Element>)
}

class FolderListCell<
    Content: FolderListCellType
>: UITableViewCell, FolderListViewReuseViewProtocol {
    let content: Content
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        content = .init()
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        content.addedAsContent(toSuper: contentView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
