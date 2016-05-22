
import simd


struct Quaternion : Scalar4, CustomStringConvertible {

  var storage:scalar4

  static let zero = Quaternion(0, 0, 0, 0)
  static let identity = Quaternion(0, 0, 0, 1)

  init() {
    storage = scalar4()
  }

  init(_ q:Quaternion) {
    storage = q.storage
  }

  init(_ storage:scalar4) {
    self.storage = storage
  }

  init(_ axisAngle: Vector) {
    let r = axisAngle.w * 0.5
    let scale = sin(r)
    let a = axisAngle * scale
    self.init(a.x, a.y, a.z, cos(r))
  }

  var xyz:Vector {
    return Vector(x, y, z, 0)
  }

  @warn_unused_result
  func toAxisAngle() -> Vector {

    let scale = length(xyz.storage)
    if scale ~= 0 || scale ~= .TwoPi {
      return Vector.z
    } else {
      var scaled = storage / scalar4(scale)
      scaled.w = acos(w) * 2
      return Vector(scaled)
    }
  }

  var pitch: Float {
    let v = storage
    let d = v * v
    return atan2(2 * (v.y * v.z + v.w * v.x), d.w - d.x - d.y + d.z)
  }

  var yaw: Float {
    let v = storage
    return asin(-2 * (v.x * v.z - v.w * v.y))
  }

  var roll: Float {
    let v = storage
    let d = v * v
    return atan2(2 * (v.x * v.y + v.w * v.z), d.w + d.x - d.y - d.z)
  }

}

//public func ==(lhs:Quaternion, rhs:Quaternion) -> Bool { return float4_equal(lhs.v, rhs.v) }
//public func ~==(lhs:Quaternion, rhs:Quaternion) -> Bool { return float4_nearly_equal(lhs.v, rhs.v) }
//
//
//
//public prefix func -(q: Quaternion) -> Quaternion { return Quaternion(-q.v) }
//public func +(lhs: Quaternion, rhs: Quaternion) -> Quaternion { return Quaternion(lhs.v + rhs.v) }
//public func -(lhs: Quaternion, rhs: Quaternion) -> Quaternion { return Quaternion(lhs.v - rhs.v) }
//public func *(lhs: Quaternion, rhs: Quaternion) -> Quaternion { return Quaternion(lhs.v * rhs.v) }
//
//public func *(lhs: Quaternion, rhs: Vector) -> Vector { return Vector(lhs.v * rhs) }
//public func *(lhs: Quaternion, rhs: Float) -> Quaternion { return Quaternion(lhs.v * rhs) }
//public func /(lhs: Quaternion, rhs: Float) -> Quaternion { return Quaternion(lhs.v * (1 / rhs)) }

func *(lhs: Quaternion, rhs: Vector) -> Vector {
  return Vector(rhs.storage * lhs.storage)
}

func *(lhs: Quaternion, rhs: Scalar) -> Quaternion {
  return Quaternion(lhs.storage * scalar4(rhs))
}

//func lerp(from:Quaternion, to:Quaternion) -> (Float) -> Quaternion {
//  fatalError("Not implemented")
//  let dot = max(-1, min(1, from.storage.dot(to.v)))
//  if dot - 1 < Epsilon {
////      return normalize((from.v + (to.v - from.v) * t).v)
//    }
//
////    let theta = acos(dot) * t
////    let t1 = self * cos(theta)
////    let t2 = (q - (self * dot)).normalized() * sin(theta)
////    return t1 + t2
//  func __lerp(t:Float) -> Quaternion {
//    return Quaternion()
//  }
//  return __lerp
//}
