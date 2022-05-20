//
//  InputMessageView.swift
//  AltuSDK
//
//  Created by Ricardo Caldeira on 04/04/22.
//

import UIKit

open class InputMessageView: UIView, ComponentPresenterView {
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var buttonView: UIView!
    @IBOutlet weak var inputMessageView: UIView!
    @IBOutlet weak var inputMessageTextField: UITextField!
    
    var buttonSendMessagePressed: ((_ message: String) -> Void)?
    
    public var presenter: InputMessageItem?
    
    override open func awakeFromNib() {
        super.awakeFromNib()
    }
    
    public func componentDidLoad() {
    }
    
    public func updateView() {
        guard let buttonView = self.buttonView else { return }
        
        buttonView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(sendMessage)))
        buttonView.isUserInteractionEnabled = true
        
        if let backgroundColor = self.presenter?.backgroundColor {
            self.contentView.backgroundColor = backgroundColor
        }
        
        if let buttonColor = self.presenter?.buttonColor {
            self.buttonView.backgroundColor = buttonColor
        }
        
        if let buttonSendMessagePressed = self.presenter?.buttonSendMessagePressed {
            self.buttonSendMessagePressed = buttonSendMessagePressed
        }
    }
    
    @objc func sendMessage() {
        if let text = inputMessageTextField.text, text.trimmingCharacters(in: NSCharacterSet.whitespaces) != "" {
            self.buttonSendMessagePressed?(text)
            inputMessageTextField.text = ""
        }
    }
}
