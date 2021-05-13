//
//  FolderListCell.swift
//  
//
//  Created by roy on 2021/4/23.
//

import UIKit

public protocol FolderListCellViewType: UIView {
    associatedtype Element: FolderElementConstructable
    
    func config(with element: FolderElement<Element>)
}

class FolderListCell<
    Content: FolderListCellViewType
>: UITableViewCell, FolderListViewReuseViewProtocol {
    let content: Content
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        content = .init()
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        content.addedAsContent(toSuper: contentView)
        selectionStyle = .none
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
