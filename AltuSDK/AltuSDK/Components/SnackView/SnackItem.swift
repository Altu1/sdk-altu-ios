//
//  SnackItem.swift
//  AltuSDK
//
//  Created by Ricardo Caldeira on 01/05/22.
//

import UIKit

open class SnackItem: ComponentPresenterModelImpl<SnackView> {
    
    public var backgroundColor: UIColor?
    public var descriptionTextColor: UIColor?
    public var actionTextColor: UIColor?
    public var descriptionText: NSMutableAttributedString?
    public var actionText: NSMutableAttributedString?
    
    public var buttonPressed: (() -> Void)?
    
    public var textAlignment: NSTextAlignment = .left
    
    public init(descriptionText: NSMutableAttributedString?,
                actionText: NSMutableAttributedString?,
                backgroundColor: UIColor,
                descriptionTextColor: UIColor,
                actionTextColor: UIColor,
                buttonPressed: (() -> Void)? = nil) {

        self.descriptionText = descriptionText
        self.actionText = actionText
        self.backgroundColor = backgroundColor
        self.descriptionTextColor = descriptionTextColor
        self.actionTextColor = actionTextColor
        self.buttonPressed = buttonPressed

        super.init(nibName: "SnackView")
    }
}
