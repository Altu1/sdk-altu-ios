//
//  SimpleTextViewCell.swift
//  AltuSDK
//
//  Created by Ricardo Caldeira on 28/03/22.
//

import UIKit

public class SimpleTextViewCell: UITableViewCell {
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var spacingBottom: NSLayoutConstraint!
    @IBOutlet weak var spacingTop: NSLayoutConstraint!
    
    var showImage = true

    static var identifier: String {
        return "SimpleTextViewCell"
    }

    public override func awakeFromNib() {
        super.awakeFromNib()
        self.prepareForReuse()
    }

    public override func prepareForReuse() {
        super.prepareForReuse()
        self.descriptionLabel.text = nil
    }

    func configure(type: MessageType, message: NSAttributedString, textAlignment: NSTextAlignment = .left) {
        
        switch type {
        case .simpleMessage:
            spacingBottom.constant = 8
            spacingTop.constant = 16
        case .dateMessage:
            spacingBottom.constant = 0
            spacingTop.constant = 0
        default:
            break
        }
        
        self.descriptionLabel.attributedText = message
        self.descriptionLabel.textAlignment = textAlignment
    }
}

