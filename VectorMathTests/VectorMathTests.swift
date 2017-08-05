//
//  VectorMathTests.swift
//  VectorMathTests
//
//  Created by Nick Lockwood on 24/11/2014.
//  Copyright (c) 2014 Nick Lockwood. All rights reserved.
//

import QuartzCore
import XCTest
@testable import VectorMath

class Vector2Tests: XCTestCase {
    
    func testRotatedBy() {
        
        let a = Vector2(1, 0)
        let b = Vector2(0, 1)
        let c = a.rotatedBy(.halfPi)

        XCTAssertTrue(b ~== c)
        
        let d = Vector2(0.5, 1.5)
        let e = a.rotatedBy(.halfPi, around: Vector2(0, 0.5))

        XCTAssertTrue(d ~== e)
    }
    
    func testAngleWith() {
        
        let a = Vector2(1, 0)
        let b = Vector2(0, 1)
        let angle = a.angle(with:b)
        
        XCTAssertTrue(angle ~== .halfPi)
    }
}

class Vector3Tests : XCTestCase {

    func testIsRightAngle() {
        func testIsZeroAngle() {
            var v = Vector3(x:0, y:0, z:0)
            XCTAssertTrue(v.isZeroAngle)

            v = Vector3(x:.pi, y:0, z:0)
            XCTAssertFalse(v.isZeroAngle)

            v = Vector3(x:.twoPi, y:0, z:0)
            XCTAssertTrue(v.isZeroAngle)

            v = Vector3(x:360, y:0, z:0)
            XCTAssertFalse(v.isZeroAngle)

            v = Vector3(x:0, y:0, z:.pi)
            XCTAssertTrue(v.isZeroAngle)

            v = Vector3(x:0, y:0, z:.halfPi)
            XCTAssertTrue(v.isZeroAngle)

            v = Vector3(x:0, y:0, z:.twoPi)
            XCTAssertTrue(v.isZeroAngle)

            v = Vector3(x:.pi, y:0, z:.twoPi)
            XCTAssertFalse(v.isZeroAngle)
            
            v = Vector3(x:.twoPi, y:0, z:.twoPi * 2)
            XCTAssertTrue(v.isZeroAngle)
        }
    }

    func testIsZeroAngle() {
        var v = Vector3(x:0, y:0, z:0)
        XCTAssertTrue(v.isZeroAngle)

        v = Vector3(x:.pi, y:0, z:0)
        XCTAssertFalse(v.isZeroAngle)

        v = Vector3(x:.twoPi, y:0, z:0)
        XCTAssertTrue(v.isZeroAngle)

        v = Vector3(x:360, y:0, z:0)
        XCTAssertFalse(v.isZeroAngle)

        v = Vector3(x:0, y:0, z:.pi)
        XCTAssertFalse(v.isZeroAngle)

        v = Vector3(x:0, y:0, z:.halfPi)
        XCTAssertFalse(v.isZeroAngle)

        v = Vector3(x:0, y:0, z:.twoPi)
        XCTAssertTrue(v.isZeroAngle)

        v = Vector3(x:.pi, y:0, z:.twoPi)
        XCTAssertFalse(v.isZeroAngle)

        v = Vector3(x:.twoPi, y:0, z:.twoPi * 2)
        XCTAssertTrue(v.isZeroAngle)

    }
}

class Matrix3Tests: XCTestCase {
    
    func testScale() {
        
        let transform = CGAffineTransform(scaleX: 0.3, y: 0.4)
        let matrix = Matrix3(transform)
        let compare = Matrix3(scale: Vector2(0.3, 0.4))
        
        XCTAssertTrue(matrix ~== compare)
    }
    
    func testTranslation() {
        
        let transform = CGAffineTransform(translationX: 0.3, y: 0.4)
        let matrix = Matrix3(transform)
        let compare = Matrix3(translation: Vector2(0.3, 0.4))
        
        XCTAssertTrue(matrix ~== compare)
    }

    func testRotation() {
        
        let transform = CGAffineTransform(rotationAngle: CGFloat.pi / 2)
        let matrix = Matrix3(transform)
        let compare = Matrix3(rotation: .halfPi)
        
        XCTAssertTrue(matrix ~== compare)
    }
    
    func testMatrix3Multiplication() {
        
        let a = Matrix3(rotation: .halfPi)
        let b = Matrix3(rotation: .quarterPi)
        let c = Matrix3(rotation: .halfPi + .quarterPi)
        let d = a * b
        
        XCTAssertTrue(c ~== d)
    }
    
    func testVector3Multiplication() {
        
        let m = Matrix3(rotation: .halfPi)
        let a = Vector3(1, 0, 1)
        let b = Vector3(0, 1, 1)
        let c = a * m
        
        XCTAssertTrue(b ~== c)
    }

