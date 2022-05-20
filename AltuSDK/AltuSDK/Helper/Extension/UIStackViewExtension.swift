//
//  UIStackViewExtension.swift
//  AltuSDK
//
//  Created by Ricardo Caldeira on 29/03/22.
//

import UIKit

public extension UIStackView {
    func fillStackView(withItems items: [ComponentPresenterModel], insets: UIEdgeInsets = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0), distribution: UIStackView.Distribution = .fill, alignment: UIStackView.Alignment = .fill, spacing: CGFloat = 0, strippedColor: UIColor? = nil, axis: NSLayoutConstraint.Axis = .vertical, cleanStack: Bool = true, resetViews: Bool = false, componentPresenterUpdateType: ComponentPresenterUpdateType? = nil) {

        if let componentPresenterUpdateType = componentPresenterUpdateType {
            items.forEach { component in
                component.componentPresenterUpdateType = componentPresenterUpdateType
            }
        }

        if cleanStack {
            for view in self.arrangedSubviews {
                self.removeArrangedSubview(view)
                view.removeFromSuperview()
            }
        }

        styleIt(withInsets: insets, distribution: distribution, alignment: alignment, spacing: spacing, axis: axis)

        var idx = 0
        for item in items {
            self.updateComponentView(component: item, resetView: resetViews)

            if let viewGeneric = item.getComponentView() {
                if resetViews && viewGeneric.superview != nil {
                    viewGeneric.removeFromSuperview()
                }

                if idx % 2 == 0 && strippedColor != nil {
                    viewGeneric.backgroundColor = strippedColor!
                }

                self.addArrangedComponentView(component: item, view: viewGeneric)
                idx += 1
            }
        }
    }
    
    func updateComponentView(component: ComponentPresenterModel, resetView: Bool) {
        component.instantiate(resetView: resetView)
    }
    
    func addArrangedComponentView(component: ComponentPresenterModel, view: UIView) {
        self.addArrangedSubview(view)
        if component.componentPresenterUpdateType == .afterAppendToStackView {
            component.configureData()
        }
    }
    
    fileprivate func styleIt(withInsets insets: UIEdgeInsets, distribution: UIStackView.Distribution, alignment: UIStackView.Alignment, spacing: CGFloat, axis: NSLayoutConstraint.Axis) {
        self.distribution = distribution
        self.alignment = alignment
        self.axis = axis
        self.spacing = spacing
        self.layoutMargins = insets
    }
}
