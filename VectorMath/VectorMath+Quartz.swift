//
//  VectorMath+Quartz.swift
//  VectorMath
//
//  Version 0.1
//
//  Created by Nick Lockwood on 24/11/2014.
//  Copyright (c) 2014 Nick Lockwood. All rights reserved.
//
//  Distributed under the permissive zlib License
//  Get the latest version from here:
//
//  https://github.com/nicklockwood/VectorMath
//
//  This software is provided 'as-is', without any express or implied
//  warranty.  In no event will the authors be held liable for any damages
//  arising from the use of this software.
//
//  Permission is granted to anyone to use this software for any purpose,
//  including commercial applications, and to alter it and redistribute it
//  freely, subject to the following restrictions:
//
//  1. The origin of this software must not be misrepresented; you must not
//  claim that you wrote the original software. If you use this software
//  in a product, an acknowledgment in the product documentation would be
//  appreciated but is not required.
//
//  2. Altered source versions must be plainly marked as such, and must not be
//  misrepresented as being the original software.
//
//  3. This notice may not be removed or altered from any source distribution.
//

import QuartzCore

//MARK: SceneKit extensions

extension CGPoint {
    
    public init(_ v: Vector2) {
        self.init(x: CGFloat(v.x), y: CGFloat(v.y))
    }
}

extension CGSize {
    
    public init(_ v: Vector2) {
        self.init(width: CGFloat(v.x), height: CGFloat(v.y))
    }
}

extension CGVector {
    
    public init(_ v: Vector2) {
        self.init(dx: CGFloat(v.x), dy: CGFloat(v.y))
    }
}

extension CGAffineTransform {
    
    public init(_ m: Matrix3) {
        
        self.init(
            a: CGFloat(m.m11), b: CGFloat(m.m12),
            c: CGFloat(m.m21), d: CGFloat(m.m22),
            tx: CGFloat(m.m31), ty: CGFloat(m.m32)
        )
    }
}

extension CATransform3D {
    
    public init(_ m: Matrix4) {
        
        self.init(
            m11: CGFloat(m.m11), m12: CGFloat(m.m12), m13: CGFloat(m.m13), m14: CGFloat(m.m14),
            m21: CGFloat(m.m21), m22: CGFloat(m.m22), m23: CGFloat(m.m23), m24: CGFloat(m.m24),
            m31: CGFloat(m.m31), m32: CGFloat(m.m32), m33: CGFloat(m.m33), m34: CGFloat(m.m34),
            m41: CGFloat(m.m41), m42: CGFloat(m.m42), m43: CGFloat(m.m43), m44: CGFloat(m.m44)
        )
    }
}

//MARK: VectorMath extensions

extension Vector2 {
    
    public init(_ v: CGPoint) {
        self.init(x: Scalar(v.x), y: Scalar(v.y))
    }
    
    public init(_ v: CGSize) {
        self.init(x: Scalar(v.width), y: Scalar(v.height))
    }
    
    public init(_ v: CGVector) {
        self.init(x: Scalar(v.dx), y: Scalar(v.dy))
    }
}

extension Vector3 {
    public init(_ point:CGPoint) {
        self.x = point.x
        self.y = point.y
        self.z = 0
    }

    public init(_ size:CGSize) {
        self.x = size.width
        self.y = size.height
        self.z = 0
    }

    public func toPoint() -> CGPoint {
        return CGPointMake(x, y)
    }
}

extension Matrix3 {
    
    public init(_ m: CGAffineTransform) {
        
        self.init(
            m11: Scalar(m.a), m12: Scalar(m.b), m13: 0,
            m21: Scalar(m.c), m22: Scalar(m.d), m23: 0,
            m31: Scalar(m.tx), m32: Scalar(m.ty), m33: 1
        )
    }

}

extension Matrix4 {
    
