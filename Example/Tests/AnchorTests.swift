//  Copyright (c) 2018 André Gillfrost
//  Licensed under the MIT license

import XCTest
import AnchorChain

class AnchorTests: XCTestCase {

    // MARK: - Default parameters

    func testTargetDefaultsToSuperview() {
        viewAndSuperview { view, superview in

            view.anchor()

            expect(view, toMatch: superview)
        }
    }

    func testRelationDefaultsToEqual() {
        siblings { view, otherView in

            let defaultRelation = view.anchor(.left, to: .right, of: otherView).relation

            XCTAssertEqual(defaultRelation, .equal)
        }
    }

    // MARK: - Separate anchors

    func testSeparateAnchors() {
        UIView.Anchor.allCases.forEach { anchor in
            let view = UIView()
            let other = UIView()

            view.anchor(anchor, to: other)

            expect(anchor.layoutAttribute, of: view, toMatch: other)
        }
    }

    // MARK: - Vertical anchors

    func testAnchorAllCombinationsOfVerticalAnchors() {
        UIView.YAnchor
            .allCases
            .allCombinations
            .forEach { anchor, otherAnchor in
                siblings { view, otherView in

                    view.anchor(anchor, to: otherAnchor, of: otherView)

                    expect(anchor.layoutAttribute, of: view, toMatch: otherAnchor.layoutAttribute, of: otherView)
                }
        }
    }

    // MARK: - Horizontal anchors

    func testAnchorAllCombinationsOfHorizontalAnchors() {
        UIView.XAnchor
            .allCases
            .allCombinations
            .forEach { anchor, otherAnchor in
                siblings { view, otherView in

                    view.anchor(anchor, to: otherAnchor, of: otherView)

                    expect(anchor.layoutAttribute, of: view, toMatch: otherAnchor.layoutAttribute, of: otherView)
                }
        }
    }

    func testAnchorAllCombinationsOfDirectionalHorizontalAnchors() {
        UIView.DirectionalXAnchor
            .allCases
            .allCombinations
            .forEach { anchor, otherAnchor in
                siblings { view, otherView in

                    view.anchor(anchor, to: otherAnchor, of: otherView)

                    expect(anchor.layoutAttribute, of: view, toMatch: otherAnchor.layoutAttribute, of: otherView)
                }
        }
    }

    // MARK: - Dimensional anchors

    func testAnchorWidthToConstant() {
        let constant: CGFloat = 123
        let view = UIView()

        view.anchor(.width, to: constant)

        expect(.width, of: view, toMatch: constant)
    }

    func testAnchorHeightToConstant() {
        let constant: CGFloat = 312
        let view = UIView()

        view.anchor(.height, to: constant)

        expect(.height, of: view, toMatch: constant)
    }

    func testAnchorSizeAnchorsWidthToHeight() {
        let constant: CGFloat = 231
        let view = UIView()

        view.anchor(.size, to: constant)

        expect(.width, of: view, toMatch: constant)
        expect(.width, toMatch: .height, of: view)
    }

    func testAnchorDifferentDimensionalAnchors() {
        siblings { one, two in

            one.anchor(.width, to: .height, of: two)

            expect(.width, of: one, toMatch: .height, of: two)
        }
    }

    // MARK: - Multipliers

    func testDimensionalAnchorToOtherWithMultiplier() {
        siblings { one, two in

            let constraint = one.anchor(.width, to: .height, of: two, multiplier: 1.5)

            XCTAssertEqual(constraint.multiplier, 1.5)
        }
    }
}
