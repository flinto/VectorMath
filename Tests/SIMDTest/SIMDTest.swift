//
//  SIMDTest.swift
//  SIMDTest
//
//  Created by Nick Lockwood on 24/11/2014.
//  Copyright (c) 2014 Nick Lockwood. All rights reserved.
//

import QuartzCore
import XCTest
import CPUVector

class SIMDMatrixTests: XCTestCase {

  func testScale() {

    let transform = CATransform3DMakeScale(0.3, 0.4, 0.5)
    let matrix = Matrix(transform)
    let compare = Matrix(scale: Vector(0.3, 0.4, 0.5, 1))

    XCTAssertTrue(matrix ~== compare)
  }

  func testTranslation() {

    let transform = CATransform3DMakeTranslation(0.3, 0.4, 0.5)
    let matrix = Matrix(transform)
    let compare = Matrix(translation: Vector(0.3, 0.4, 0.5, 1))

    XCTAssertTrue(matrix ~== compare)
  }

  func testRotation() {

    let transform = CATransform3DMakeRotation(CGFloat(M_PI_2), 1, 0, 0)
    let matrix = Matrix(transform)
    let compare = Matrix(rotation: Vector(1, 0, 0, .HalfPi))

    XCTAssertTrue(matrix ~== compare)
  }

  func testRotationAndTranslation() {
    let point = Vector(0.0, -1.0, 0.0, 1.0);
    let euclideanTransformation = Matrix(0.0, 1.0, 0.0, 0.0,
                                          -1.0, 0.0, 0.0, 0.0,
                                          0.0, 0.0, 0.0, 0.0,
                                          -1.0, 0.0, 0.0, 1.0);

    let result = euclideanTransformation * point;
    let expectedResult = Vector(0.0, 0.0, 0.0, 1.0);

    XCTAssertTrue(result ~= expectedResult);
  }


  func testTransformationMatrixMultiplication() {
    let somePoint = Vector(2.0, 2.0, 2.0, 1.0);
    let zAxisTransformationMaxtrix90Positive = Matrix(0.0, 1.0, 0.0, 0.0,
                                                       -1.0, 0.0, 0.0, 0.0,
                                                       0.0, 0.0, 0.0, 0.0,
                                                       0.0, 0.0, 0.0, 1.0);
    let yAxisTransformationMaxtrix90Positive = Matrix(0.0, 0.0, 1.0, 0.0,
                                                       0.0, 1.0, 0.0, 0.0,
                                                       -1.0, 0.0, 0.0, 0.0,
                                                       0.0, 0.0, 0.0, 1.0);
    let xAxisTransformationMaxtrix90Positive = Matrix(1.0, 0.0, 0.0, 0.0,
                                                       0.0, 0.0, -1.0, 0.0,
                                                       0.0, 1.0, 0.0, 0.0,
                                                       0.0, 0.0, 0.0, 1.0);

    let resultPoint = (xAxisTransformationMaxtrix90Positive * (yAxisTransformationMaxtrix90Positive * (zAxisTransformationMaxtrix90Positive * somePoint)));

    let comparePoint = (xAxisTransformationMaxtrix90Positive * yAxisTransformationMaxtrix90Positive * zAxisTransformationMaxtrix90Positive) * somePoint;

    XCTAssertTrue(resultPoint ~= comparePoint);
  }

//  func testDecompose() {
//
//    var mt = CATransform3DMakeRotation(90 * CPUVector.Scalar.RadiansPerDegree, 0, 0, 1)
//    mt = CATransform3DScale(mt, 1, 5.5, 3)
//    mt = CATransform3DTranslate(mt, 1, 0, 3)
//    //        let mt = CATransform3DIdentity.rotate(vector: Vector(0, 0, 90)).scale(1, 5.5, 3).translate(1, 0, 3)
//    let m = Matrix(mt)
//    let (t, r, s) = m.decompose()
//    XCTAssert(t.x == 0, "\(t.x) == 1")
//    XCTAssert(t.y == 1, "\(t.y) == 0")
//    XCTAssert(t.z == 9, "\(t.z) == 3")
//
//    XCTAssert(s.x == 1,   "\(s.x) == 0")
//    XCTAssert(s.y == 5.5, "\(s.y) == 1.5")
//    XCTAssert(s.z == 3,   "\(s.z) == 1")
//
//    print(r)
//    XCTAssertEqualWithAccuracy(r.pitch, 0, accuracy:0.00001, "\(r.pitch) == 0")
//    XCTAssertEqualWithAccuracy(r.yaw,   0, accuracy:0.00001, "\(r.yaw) == 1.5")
//    XCTAssertEqualWithAccuracy(r.roll, -Float.Pi/2, accuracy:0.00001,  "\(r.roll) == \(Float.Pi/2)")
//  }

