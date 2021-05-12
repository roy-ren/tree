//
//  TestFolderViewController.swift
//  TreeDemo
//
//  Created by roy on 2021/5/12.
//

import UIKit
import Tree
import RLayoutKit

class TestFolderViewController: UIViewController {
    private let folderView = FolderListView<TestFolderViewController>()
    
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

extension TestFolderViewController: FolderListViewDelegate {
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
    
extension TestFolderViewController {
    var elements: [Element] {
        [
            .init(id: 32539155, element: "分发测试文件夹", parentIdentifier: 0, rank: 2),
            .init(id: 32539156, element: "天涯海角6", parentIdentifier: 0, rank: 3),
            .init(id: 32539158, element: "关关雎鸠", parentIdentifier: 0, rank: 4),
            .init(id: 32672504, element: "你可以删除的邮件", parentIdentifier: 0, rank: 5),
            .init(id: 32674925, element: "puppy love", parentIdentifier: 0, rank: 6),
            .init(id: 32675331, element: "小满系统邮件", parentIdentifier: 0, rank: 7),
            .init(id: 33954888, element: "问题邮件", parentIdentifier: 0, rank: 8),
            .init(id: 33955087, element: "问题邮件2", parentIdentifier: 0, rank: 9),
            .init(id: 38699595, element: "工单0321", parentIdentifier: 0, rank: 10),
            .init(id: 39486934, element: "邮件调试", parentIdentifier: 0, rank: 11),
            .init(id: 40455171, element: "若水三千", parentIdentifier: 0, rank: 12),
            .init(id: 1100632736, element: "ticket20191017", parentIdentifier: 0, rank: 13),
            .init(id: 1103000555, element: "新天地", parentIdentifier: 0, rank: 14),
            .init(id: 1104473240, element: "测试收件", parentIdentifier: 0, rank: 15),
            .init(id: 1104473243, element: "测试发件", parentIdentifier: 0, rank: 16),
            .init(id: 1104473303, element: "收发件都有", parentIdentifier: 0, rank: 17),
            .init(id: 1104485535, element: "明月几时有", parentIdentifier: 0, rank: 18),
            .init(id: 1104494467, element: "临时已发送的邮件哦", parentIdentifier: 0, rank: 19),
            .init(id: 1104495531, element: "锦衣卫陆绎", parentIdentifier: 0, rank: 20),
            .init(id: 1104630812, element: "六扇门袁今夏", parentIdentifier: 0, rank: 21),
            .init(id: 1104630815, element: "传闻中的陈芊芊", parentIdentifier: 0, rank: 22),
            .init(id: 1115714172, element: "who cares", parentIdentifier: 0, rank: 39),
            .init(id: 32539157, element: "这样子哇", parentIdentifier: 32539156, rank: 1),
            .init(id: 32539159, element: "在河之洲", parentIdentifier: 32539158, rank: 7),
            .init(id: 32539166, element: "你好呀", parentIdentifier: 32539156, rank: 10),
            .init(id: 37337476, element: "小满错误上报", parentIdentifier: 32675331, rank: 13),
            .init(id: 32674772, element: "天天蓝蓝啦。。。", parentIdentifier: 32539158, rank: 13),
            .init(id: 40455173, element: "九千岁9000", parentIdentifier: 40455171, rank: 19),
            .init(id: 32674945, element: "888", parentIdentifier: 32674925, rank: 21),
            .init(id: 32674946, element: "4445666", parentIdentifier: 32674925, rank: 22),
            .init(id: 32674947, element: "2222", parentIdentifier: 32674925, rank: 23),
            .init(id: 32674992, element: "998", parentIdentifier: 32674925, rank: 26),
            .init(id: 1102257604, element: "已打开", parentIdentifier: 32674925, rank: 38),
            .init(id: 32539162, element: "窈窕淑女", parentIdentifier: 32539159, rank: 8),
            .init(id: 32674773, element: "吞吞吐吐", parentIdentifier: 32674772, rank: 14),
            .init(id: 32674996, element: "889", parentIdentifier: 32674992, rank: 27),
            .init(id: 32539165, element: "君子好逑", parentIdentifier: 32539162, rank: 9),
            .init(id: 32674785, element: "三五一直", parentIdentifier: 32539165, rank: 15),
            .init(id: 32674786, element: "二二得是", parentIdentifier: 32674785, rank: 16),
            .init(id: 32674787, element: "9988888", parentIdentifier: 32674785, rank: 17),
            .init(id: 32674790, element: "7777", parentIdentifier: 32674787, rank: 1),
            .init(id: 32674788, element: "分吹预算", parentIdentifier: 32674787, rank: 2),
            .init(id: 32674976, element: "三叔你好", parentIdentifier: 32674787, rank: 3),
            .init(id: 1102124721, element: "袁今夏！", parentIdentifier: 32674976, rank: 37),
        ]
    }
    
    struct Element: FolderElementConstructable {
        static let invisableRootIdentifier: Int64 = 0
        
        let id: Int64
        let element: String
        let parentIdentifier: Int64
        let rank: Int
    }
}

extension TestFolderViewController {
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
//                iconImageView.image = UIImage(systemName: "doc", withConfiguration: imageConfig)
                iconImageView.image = UIImage(systemName: "folder")
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
}
