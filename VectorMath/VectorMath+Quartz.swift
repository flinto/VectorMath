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
    
    @inline(__always) public init(_ v: Vector2) {
        self.init(x: CGFloat(v.x), y: CGFloat(v.y))
    }

    @inline(__always) public init(_ v: Vector3) {
        self.init(x: CGFloat(v.x), y: CGFloat(v.y))
    }
}

extension CGSize {
    
    @inline(__always) public init(_ v: Vector2) {
        self.init(width: CGFloat(v.x), height: CGFloat(v.y))
    }
}

extension CGVector {
    
    @inline(__always) public init(_ v: Vector2) {
        self.init(dx: CGFloat(v.x), dy: CGFloat(v.y))
    }
}

extension CGAffineTransform {
    
    @inline(__always) public init(_ m: Matrix3) {
        
        self.init(
            a: CGFloat(m.m11), b: CGFloat(m.m12),
            c: CGFloat(m.m21), d: CGFloat(m.m22),
            tx: CGFloat(m.m31), ty: CGFloat(m.m32)
        )
    }
}

extension CATransform3D {
    
    @inline(__always) public init(_ m: Matrix4) {
        
        self.init(
            m11: m.m11, m12: m.m12, m13: m.m13, m14: m.m14,
            m21: m.m21, m22: m.m22, m23: m.m23, m24: m.m24,
            m31: m.m31, m32: m.m32, m33: m.m33, m34: m.m34,
            m41: m.m41, m42: m.m42, m43: m.m43, m44: m.m44
        )
    }
}

//MARK: VectorMath extensions

extension Vector2 {
    
    @inline(__always) public init(_ v: CGPoint) {
        self.init(x: v.x, y: v.y)
    }
    
    @inline(__always) public init(_ v: CGSize) {
        self.init(x: v.width, y: v.height)
    }
    
    @inline(__always) public init(_ v: CGVector) {
        self.init(x: v.dx, y: v.dy)
    }
}

extension Vector3 {
    @inline(__always) public init(_ point:CGPoint) {
        self.x = point.x
        self.y = point.y
        self.z = 0
    }

    @inline(__always) public init(_ size:CGSize) {
        self.x = size.width
        self.y = size.height
        self.z = 1
    }
}

extension Matrix3 {
    
    public init(_ m: CGAffineTransform) {
        
        self.init(
            m11: m.a, m12: m.b, m13: 0,
            m21: m.c, m22: m.d, m23: 0,
            m31: m.tx, m32: m.ty, m33: 1
        )
    }

}

extension Matrix4 {
    
    public init(_ m: CATransform3D) {
        
        self.init(
            m11: m.m11, m12: m.m12, m13: m.m13, m14: m.m14,
            m21: m.m21, m22: m.m22, m23: m.m23, m24: m.m24,
            m31: m.m31, m32: m.m32, m33: m.m33, m34: m.m34,
            m41: m.m41, m42: m.m42, m43: m.m43, m44: m.m44
        )
    }
}

@inline(__always) public func + (lhs:Vector3, rhs:CGPoint) -> Vector3 { return lhs + Vector3(rhs) }
@inline(__always) public func - (lhs:Vector3, rhs:CGPoint) -> Vector3 { return lhs - Vector3(rhs) }
@inline(__always) public func += (lhs:inout Vector3, rhs:CGPoint)     { lhs += Vector3(rhs)}
@inline(__always) public func -= (lhs:inout Vector3, rhs:CGPoint)     { lhs -= Vector3(rhs)}

//public func + (lhs:CGPoint, rhs:Vector3) -> CGPoint { return lhs + CGPoint(rhs) }
//public func - (lhs:CGPoint, rhs:Vector3) -> CGPoint { return lhs - CGPoint(rhs) }
//public func += (lhs:inout CGPoint, rhs:Vector3)     { lhs += CGPoint(rhs)}
//public func -= (lhs:inout CGPoint, rhs:Vector3)     { lhs -= CGPoint(rhs)}

@inline(__always) public func * (lhs:Vector3, rhs:CGSize) ->Vector3  { return Vector3(x: lhs.x * rhs.width, y: lhs.y * rhs.height, z:lhs.z) }
@inline(__always) public func / (lhs:Vector3, rhs:CGSize) ->Vector3  { return Vector3(x: lhs.x / rhs.width, y: lhs.y / rhs.height, z:lhs.z) }
@inline(__always) public func * (lhs:Vector3, rhs:CGPoint) ->Vector3 { return Vector3(x: lhs.x * rhs.x, y: lhs.y * rhs.y, z:lhs.z) }
@inline(__always) public func / (lhs:Vector3, rhs:CGPoint) ->Vector3 { return Vector3(x: lhs.x / rhs.x, y: lhs.y / rhs.y, z:lhs.z) }

@inline(__always) public func *= (lhs:inout Vector3, rhs:CGSize)  { lhs.x *= rhs.width; lhs.y *= rhs.height }
@inline(__always) public func /= (lhs:inout Vector3, rhs:CGSize)  { lhs.x /= rhs.width; lhs.y /= rhs.height }
@inline(__always) public func *= (lhs:inout Vector3, rhs:CGPoint) { lhs.x *= rhs.x; lhs.y *= rhs.y }
@inline(__always) public func /= (lhs:inout Vector3, rhs:CGPoint) { lhs.x /= rhs.x; lhs.y /= rhs.y }


@inline(__always) public func * (lhs:CGSize, rhs:Vector3) ->CGSize   { return CGSize(width: lhs.width * rhs.x, height: lhs.height * rhs.y) }
@inline(__always) public func / (lhs:CGSize, rhs:Vector3) ->CGSize   { return CGSize(width: lhs.width / rhs.x, height: lhs.height / rhs.y) }
@inline(__always) public func * (lhs:CGPoint, rhs:Vector3) ->CGPoint { return CGPoint(x: lhs.x * rhs.x, y: lhs.y * rhs.y) }
@inline(__always) public func / (lhs:CGPoint, rhs:Vector3) ->CGPoint { return CGPoint(x: lhs.x / rhs.x, y: lhs.y / rhs.y) }

@inline(__always) public func *= (lhs:inout CGSize, rhs:Vector3)  { lhs.width *= rhs.x; lhs.height *= rhs.y }
@inline(__always) public func /= (lhs:inout CGSize, rhs:Vector3)  { lhs.width /= rhs.x; lhs.height /= rhs.y }
@inline(__always) public func *= (lhs:inout CGPoint, rhs:Vector3) { lhs.x *= rhs.x; lhs.y *= rhs.y }
@inline(__always) public func /= (lhs:inout CGPoint, rhs:Vector3) { lhs.x /= rhs.x; lhs.y /= rhs.y }





