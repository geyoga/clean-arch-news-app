//
//  UIView+Stacking.swift
//  LBTATools
//
//  Created by Brian Voong on 4/28/19.
//  Copyright © 2019 Tieda Wei. All rights reserved.

import UIKit

@available(iOS 11.0, tvOS 11.0, *)
extension UIView {
    
    fileprivate func _stack(_ axis: NSLayoutConstraint.Axis = .vertical, views: [UIView], spacing: CGFloat = 0, alignment: UIStackView.Alignment = .fill, distribution: UIStackView.Distribution = .fill) -> UIStackView {
        let stackView = UIStackView(arrangedSubviews: views)
        stackView.axis = axis
        stackView.spacing = spacing
        stackView.alignment = alignment
        stackView.distribution = distribution
        addSubview(stackView)
        stackView.fillSuperview()
        return stackView
    }
    
    @discardableResult
    public func stack(_ views: UIView..., spacing: CGFloat = 0, alignment: UIStackView.Alignment = .fill, distribution: UIStackView.Distribution = .fill) -> UIStackView {
        return _stack(.vertical, views: views, spacing: spacing, alignment: alignment, distribution: distribution)
    }
    
    @discardableResult
    public func hstack(_ views: UIView..., spacing: CGFloat = 0, alignment: UIStackView.Alignment = .fill, distribution: UIStackView.Distribution = .fill) -> UIStackView {
        return _stack(.horizontal, views: views, spacing: spacing, alignment: alignment, distribution: distribution)
    }
    
    @discardableResult
    public func withSize<T: UIView>(_ size: CGSize) -> T {
        translatesAutoresizingMaskIntoConstraints = false
        widthAnchor.constraint(equalToConstant: size.width).isActive = true
        heightAnchor.constraint(equalToConstant: size.height).isActive = true
        return self as! T
    }
    
    @discardableResult
    public func withHeight(_ height: CGFloat) -> UIView {
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(equalToConstant: height).isActive = true
        return self
    }
    
    @discardableResult
    public func withWidth(_ width: CGFloat) -> UIView {
        translatesAutoresizingMaskIntoConstraints = false
        widthAnchor.constraint(equalToConstant: width).isActive = true
        return self
    }
    
    @discardableResult
    func withBorder<T: UIView>(width: CGFloat, color: UIColor) -> T {
        layer.borderWidth = width
        layer.borderColor = color.cgColor
        return self as! T
    }
}

extension CGSize {
    static public func equalEdge(_ edge: CGFloat) -> CGSize {
        return .init(width: edge, height: edge)
    }
}

extension UIEdgeInsets {
    static public func allSides(_ side: CGFloat) -> UIEdgeInsets {
        return .init(top: side, left: side, bottom: side, right: side)
    }
    static public func equalSides(topBottom: CGFloat, leftRight: CGFloat) -> UIEdgeInsets {
        return .init(top: topBottom, left: leftRight, bottom: topBottom, right: leftRight)
    }
}

extension UIImageView {
    convenience public init(image: UIImage?, contentMode: UIView.ContentMode = .scaleAspectFill) {
        self.init(image: image)
        self.contentMode = contentMode
        self.clipsToBounds = true
    }
}

@available(iOS 11.0, tvOS 11.0, *)
extension UIView {

    fileprivate func _vstack(
        _ axis: NSLayoutConstraint.Axis = .vertical,
        views: [UIView],
        spacing: CGFloat = 0,
        alignment: UIStackView.Alignment = .fill,
        distribution: UIStackView.Distribution = .fill
    ) -> UIStackView {
        let stackView = UIStackView(arrangedSubviews: views)
        stackView.axis = axis
        stackView.spacing = spacing
        stackView.alignment = alignment
        stackView.distribution = distribution
        addSubview(stackView)
        stackView.fillSuperview()
        return stackView
    }

    @discardableResult
    public func vstack(
        _ views: UIView...,
        spacing: CGFloat = 0,
        alignment: UIStackView.Alignment = .fill,
        distribution: UIStackView.Distribution = .fill
    ) -> UIStackView {
        return _vstack(
            .vertical,
            views: views,
            spacing: spacing,
            alignment: alignment,
            distribution: distribution
        )
    }

    public func addSubViews(_ views: UIView...) {
        views.forEach({ addSubview($0) })
    }

}
