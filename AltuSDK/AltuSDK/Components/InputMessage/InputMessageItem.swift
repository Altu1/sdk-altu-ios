//
//  InputMessageItem.swift
//  AltuSDK
//
//  Created by Ricardo Caldeira on 04/04/22.
//

import UIKit

open class InputMessageItem: ComponentPresenterModelImpl<InputMessageView> {
    
    public var backgroundColor: UIColor?
    public var buttonColor: UIColor?
    
    public var buttonSendMessagePressed: ((_ message: String) -> Void)?

    public init(backgroundColor: UIColor? = UIColor(hexString: "#000000"),
                buttonColor: UIColor? = UIColor(hexString: "#000000"),
                buttonSendMessagePressed: ((_ message: String) -> Void)? = nil) {
        
        self.backgroundColor = backgroundColor
        self.buttonColor = buttonColor
        self.buttonSendMessagePressed = buttonSendMessagePressed
        
        super.init(nibName: "InputMessageView")
    }
}