    func testVector2Multiplication() {
        
        let m = Matrix3(rotation: .halfPi)
        let a = Vector2(1, 0)
        let b = Vector2(0, 1)
        let c = a * m
        
        XCTAssertTrue(b ~== c)
    }
}

class Matrix4Tests: XCTestCase {
    
    func testScale() {
        
        let transform = CATransform3DMakeScale(0.3, 0.4, 0.5)
        let matrix = Matrix4(transform)
        let compare = Matrix4(scale: Vector3(0.3, 0.4, 0.5))
        
        XCTAssertTrue(matrix ~== compare)
    }
    
    func testTranslation() {
        
        let transform = CATransform3DMakeTranslation(0.3, 0.4, 0.5)
        let matrix = Matrix4(transform)
        let compare = Matrix4(translation: Vector3(0.3, 0.4, 0.5))
        
        XCTAssertTrue(matrix ~== compare)
    }
    
    func testRotation() {
        
        let transform = CATransform3DMakeRotation(CGFloat.pi / 2, 1, 0, 0)
        let matrix = Matrix4(transform)
        let compare = Matrix4(rotation: Vector4(1, 0, 0, .halfPi))
        
        XCTAssertTrue(matrix ~== compare)
    }
    
    func testRotationAndTranslation() {
        let point = Vector4(0.0, -1.0, 0.0, 1.0);
        let euclideanTransformation = Matrix4(0.0, 1.0, 0.0, 0.0,
            -1.0, 0.0, 0.0, 0.0,
            0.0, 0.0, 0.0, 0.0,
            -1.0, 0.0, 0.0, 1.0);
        
        let result = euclideanTransformation * point;
        let expectedResult = Vector4(0.0, 0.0, 0.0, 1.0);
        
        XCTAssertTrue(result ~== expectedResult);
    }
    
    
    func testTransformationMatrixMultiplication() {
        let somePoint = Vector4(2.0, 2.0, 2.0, 1.0);
        let zAxisTransformationMaxtrix90Positive = Matrix4(0.0, 1.0, 0.0, 0.0,
            -1.0, 0.0, 0.0, 0.0,
            0.0, 0.0, 0.0, 0.0,
            0.0, 0.0, 0.0, 1.0);
        let yAxisTransformationMaxtrix90Positive = Matrix4(0.0, 0.0, 1.0, 0.0,
            0.0, 1.0, 0.0, 0.0,
            -1.0, 0.0, 0.0, 0.0,
            0.0, 0.0, 0.0, 1.0);
        let xAxisTransformationMaxtrix90Positive = Matrix4(1.0, 0.0, 0.0, 0.0,
            0.0, 0.0, -1.0, 0.0,
            0.0, 1.0, 0.0, 0.0,
            0.0, 0.0, 0.0, 1.0);
        
        let resultPoint = (xAxisTransformationMaxtrix90Positive * (yAxisTransformationMaxtrix90Positive * (zAxisTransformationMaxtrix90Positive * somePoint)));
        
        let comparePoint = (xAxisTransformationMaxtrix90Positive * yAxisTransformationMaxtrix90Positive * zAxisTransformationMaxtrix90Positive) * somePoint;
        
        XCTAssertTrue(resultPoint ~== comparePoint);
    }

//    func testDecompose() {
//
//        let mt = CATransform3DIdentity.rotate(Vector3(0, 0, 90 * Scalar.radiansPerDegree)).scale(1, 5.5, 3).translate(1, 0, 3)
//        let m = Matrix4(mt)
//        let (t, r, s) = m
//            .decompose()
//        XCTAssert(t.x == 0, "\(t.x) == 1")
//        XCTAssert(t.y == 1, "\(t.y) == 0")
//        XCTAssert(t.z == 9, "\(t.z) == 3")
//
//        XCTAssert(s.x == 1,   "\(s.x) == 0")
//        XCTAssert(s.y == 5.5, "\(s.y) == 1.5")
//        XCTAssert(s.z == 3,   "\(s.z) == 1")
//
//        print(r)
//        XCTAssertEqualWithAccuracy(r.pitch, 0, accuracy:0.00001, "\(r.pitch) == 0")
//        XCTAssertEqualWithAccuracy(r.yaw,   0, accuracy:0.00001, "\(r.yaw) == 1.5")
//        XCTAssertEqualWithAccuracy(r.roll, -Scalar.pi/2, accuracy:0.00001,  "\(r.roll) == \(Scalar.pi/2)")
//    }
//
//    func testTRS() {
//        let r = Vector3(30, 0, 90)
//        let s = Vector3(1, 5.5, 3)
//        let t = Vector3(1, 0, 3)
//        var ct = CATransform3DIdentity.rotate(r).scale(s).translate(t)
//        var m = Matrix4(ct)
//
//        var mm = Matrix4.identity.rotate(r).scale(s).translate(t)
//        XCTAssertTrue(m ~== mm, "\(m) != \(mm)")
//
//        ct = CATransform3DIdentity.translate(t).rotate(r).scale(s)
//        m = Matrix4(ct)
//        mm = Matrix4.identity.translate(t).rotate(r).scale(s)
//        XCTAssertTrue(m ~== mm, "\(m) != \(mm)")
//
//        ct = CATransform3DIdentity.translate(-t).rotate(-r).scale(-s)
//        m = Matrix4(ct)
//        mm = Matrix4.identity.translate(-t).rotate(-r).scale(-s)
//        XCTAssertTrue(m ~== mm, "\(m) != \(mm)")
//
//
//    }
//
//    func testConcat() {
//        let r = Vector3(30, 0, 90)
//        let s = Vector3(1, 5.5, 3)
//        let t = Vector3(1, 0, 3)
//        let ct = CATransform3DIdentity.rotate(r).scale(s).translate(t)
//        let m = Matrix4(ct)
//
//        let r1 = Vector3(0, -20, 0)
//        let s1 = Vector3(2, 10.5, 0)
//        let t1 = Vector3(0, 0, 0)
//        let ct1 = CATransform3DIdentity.rotate(r1).scale(s1).translate(t1)
//        let m1 = Matrix4(ct1)
//
//        let con1 = CATransform3DConcat(ct, ct1)
//        let con2 = m1 * m
//        XCTAssertTrue(Matrix4(con1) == con2)
//        XCTAssertTrue(CATransform3DEqualToTransform(con1, CATransform3D(con2)))
//        let con3 = m * m1
//        XCTAssertFalse(Matrix4(con1) == con3)
//        XCTAssertFalse(CATransform3DEqualToTransform(con1, CATransform3D(con3)))
//    }

}

