
import Foundation
import QuartzCore
import simd


extension CGPoint {
  init(_ p:Point) {
    self.init(x:CGFloat(p.x), y:CGFloat(p.y))
  }

  init(_ v:Vector) {
    self.init(x:CGFloat(v.x), y:CGFloat(v.y))
  }
}

extension Point {
  init(_ p:CGPoint) {
    self.init(x:Float(p.x), y:Float(p.y))
  }
}


extension CGSize {
  init(_ s:Size) {
    self.init(width:CGFloat(s.width), height:CGFloat(s.height))
  }
}

extension Size {
  init(_ p:CGSize) {
    self.init(width:Float(p.width), height:Float(p.height))
  }
}

extension EdgeInsets {
  #if os(OSX)
  init(insets:NSEdgeInsets) {
    self.storage = float4(Float(insets.top), Float(insets.left), Float(insets.bottom), Float(insets.right))
  }
  #endif
}

extension CGRect {
  init(_ r:Rect) {
    self.init(origin:CGPoint(r.origin), size:CGSize(r.size))
  }
}

extension Rect {
  init(_ r:CGRect) {
    self.init(origin:Point(r.origin), size:Size(r.size))
  }
}

extension CATransform3D {
  init(_ m:Matrix) {
    m11 = CGFloat(m[0][0])
    m12 = CGFloat(m[0][1])
    m13 = CGFloat(m[0][2])
    m14 = CGFloat(m[0][3])
    m21 = CGFloat(m[1][0])
    m22 = CGFloat(m[1][1])
    m23 = CGFloat(m[1][2])
    m24 = CGFloat(m[1][3])
    m31 = CGFloat(m[2][0])
    m32 = CGFloat(m[2][1])
    m33 = CGFloat(m[2][2])
    m34 = CGFloat(m[2][3])
    m41 = CGFloat(m[3][0])
    m42 = CGFloat(m[3][1])
    m43 = CGFloat(m[3][2])
    m44 = CGFloat(m[3][3])
  }
}

extension Matrix {
  init(_ m:CATransform3D) {
    let c1 = float4(Float(m.m11), Float(m.m12), Float(m.m13), Float(m.m14))
    let c2 = float4(Float(m.m21), Float(m.m22), Float(m.m23), Float(m.m24))
    let c3 = float4(Float(m.m31), Float(m.m32), Float(m.m33), Float(m.m34))
    let c4 = float4(Float(m.m41), Float(m.m42), Float(m.m43), Float(m.m44))
    self.init([c1, c2, c3, c4])
  }
}