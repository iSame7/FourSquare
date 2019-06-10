//
//  UIView+nib.swift
//  FourSquare
//
//  Created by Sameh Mabrouk on 31/05/2019.
//  Copyright © 2019 VanMoof. All rights reserved.
//

import UIKit

public protocol NibOwnerLoadable: class {
    static var nib: UINib { get }
}

// MARK: Default implementation
public extension NibOwnerLoadable {
    static var nib: UINib {
        return UINib(nibName: String(describing: self), bundle: Bundle(for: self))
    }
}

// MARK: Support for instantiation from NIB
public extension NibOwnerLoadable where Self: UIView {
    func loadNibContent() {
        let layoutAttributes: [NSLayoutConstraint.Attribute] = [.top, .leading, .bottom, .trailing]
        for case let view as UIView in Self.nib.instantiate(withOwner: self, options: nil) {
            view.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview(view)
            NSLayoutConstraint.activate(layoutAttributes.map { attribute in
                NSLayoutConstraint(
                    item: view, attribute: attribute,
                    relatedBy: .equal,
                    toItem: self, attribute: attribute,
                    multiplier: 1, constant: 0.0
                )
            })
        }
    }
}