    public init(_ m: CATransform3D) {
        
        self.init(
            m11: Scalar(m.m11), m12: Scalar(m.m12), m13: Scalar(m.m13), m14: Scalar(m.m14),
            m21: Scalar(m.m21), m22: Scalar(m.m22), m23: Scalar(m.m23), m24: Scalar(m.m24),
            m31: Scalar(m.m31), m32: Scalar(m.m32), m33: Scalar(m.m33), m34: Scalar(m.m34),
            m41: Scalar(m.m41), m42: Scalar(m.m42), m43: Scalar(m.m43), m44: Scalar(m.m44)
        )
    }
}

func + (lhs:Vector3, rhs:CGPoint) -> Vector3 { return lhs + Vector3(rhs) }
func - (lhs:Vector3, rhs:CGPoint) -> Vector3 { return lhs - Vector3(rhs) }
func += (inout lhs:Vector3, rhs:CGPoint)     { lhs += Vector3(rhs)}
func -= (inout lhs:Vector3, rhs:CGPoint)     { lhs -= Vector3(rhs)}

//func + (lhs:CGPoint, rhs:Vector3) -> CGPoint { return lhs + rhs.toPoint() }
//func - (lhs:CGPoint, rhs:Vector3) -> CGPoint { return lhs - rhs.toPoint() }
//func += (inout lhs:CGPoint, rhs:Vector3)     { lhs += rhs.toPoint()}
//func -= (inout lhs:CGPoint, rhs:Vector3)     { lhs -= rhs.toPoint()}

func * (lhs:Vector3, rhs:CGSize) ->Vector3  { return Vector3(x: lhs.x * rhs.width, y: lhs.y * rhs.height, z:lhs.z) }
func / (lhs:Vector3, rhs:CGSize) ->Vector3  { return Vector3(x: lhs.x / rhs.width, y: lhs.y / rhs.height, z:lhs.z) }
func * (lhs:Vector3, rhs:CGPoint) ->Vector3 { return Vector3(x: lhs.x * rhs.x, y: lhs.y * rhs.y, z:lhs.z) }
func / (lhs:Vector3, rhs:CGPoint) ->Vector3 { return Vector3(x: lhs.x / rhs.x, y: lhs.y / rhs.y, z:lhs.z) }

func *= (inout lhs:Vector3, rhs:CGSize)  { lhs.x *= rhs.width; lhs.y *= rhs.height }
func /= (inout lhs:Vector3, rhs:CGSize)  { lhs.x /= rhs.width; lhs.y /= rhs.height }
func *= (inout lhs:Vector3, rhs:CGPoint) { lhs.x *= rhs.x; lhs.y *= rhs.y }
func /= (inout lhs:Vector3, rhs:CGPoint) { lhs.x /= rhs.x; lhs.y /= rhs.y }


func * (lhs:CGSize, rhs:Vector3) ->CGSize   { return CGSizeMake(lhs.width * rhs.x, lhs.height * rhs.y) }
func / (lhs:CGSize, rhs:Vector3) ->CGSize   { return CGSizeMake(lhs.width / rhs.x, lhs.height / rhs.y) }
func * (lhs:CGPoint, rhs:Vector3) ->CGPoint { return CGPointMake(lhs.x * rhs.x, lhs.y * rhs.y) }
func / (lhs:CGPoint, rhs:Vector3) ->CGPoint { return CGPointMake(lhs.x / rhs.x, lhs.y / rhs.y) }

func *= (inout lhs:CGSize, rhs:Vector3)  { lhs.width *= rhs.x; lhs.height *= rhs.y }
func /= (inout lhs:CGSize, rhs:Vector3)  { lhs.width /= rhs.x; lhs.height /= rhs.y }
func *= (inout lhs:CGPoint, rhs:Vector3) { lhs.x *= rhs.x; lhs.y *= rhs.y }
func /= (inout lhs:CGPoint, rhs:Vector3) { lhs.x /= rhs.x; lhs.y /= rhs.y }





