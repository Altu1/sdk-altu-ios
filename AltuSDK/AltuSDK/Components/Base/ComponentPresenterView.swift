//
//  ComponentPresenterView.swift
//  AltuSDK
//
//  Created by Ricardo Caldeira on 27/03/22.
//

import Foundation
import UIKit

public protocol ComponentViewControllerDelegate: AnyObject {
    var viewController: UIViewController { get }
    func dissmissKeyboardAction(_ sender: Any?)
    func validateTouchId(_ isValid: Bool)
    func presentViewController(_ viewController: UIViewController, animated: Bool)
    func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)?)
    func pushViewControllerFromNavigation(_ viewController: UIViewController, animated: Bool)
}

public extension ComponentViewControllerDelegate where Self: UIViewController {
    func validateTouchId(_ isValid: Bool) { }
    func presentViewController(_ viewController: UIViewController, animated: Bool) { }
    func dissmissKeyboardAction(_ sender: Any?) { }
    func pushViewControllerFromNavigation(_ viewController: UIViewController, animated: Bool) {
        self.navigationController?.pushViewController(viewController, animated: animated)
    }
    var viewController: UIViewController {
        return self
    }
}

public protocol ComponentPresenterView: UIView {
    associatedtype Model: ComponentPresenterModel

    var presenter: Model? {get set}

    func componentDidLoad()
    func updateView()
}

