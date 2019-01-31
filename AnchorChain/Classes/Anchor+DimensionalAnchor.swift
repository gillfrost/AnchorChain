//  Copyright (c) 2018 André Gillfrost
//  Licensed under the MIT license

import UIKit

public extension UIView {

    enum DimensionalAnchor { case width, height, size }
    enum OneDimensionalAnchor { case width, height }

    /**
     Constrains one dimension to a constant.

     Passing `.size` as anchor will constrain width to height, and
     return a single constraint whose constant represents both dimensions.

     - Parameters:
     - anchor:    The dimension to constrain, `.width`, `.height` or `.size`.
     - relation:  `.equal` by default.
     - constant:  The constant.
     - priority:  `.required` by default.
     - isActive:  `true` by default.

     - Returns: The created constraint. Discardable.
     */
    @discardableResult
    func anchor(_ anchor: DimensionalAnchor,
                _ relation: NSLayoutRelation = .equal,
                to constant: CGFloat,
                priority: UILayoutPriority = .required,
                isActive: Bool = true) -> NSLayoutConstraint {

        if anchor == .size {
            widthAnchor.constraint(equalTo: heightAnchor).isActive = true
        }
        return self.anchor(for: anchor == .height ? .height : .width)
            .constraint(relation, to: constant)
            .priority(priority)
            .isActive(isActive)
    }

    /**
     Constrains one dimension to given dimension of given view.

     - Parameters:
       - anchor:      The dimension to constrain..
       - relation:    `.equal` by default.
       - otherAnchor: The dimension to match.
       - otherView:   The view to match.
       - priority:    `.required` by default.
       - isActive:    `true` by default.

     - Returns: The created constraint. Discardable.
     */
    @discardableResult
    func anchor(_ anchor: OneDimensionalAnchor,
                _ relation: NSLayoutRelation = .equal,
                to otherAnchor: OneDimensionalAnchor,
                of otherView: UIView,
                priority: UILayoutPriority = .required,
                isActive: Bool = true) -> NSLayoutConstraint {

        return self.anchor(for: anchor)
            .constraint(relation, to: otherView.anchor(for: otherAnchor))
            .priority(priority)
            .isActive(isActive)
    }
}

private extension Anchorable {

    func anchor(for anchor: UIView.OneDimensionalAnchor) -> NSLayoutDimension {
        switch anchor {
        case .width:
            return widthAnchor
        case .height:
            return heightAnchor
        }
    }
}

private extension NSLayoutDimension {

    func constraint(_ relation: NSLayoutRelation, to constant: CGFloat) -> NSLayoutConstraint {
        switch relation {
        case .equal:
            return constraint(equalToConstant: constant)
        case .lessThanOrEqual:
            return constraint(lessThanOrEqualToConstant: constant)
        case .greaterThanOrEqual:
            return constraint(greaterThanOrEqualToConstant: constant)
        }
    }

    func constraint(_ relation: NSLayoutRelation, to dimension: NSLayoutDimension) -> NSLayoutConstraint {
        switch relation {
        case .equal:
            return constraint(equalTo: dimension)
        case .lessThanOrEqual:
            return constraint(lessThanOrEqualTo: dimension)
        case .greaterThanOrEqual:
            return constraint(greaterThanOrEqualTo: dimension)
        }
    }
}