class QuaternionTests: XCTestCase {
    
    func testAxisAngleConversion() {
        
        let aaa = Vector4(1, 0, 0, .halfPi)
        let q = Quaternion(axisAngle: aaa)
        let aab = q.toAxisAngle()
        
        XCTAssertTrue(aaa ~== aab)
    }

    func testVector3Multiplication() {
        
        let q = Quaternion(axisAngle: Vector4(0, 0, 1, .halfPi))
        let a = Vector3(1, 0, 1)
        let b = Vector3(0, 1, 1)
        let c = a * q
        
        XCTAssertTrue(b ~== c)
    }

    func testWithRotationMatrix() {
        let m = Matrix4.identity.rotate(Vector3(0, 0, -Scalar.pi))
        let q = Quaternion(rotationMatrix:m)
        XCTAssertEqual(q.x, 0)
        XCTAssertEqual(q.y, 0)
        XCTAssertEqual(q.z, 1)
        XCTAssert(q.w ~== 0)
    }


    func testEulerConversion() {

        var quat = Quaternion(pitch: Scalar.quarterPi, yaw: 0, roll: 0)
        XCTAssertTrue(quat.pitch ~== Scalar.quarterPi)
        quat = Quaternion(pitch: 0, yaw: Scalar.quarterPi, roll: 0)
        XCTAssertTrue(quat.yaw ~== Scalar.quarterPi)
        quat = Quaternion(pitch: 0, yaw: 0, roll: Scalar.quarterPi)
        XCTAssertTrue(quat.roll ~== Scalar.quarterPi)

        quat = Quaternion(pitch: 0.12334412, yaw: 1.3521468, roll: -0.53435323)
        let (pitch, yaw, roll) = quat.toPitchYawRoll()
        let quat2Ref = Quaternion(pitch: pitch, yaw: yaw, roll: roll)
        XCTAssertTrue(quat ~== quat2Ref)
    }

    func testMatrix4Conversion() {

        let quat = Quaternion(rotationMatrix: Matrix4.identity)
        let matr = Matrix4(quaternion: quat)
        XCTAssertTrue(matr ~= .identity)
    }
}

class PerformanceTests: XCTestCase {

    func testMatrix3MultiplicationPerformance() {
        
        let a = Matrix3(rotation: .halfPi)
        var b = Matrix3(translation: Vector2(1, 10))
        
        measure {
            for _ in 0 ..< 100000 {
                b = a * b
            }
        }
    }
    
    func testMatrix4MultiplicationPerformance() {
        
        let a = Matrix4(rotation: Vector4(1, 0, 0, .halfPi))
        var b = Matrix4(translation: Vector3(1, 10, 24))
        
        measure {
            for _ in 0 ..< 100000 {
                b = a * b
            }
        }
    }
}
