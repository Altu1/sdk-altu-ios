//
//  SeparatorViewCell.swift
//  AltuSDK
//
//  Created by Ricardo Caldeira on 25/04/22.
//

import UIKit

public class SeparatorViewCell: UITableViewCell {
    
    @IBOutlet weak var separatorView: UIView!
    @IBOutlet weak var separatorViewHeight: NSLayoutConstraint!
    @IBOutlet weak var marginRight: NSLayoutConstraint!
    @IBOutlet weak var marginLeft: NSLayoutConstraint!
    @IBOutlet weak var marginTop: NSLayoutConstraint!
    @IBOutlet weak var marginBottom: NSLayoutConstraint!

    static var identifier: String {
        return "SeparatorViewCell"
    }

    public override func awakeFromNib() {
        super.awakeFromNib()
        self.prepareForReuse()
    }

    public override func prepareForReuse() {
        super.prepareForReuse()
    }

    func configure(height: CGFloat?, radius: CGFloat?, backgroundColor: UIColor?, marginTop: CGFloat?, marginBottom: CGFloat?, marginLeft: CGFloat?, marginRight: CGFloat?) {
        if let height = height {
            self.separatorViewHeight.constant = height
        }
        
        if let radius = radius {
            self.separatorView.layer.cornerRadius = radius
        }
        
        if let backgroundColor = backgroundColor {
            self.separatorView.backgroundColor = backgroundColor
        }
        
        if let marginTop = marginTop {
            self.marginTop.constant = marginTop
        }
        
        if let marginBottom = marginBottom {
            self.marginBottom.constant = marginBottom
        }
        
        if let marginLeft = marginLeft {
            self.marginLeft.constant = marginLeft
        }
        
        if let marginRight = marginRight {
            self.marginRight.constant = marginRight
        }
    }
}
