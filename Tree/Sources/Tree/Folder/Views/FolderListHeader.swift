//
//  FolderListHeader.swift
//  
//
//  Created by roy on 2021/4/23.
//

import UIKit

class FolderListHeader<
    Content: FolderListCellViewType
>: UITableViewHeaderFooterView, FolderListViewReuseViewProtocol {
    let content: Content
    
    typealias TappedClosure = (Content) -> Void
    var tappedClosure: TappedClosure?
    
    override init(reuseIdentifier: String?) {
        content = .init()
        super.init(reuseIdentifier: reuseIdentifier)
        content.addedAsContent(toSuper: contentView)
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(didTappedHeader(_:)))
        contentView.addGestureRecognizer(gesture)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        tappedClosure = nil
    }
    
    @objc
    func didTappedHeader(_ gesture: UITapGestureRecognizer) {
        tappedClosure?(content)
    }
}
