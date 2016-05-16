
import simd

struct Vector : Float4 {
  var storage:float4

  init() {
    storage = float4()
  }

  init(_ storage:float4) {
    self.storage = storage
  }

  static let zero:Vector = Vector()
  static let unit:Vector = Vector(1, 1, 1, 1)
  static let x = Vector(1, 0, 0, 0)
  static let y = Vector(0, 1, 0, 0)
  static let z = Vector(0, 0, 1, 0)
  static let w = Vector(0, 0, 0, 1)

  init(_ v:Vector) {
    self.storage = v.storage
  }

  var lengthSquared: Float {
    return length_squared(storage)
  }

  var length:Float {
    return sqrt(lengthSquared)
  }

  var xy:Point {
    return Point(x, y)
  }

  var xyz:Vector {
    return Vector(x, y, z, 1)
  }

  func dot(v:Vector) -> Float {
    return simd.dot(self.storage, v.storage)
  }

  @warn_unused_result
  func normalized() -> Vector {
    return Vector(normalize(storage))
  }

  init(_ p:Point) {
    self.init(p.x, p.y, 1, 0)
  }

  @warn_unused_result
  func distanceTo(other:Vector) -> Scalar { return distance(self.storage, other.storage) }

}

extension Vector {
  var description:String { return storage.debugDescription }
}


func *(lhs:Vector, rhs:Scalar) -> Vector { return Vector(lhs.storage * float4(rhs)) }
func /(lhs:Vector, rhs:Scalar) -> Vector { return Vector(lhs.storage / float4(rhs)) }
func *=(inout lhs:Vector, rhs:Scalar)    { return lhs.storage *= float4(rhs) }
func /=(inout lhs:Vector, rhs:Scalar)    { return lhs.storage /= float4(rhs) }
