//
//  FolderElementProtocol.swift
//  
//
//  Created by roy on 2021/5/11.
//

import Foundation

public protocol Identifiable {
    associatedtype ID: Hashable
    
    /// 唯一 id
    var id: Self.ID { get }
}

public protocol FolderElementConstructable: Identifiable, Equatable {
    associatedtype Element
    
    /// 数据
    var element: Self.Element { get }
    
    /// 父节点的 id
    var superIdentifier: ID? { get }
    
    /// 在同级中的排序
    var rank: Int { get set }
}
