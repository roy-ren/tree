//
//  ViewWrapper.swift
//  TreeDemo
//
//  Created by roy on 2021/5/12.
//

import UIKit
import SwiftUI

struct ViewWrapper<Controller: UIViewController>: UIViewControllerRepresentable {
    typealias UIViewControllerType = Controller
    
    func makeUIViewController(
        context: UIViewControllerRepresentableContext<Self>
    ) -> Self.UIViewControllerType {
        .init()
    }
    
    func updateUIViewController(
        _ uiViewController: Self.UIViewControllerType,
        context: UIViewControllerRepresentableContext<Self>
    ) {}
}
