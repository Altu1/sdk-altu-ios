//
//  ChatHeaderView.swift
//  AltuSDK
//
//  Created by Ricardo Caldeira on 27/03/22.
//

import UIKit

open class ChatHeaderView: UIView, ComponentPresenterView {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var avatarImageWidth: NSLayoutConstraint!
    @IBOutlet weak var titleLabel: UILabel!
    
    public var presenter: ChatHeaderItem?
    
    var buttonPressed: (() -> Void)?
    
    override open func awakeFromNib() {
        super.awakeFromNib()
    }
    
    public func componentDidLoad() {
    }
    
    public func updateView() {
        if let title = self.presenter?.title {
            if let textAlignment = self.presenter?.textAlignment {
                title.setParagraph(alignment: textAlignment)
            }

            self.titleLabel.attributedText = title
        }
        
        if let backgroundColor = self.presenter?.backgroundColor {
            self.containerView.backgroundColor = backgroundColor
        }
        
        if let imageButton = self.presenter?.imageButton {
            self.closeButton.setImage(imageButton, for: .normal)
        }
        
        if let imageAvatar = self.presenter?.imageAvatar {
            self.avatarImage.image = imageAvatar
            self.avatarImageWidth.constant = 40
        } else {
            self.avatarImageWidth.constant = 0
        }
        
        if let buttonPressed = self.presenter?.buttonPressed {
            self.buttonPressed = buttonPressed
        }
    }
    
    @IBAction func closeButtonAction(_ sender: Any) {
        self.buttonPressed?()
    }
}
