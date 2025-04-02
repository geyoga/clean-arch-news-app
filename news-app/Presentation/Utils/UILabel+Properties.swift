//
//  UILabel+Properties.swift
//  news-app
//
//  Created by Georgius Yoga on 2/4/25.
//

import UIKit

extension UILabel {
    @discardableResult
    public func text(_ text: String) -> Self {
        self.text = text
        return self
    }
    @discardableResult
    public func align(_ alignment: NSTextAlignment) -> Self {
        textAlignment = alignment
        return self
    }
    @discardableResult
    public func font(_ font: UIFont) -> Self {
        self.font = font
        return self
    }
    @discardableResult
    public func textColor(_ color: UIColor) -> Self {
        self.textColor = color
        return self
    }
    @discardableResult
    public func numberOfLines(_ number: Int) -> Self {
        self.numberOfLines = number
        return self
    }
}
