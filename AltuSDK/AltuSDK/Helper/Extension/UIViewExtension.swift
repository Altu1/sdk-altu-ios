//
//  UIViewExtension.swift
//  AltuSDK
//
//  Created by Ricardo Caldeira on 27/03/22.
//

import UIKit

public extension UIView {
    func getLastParentView() -> UIView {
        if let superView = self.superview {
            return superView.getLastParentView()
        }
        return self
    }
}
