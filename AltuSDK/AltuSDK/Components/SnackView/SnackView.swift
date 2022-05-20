//
//  SnackView.swift
//  AltuSDK
//
//  Created by Ricardo Caldeira on 01/05/22.
//

import UIKit

open class SnackView: UIView, ComponentPresenterView {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var actionView: UIView!
    @IBOutlet weak var actionLabel: UILabel!
    
    public var presenter: SnackItem?
    
    var buttonPressed: (() -> Void)?
    
    override open func awakeFromNib() {
        super.awakeFromNib()
    }
    
    public func componentDidLoad() {
    }
    
    public func updateView() {
        guard let actionView = self.actionView else { return }
        
        actionView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(close)))
        actionView.isUserInteractionEnabled = true
        
        if let description = self.presenter?.descriptionText {
            if let textAlignment = self.presenter?.textAlignment {
                description.setParagraph(alignment: textAlignment)
            }

            self.descriptionLabel.attributedText = description
        }
        
        if let actionText = self.presenter?.actionText {
            self.actionLabel.attributedText = actionText
        }
        
        if let backgroundColor = self.presenter?.backgroundColor {
            self.containerView.backgroundColor = backgroundColor
        }
        
        if let actionTextColor = self.presenter?.actionTextColor {
            self.actionLabel.textColor = actionTextColor
        }
        
        if let descriptionTextColor = self.presenter?.descriptionTextColor {
            self.descriptionLabel.textColor = descriptionTextColor
        }
        
        if let buttonPressed = self.presenter?.buttonPressed {
            self.buttonPressed = buttonPressed
        }
    }
    
    @objc func close() {
        self.buttonPressed?()
    }
}
