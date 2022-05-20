//
//  String+Attributed.swift
//  AltuSDK
//
//  Created by Ricardo Caldeira on 11/04/22.
//

import UIKit
import Foundation

public extension String {
    var convertHtmlToNSAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else {
            return nil
        }
        do {
            return try NSAttributedString(data: data,options: [.documentType: NSAttributedString.DocumentType.html,.characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
        }
        catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
    func convertHtmlToAttributedStringWithCSS(font: UIFont? , csscolor: String , lineheight: Int, csstextalign: String) -> NSAttributedString? {
        guard let font = font else {
            return convertHtmlToNSAttributedString
        }
        let modifiedString =
            "<style>body{font-family: '\(font.fontName)'; font-size:\(font.pointSize)px; color: \(csscolor); line-height: \(lineheight)px; text-align: \(csstextalign); }</style>\(self)"
        guard let data = modifiedString.data(using: .utf8) else {
            return nil
        }
        do {
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
        }
        catch {
            print(error)
            return nil
        }
    }
    
    func replace(_ dictionary: [String: String]) -> String {
        var result = String()
        var i = -1
        for (of , with): (String, String) in dictionary {
            i += 1
            if i<1 {
                result = self.replacingOccurrences(of: of, with: with)
            } else {
                result = result.replacingOccurrences(of: of, with: with)
            }
        }
        return result
    }
}
