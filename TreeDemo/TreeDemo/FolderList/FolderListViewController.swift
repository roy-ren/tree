//
//  FolderListViewController.swift
//  TreeDemo
//
//  Created by roy on 2021/5/12.
//

import UIKit
import Tree
import RLayoutKit

class FolderListViewController: UIViewController {
    private let folderView = FolderListView<FolderListViewController>()
        
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        folderView.delegate = self
        
        folderView.rl.added(to: view) {
            $0.edges == $1.edges
        }
    }
}

extension FolderListViewController: FolderListViewDelegate {
    var elements: [Element] {
        [
            .init(id: 0, element: "R", parentIdentifier: -1, rank: 0),
            .init(id: 1, element: "a", parentIdentifier: 0, rank: 0),
            .init(id: 11, element: "a1", parentIdentifier: 1, rank: 0),
            .init(id: 12, element: "a2", parentIdentifier: 1, rank: 1),
            .init(id: 121, element: "a2i", parentIdentifier: 12, rank: 0),
            .init(id: 13, element: "a3", parentIdentifier: 1, rank: 2),
            .init(id: 2, element: "b", parentIdentifier: 0, rank: 1),
            .init(id: 20, element: "b1", parentIdentifier: 2, rank: 0),
            .init(id: 21, element: "b2", parentIdentifier: 2, rank: 1),
            .init(id: 211, element: "b2i", parentIdentifier: 21, rank: 0),
        ]
    }
    
    func folderListView(didSelected element: FolderElement<Element>, of cell: Cell) {
        switch element {
        case .normal:
            print("cell item: \(element.element.element)")
        case .folder:
            print("section item: \(element.element.element), newState: \(element.state)")
        }
    }
    
    var itemHeight: CGFloat { 60 }
}

extension FolderListViewController {
    class Cell: UIView, FolderListCellViewType {
        private let iconImageView = UIImageView()
        private let label = UILabel()
        private var iconLeadingConstraint: NSLayoutConstraint!
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            
            iconImageView.rl.added(to: self, andLayout: {
                $0.size == CGSize(width: 20, height: 20)
                $0.centerY == $1.centerY
            })
            
            iconLeadingConstraint = iconImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15)
            iconLeadingConstraint.isActive = true
            
            label.rl.added(to: self) {
                $0.leading == iconImageView.rl.trailing + 8
                $0.trailing == -15
                $0.centerY == $1.centerY
            }
            
            label.font = .systemFont(ofSize: 14)
            backgroundColor = .systemBackground
        }
        
        required convenience init() {
            self.init(frame: .zero)
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        func config(with element: FolderElement<Element>) {
            
            let leading = CGFloat(element.depth) * 30
            iconLeadingConstraint.constant = 15 + leading
            
            switch element {
            case .normal:
                let imageConfig = UIImage.SymbolConfiguration(pointSize: 16, weight: .ultraLight, scale: .default)
                iconImageView.image = UIImage(systemName: "doc", withConfiguration: imageConfig)
                label.text = "\(element.element.element)"
            case .folder:
                switch element.state {
                case .collapse:
                    iconImageView.image = UIImage(systemName: "folder.fill")
                default:
                    iconImageView.image = UIImage(systemName: "folder")
                }
                
                label.text = "\(element.element.element)"
            }
        }
    }
    
    struct Element: FolderElementConstructable {
        let id: Int
        let element: String
        let parentIdentifier: Int
        let rank: Int
        
        static let invisableRootIdentifier = -1
    }
}
