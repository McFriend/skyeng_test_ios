//
//  Extensions.swift
//  Skyeng Test
//
//  Created by Георгий Сабанов on 11.07.2020.
//  Copyright © 2020 Georgiy Sabanov. All rights reserved.
//

import UIKit

extension UILabel {
    @discardableResult func setAttributedText(fromHtml html: String) -> Bool {
        guard let data = html.data(using: .utf8, allowLossyConversion: true) else {
            print(">>> Could not create UTF8 formatted data from \(html)")
            return false
        }

        do {
            let mutableText = try NSMutableAttributedString(
                data: data,
                options: [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html, NSAttributedString.DocumentReadingOptionKey.characterEncoding: String.Encoding.utf8.rawValue],
                documentAttributes: nil)
            mutableText.replaceFonts(with: font)
            self.attributedText = mutableText
            return true
        } catch (let error) {
            print(">>> Could not create attributed text from \(html)\nError: \(error)")
            return false
        }
    }
}

extension NSMutableAttributedString {
    func replaceFonts(with font: UIFont) {
        let baseFontDescriptor = font.fontDescriptor
        var changes = [NSRange: UIFont]()
        enumerateAttribute(.font, in: NSMakeRange(0, length), options: []) { foundFont, range, _ in
            if let htmlTraits = (foundFont as? UIFont)?.fontDescriptor.symbolicTraits,
                let adjustedDescriptor = baseFontDescriptor.withSymbolicTraits(htmlTraits) {
                let newFont = UIFont(descriptor: adjustedDescriptor, size: font.pointSize)
                changes[range] = newFont
            }
        }
        changes.forEach { range, newFont in
            removeAttribute(.font, range: range)
            addAttribute(.font, value: newFont, range: range)
        }
    }
}

extension UIFont {
    var boldVersion: UIFont {
        var font = self
        if let newDescriptor = font.fontDescriptor.withSymbolicTraits(.traitBold) {
            font = UIFont(descriptor: newDescriptor, size: font.pointSize)
        }
        return font
    }
}

extension String {
    var localized: String {
        NSLocalizedString(self, comment: "")
    }
}

extension String {
    var httpsUrl: String {
        "https:" + self
    }
}

extension UIScreen {
    var isPortrait: Bool {
        return bounds.height > bounds.width
    }
}

extension UIView {
    func setBackgroundColor(to color: UIColor) -> UIView {
        self.backgroundColor = color
        return self
    }
}
