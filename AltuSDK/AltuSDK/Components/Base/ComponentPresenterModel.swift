//
//  ComponentPresenterModel.swift
//  AltuSDK
//
//  Created by Ricardo Caldeira on 27/03/22.
//

import Foundation
import UIKit

public enum ComponentPresenterUpdateType {
    case beforeAppendToStackView
    case afterAppendToStackView
}

public protocol ComponentPresenterModel: NSObject {
    var optimizeRender: Bool {get}
    var componentPresenterUpdateType: ComponentPresenterUpdateType {get set}
    var waitForLoading: Bool {get}
    var ondFinishLoad: (() -> Void)? {get set}
    var componentIdentifier: String? {get set}

    func instantiate(resetView: Bool)

    func configureData()

    func isComponentHidden() -> Bool

    func handleVisibility(isVisible: Bool, animated: Bool)
    func handleVisibility(isVisible: Bool, animated: Bool, extraAnimationBlock: (() -> Void)?)

    func getMinHeight(parentWidth: CGFloat) -> CGFloat

    func forceCreate()

    func getComponentView() -> UIView?

    func updateOptimizeRender(newValue: Bool)
}

open class ComponentPresenterModelImpl<T: ComponentPresenterView>: NSObject, ComponentPresenterModel {
    public var componentPresenterUpdateType = ComponentPresenterUpdateType.afterAppendToStackView

    public var nibName: String
    public var optimizeRender = true
    public var waitForLoading: Bool = false
    public var ondFinishLoad: (() -> Void)?
    public var componentIdentifier: String?

    public var initialStateHidden = false
    public var hasUpdateView = false
    internal weak var presenterView: T?

    var elevateBox = true

    public init(nibName: String) {
        self.nibName = nibName
    }

    open func instantiate(resetView: Bool = true) {
        if resetView || self.presenterView == nil {
            let bundle = Bundle(for: T.self)
            let nib = UINib(nibName: self.nibName, bundle: bundle)
            let view = nib.instantiate(withOwner: T(), options: nil)[0] as? T

            self.presenterView = view
            self.presenterView?.presenter = self as? T.Model
            self.presenterView?.componentDidLoad()

            if self.componentPresenterUpdateType == .beforeAppendToStackView {
                self.configureData()
            }

            self.presenterView?.isHidden = self.initialStateHidden
        }
    }

    public func configureData() {
        if self.presenterView != nil {
            self.hasUpdateView = true
        }
        self.presenterView?.updateView()
    }

    public func updateOptimizeRender(newValue: Bool) {
        self.optimizeRender = newValue
    }

    public final func isComponentHidden() -> Bool {
        return self.presenterView?.isHidden ?? true
    }

    public final func handleVisibility(isVisible: Bool, animated: Bool) {
        self.handleVisibility(isVisible: isVisible, animated: animated, extraAnimationBlock: nil)
    }

    public final func handleVisibility(isVisible: Bool, animated: Bool, extraAnimationBlock: (() -> Void)?) {

        var animated = animated

        //A animação fica muito pesada no iOS 10 e inferior, por isso é feito sem animação
        if #available(iOS 11, *) {} else {
            animated = false
        }

        // Se a view (ou component) estiver nula o bloco pode ser executado sem animação
        if self.presenterView == nil {
            animated = false
        }

        let block: (() -> Void) = { [weak self, extraAnimationBlock] in
            guard let self = self else { return }
            if self.presenterView == nil {
                self.initialStateHidden = !isVisible
            } else {
                if self.presenterView?.isHidden != !isVisible {
                    self.presenterView?.isHidden = !isVisible
                    self.presenterView?.alpha = isVisible ? 1.0 : 0.0

                    if animated {
                        let parentView = self.presenterView?.getLastParentView()

                        self.presenterView?.superview?.setNeedsLayout()
                        self.presenterView?.superview?.layoutIfNeeded()

                        parentView?.setNeedsLayout()
                        parentView?.layoutIfNeeded()
                    }
                }
            }
            extraAnimationBlock?()
        }

        if animated {
            UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseOut], animations: block)
        } else {
            block()
        }

    }

    public final func forceCreate() {
        if self.presenterView == nil {
            self.instantiate()
            self.configureData()
        }
    }

    public func getMinHeight(parentWidth: CGFloat) -> CGFloat {
        self.forceCreate()

        if let component = self.presenterView {
            component.setNeedsLayout()
            component.layoutIfNeeded()

            let viewHeight = component.systemLayoutSizeFitting(CGSize(width: parentWidth, height: 0), withHorizontalFittingPriority: UILayoutPriority(rawValue: 1000), verticalFittingPriority: UILayoutPriority(rawValue: 50)).height

            return viewHeight
        }

        return 0
    }

    public func getComponentView() -> UIView? {
        return self.presenterView
    }

    public func applyAnimation(hidden: Bool, duration: TimeInterval = 0.3) {
        let block = { [weak self] in
            guard let self = self else {
                return
            }
            self.presenterView?.alpha = hidden ? 0 : 1
            self.presenterView?.isHidden = hidden
        }
        
        if duration > 0 {
            UIView.animate(withDuration: duration, delay: 0,
                           usingSpringWithDamping: 0.9, initialSpringVelocity: 1,
                           options: [],
                           animations: block,
                completion: nil)
        } else {
            block()
        }
    }

    public func fadeIn(duration: TimeInterval = 0.3) {
        self.fade(alpha: 1, duration: duration)
    }

    public func fadeOut(duration: TimeInterval = 0.3) {
        self.fade(alpha: 0, duration: duration)
    }

    public func fade(alpha: CGFloat, duration: TimeInterval = 0.3) {
        if duration > 0 {
            UIView.animate(withDuration: duration, delay: 0,
                           usingSpringWithDamping: 0.9, initialSpringVelocity: 1,
                           options: [],
                           animations: { [weak self] in
                            guard let self = self else {
                                return
                            }
                            self.presenterView?.alpha = alpha
                },
                           completion: nil)
        } else {
            self.presenterView?.alpha = alpha
        }
    }
}

