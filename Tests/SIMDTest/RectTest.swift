//
//  RectTest.swift
//  UnitTests
//
//  Created by Kazuho Okui on 5/15/16.
//  Copyright © 2016 Nick Lockwood. All rights reserved.
//

import XCTest

class SIMDRectTest: XCTestCase {

  func testInset() {
    let r = Rect(0, 0, 100, 100)
    let cr = CGRectMake(0, 0, 100, 100)

    XCTAssertTrue(r.insetBy(dx: 10, dy: 10) == Rect(cr.insetBy(dx:10, dy:10)))
    XCTAssertTrue(r.insetBy(dx: -20, dy: 0) == Rect(cr.insetBy(dx: -20, dy: 0)))
    XCTAssertTrue(r.insetBy(dx: -20, dy: -20) == Rect(cr.insetBy(dx: -20, dy: -20)))
  }
  
  func testEdgeInset() {
    let r = Rect(0, 0, 100, 100)
    XCTAssertEqual(r.insetBy(EdgeInsets(10, 20, -10, -20)), Rect(20, 10, 100, 100))
  }

  func testCGRect() {
    let r = Rect(0, 0, 100, 100)
    let cr = CGRectMake(0, 0, 100, 100)

    XCTAssertTrue(r == Rect(cr))
    XCTAssertTrue(CGRect(r) == cr)

    let cr2 = CGRectMake(0.1, 0, 100, 100)

    XCTAssertTrue(r != Rect(cr2))
    XCTAssertTrue(CGRect(r) != cr2)
}

  func testStandardize() {
    func r() -> Float {
      var r = drand48() * 100
      if Int(r) % 2 == 0 {
        r = -r
      }
      return Float(r)
    }
    for _ in 0..<100 {
      var rect = Rect(r(), r(), r(), r())
      var crect = CGRect(rect)
      XCTAssertEqual(rect, Rect(crect))

      rect.standardizeInPlace()
      crect.standardizeInPlace()
      XCTAssertEqual(rect, Rect(crect), "Standardize")
    }
  }

  func testIntegral() {
    func r() -> Float {
      var r = drand48() * 100
      if Int(r) % 2 == 0 {
        r = -r
      }
      return Float(r)
    }
    for _ in 0..<100 {
      var rect = Rect(r(), r(), r(), r())
      var crect = CGRect(rect)
      XCTAssertEqual(rect, Rect(crect))

      rect.makeIntegralInPlace()
      crect.makeIntegralInPlace()
      XCTAssertEqual(rect, Rect(crect))
    }
  }

}