  func testTRS() {
    let r = Vector(30, 0, 90, 0)
    let s = Vector(1, 5.5, 3, 1)
    let t = Vector(1, 0, 3, 1)
    var ct = CATransform3DMakeRotation(30 * CPUVector.Scalar.RadiansPerDegree, 1, 0, 0)
    ct = CATransform3DRotate(ct, 90 * CPUVector.Scalar.RadiansPerDegree, 0, 0, 1)
    ct = CATransform3DScale(ct, 1, 5.5, 3)
    ct = CATransform3DTranslate(ct, 1, 0, 3)
    //        var ct = CATransform3DIdentity.rotate(vector: r).scale(vector:s).translate(vector:t)
    var m = Matrix(ct)

    var mm = Matrix.identity.rotate(r * Scalar.RadiansPerDegree).scale(s).translate(t)
    XCTAssertTrue(m ~== mm, "\(m) != \(mm)")

    ct = CATransform3DMakeTranslation(1, 0, 3)
    ct = CATransform3DRotate(ct, 30 * CPUVector.Scalar.RadiansPerDegree, 1, 0, 0)
    ct = CATransform3DRotate(ct, 90 * CPUVector.Scalar.RadiansPerDegree, 0, 0, 1)
    ct = CATransform3DScale(ct, 1, 5.5, 3)
    //        ct = CATransform3DIdentity.translate(vector: t).rotate(vector: r).scale(vector: s)
    m = Matrix(ct)
    mm = Matrix.identity.translate(t).rotate(r * Scalar.RadiansPerDegree).scale(s)
    XCTAssertTrue(m ~== mm, "\(m) != \(mm)")

    ct = CATransform3DMakeTranslation(-1, 0, -3)
    ct = CATransform3DRotate(ct, -30 * CPUVector.Scalar.RadiansPerDegree, 1, 0, 0)
    ct = CATransform3DRotate(ct, -90 * CPUVector.Scalar.RadiansPerDegree, 0, 0, 1)
    ct = CATransform3DScale(ct, -1, -5.5, -3)
    //        ct = CATransform3DIdentity.translate(vector: -t).rotate(vector: -r).scale(vector: -s)
    m = Matrix(ct)
    mm = Matrix.identity.translate(-t).rotate(-r * Scalar.RadiansPerDegree).scale(-s)
    print(m.description)
    print(mm.description)
    XCTAssertTrue(m ~== mm, "\(m) != \(mm)")


  }
}

class SIMDQuaternionTests: XCTestCase {

  func testAxisAngleConversion() {

    let aaa = Vector(1, 0, 0, .HalfPi)
    let q = Quaternion( aaa)
    let aab = q.toAxisAngle()

    XCTAssertTrue(aaa ~= aab)
  }

//  func testVectorMultiplication() {
//
//    let q = Quaternion(Vector(0, 0, 1, .HalfPi))
//    let a = Vector(1, 0, 1, 0)
//    let b = Vector(0, 1, 1, 0)
//    let c = a * q
//
//    XCTAssertTrue(b ~= c)
//  }

//  func testWithRotationMatrix() {
//    let m = Matrix(rotation:Vector(0, 0, -180, 1))
//    let q = Quaternion(rotationMatrix:m)
//    XCTAssertEqual(q.x, 0)
//    XCTAssertEqual(q.y, 0)
//    XCTAssertEqual(q.z, 1)
//    XCTAssert(q.w ~= 0)
//  }
}

class SIMDPerformanceTests: XCTestCase {

  func testMatrix3MultiplicationPerformance() {

    let a = Matrix3(rotation: .HalfPi)
    var b = Matrix3(translation: Vector2(1, 10))

    measureBlock {
      for _ in 0 ..< 100000 {
        b = a * b
      }
    }
  }

  func testMatrixMultiplicationPerformance() {

    let a = Matrix(rotation: Vector(1, 0, 0, .HalfPi))
    var b = Matrix(translation: Vector(1, 10, 24, 0))

    measureBlock {
      for _ in 0 ..< 100000 {
        b = a * b
      }
    }
  }
}