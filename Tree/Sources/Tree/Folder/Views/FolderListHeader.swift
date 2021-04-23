//
//  FolderListHeader.swift
//  
//
//  Created by roy on 2021/4/23.
//

import UIKit

class FolderListHeader<
    Content: FolderListCellType
>: UITableViewHeaderFooterView, FolderListViewReuseViewProtocol {
    let content: Content
    
    typealias TappedClosure = (Content) -> Void
    var tappedClosure: TappedClosure?
    
    
    override init(reuseIdentifier: String?) {
        content = .init()
        super.init(reuseIdentifier: reuseIdentifier)
        content.addedAsContent(toSuper: contentView)
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(didTappedHeader))
        gesture.numberOfTapsRequired = 1
        gesture.numberOfTouchesRequired = 1
        contentView.addGestureRecognizer(gesture)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc
    func didTappedHeader() {
        tappedClosure?(content)
    }
}
