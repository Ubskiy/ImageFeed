//
//  XCUIElement + extensions.swift
//  ImageFeedUITests
//
//  Created by Арсений Убский on 24.04.2023.
//

import XCTest

extension XCUIElement {
    func tapUnhittable() {
        XCTContext.runActivity(named: "Tap \(self) by coordinate") { _ in
            coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.5)).tap()
        }
    }
}

