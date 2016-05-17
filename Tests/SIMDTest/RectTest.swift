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

    XCTAssertTrue(r.insetted(dx: 10, dy: 10) == Rect(cr.insetBy(dx:10, dy:10)))
    XCTAssertTrue(r.insetted(dx: -20, dy: 0) == Rect(cr.insetBy(dx: -20, dy: 0)))
    XCTAssertTrue(r.insetted(dx: -20, dy: -20) == Rect(cr.insetBy(dx: -20, dy: -20)))
  }
  
  func testEdgeInset() {
    let r = Rect(0, 0, 100, 100)
    XCTAssertEqual(r.insetted(EdgeInsets(10, 20, -10, -20)), Rect(20, 10, 100, 100))
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

      rect.standardize()
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

      rect.formIntegral()
      crect.makeIntegralInPlace()
      XCTAssertEqual(rect, Rect(crect))
    }
  }

  func testUnion() {
    func r() -> Float {
      var r = drand48() * 100
      if Int(r) % 2 == 0 {
        r = -r
      }
      return Float(r)
    }
    var prev = Rect.null
    var cprev = CGRect.null

    for _ in 0..<100 {
      let rect = Rect(r(), r(), r(), r())
      let crect = CGRect(rect)
      XCTAssertEqual(rect, Rect(crect))

      let u = rect.union(prev)
      let cu = crect.union(cprev)
      XCTAssertEqual(u, Rect(cu))

      var r2 = rect
      var cr2 = crect

      r2.formUnion(prev)
      cr2.unionInPlace(cprev)
      XCTAssertEqual(r2, Rect(cr2))

      prev = rect
      cprev = crect
    }
  }

  func testUnionAgainstNull() {
    let r = Rect.null
    XCTAssertTrue(r.union(r) == r)

    let r1 = Rect(0, 0, 100, 100)
    XCTAssertTrue(r.union(r1) == r1)

    let r2 = Rect()
    XCTAssertTrue(r.union(r2) == r2)

  }

}
