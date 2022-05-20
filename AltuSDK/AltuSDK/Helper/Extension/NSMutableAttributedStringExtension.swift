//
//  NSMutableAttributedStringExtension.swift
//  AltuSDK
//
//  Created by Ricardo Caldeira on 27/03/22.
//

import UIKit

public extension NSMutableAttributedString {
    
    @discardableResult func setParagraph(lineHeight: CGFloat? = nil, lineSpacing: CGFloat? = nil, paragraphSpacing: CGFloat? = nil, alignment: NSTextAlignment? = nil, lineBreakMode: NSLineBreakMode? = nil) -> NSMutableAttributedString {

        if lineHeight != nil || lineSpacing != nil || alignment != nil {
            let paragraphStyle = NSMutableParagraphStyle()
            if let lineBreakMode = lineBreakMode {
                paragraphStyle.lineBreakMode = lineBreakMode
            }
            let range = NSRange(location: 0, length: self.length)

            if let lineHeight = lineHeight {
                paragraphStyle.minimumLineHeight = lineHeight
                paragraphStyle.maximumLineHeight = lineHeight
            }

            if let lineSpacing = lineSpacing {
                paragraphStyle.lineSpacing = lineSpacing
            }

            //Funciona melhor se o lineHeight estiver setado.
            if let paragraphSpacing = paragraphSpacing {
                paragraphStyle.paragraphSpacing = paragraphSpacing
            }

            if let alignment = alignment {
                paragraphStyle.alignment = alignment
            }

            self.addAttributes([NSAttributedString.Key.paragraphStyle : paragraphStyle], range: range)
        }
        return self
    }
}
