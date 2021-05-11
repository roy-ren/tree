//
//  Node.swift
//  
//
//  Created by roy on 2021/5/11.
//

import Foundation

public indirect enum Node<Element> {
    case none
    case branch(super: Self, firstChild: Self, element: Element, next: Self)
}
