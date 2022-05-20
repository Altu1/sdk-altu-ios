//
//  ChatHeaderItem.swift
//  AltuSDK
//
//  Created by Ricardo Caldeira on 27/03/22.
//

import UIKit

open class ChatHeaderItem: ComponentPresenterModelImpl<ChatHeaderView> {

    public var title: NSMutableAttributedString?
    public var backgroundColor: UIColor?
    public var imageButton: UIImage?
    public var imageAvatar: UIImage?

    public var buttonPressed: (() -> Void)?

    public var textAlignment: NSTextAlignment = .left

    public init(title: NSMutableAttributedString?,
                backgroundColor: UIColor? = UIColor(hexString: "#000000"),
                imageButton: UIImage? = nil,
                imageLogo: UIImage? = nil,
                buttonPressed: (() -> Void)? = nil) {

        self.title = title
        self.backgroundColor = backgroundColor
        self.imageButton = imageButton
        self.buttonPressed = buttonPressed
        self.imageAvatar = imageLogo

        super.init(nibName: "ChatHeaderView")
    }
}
