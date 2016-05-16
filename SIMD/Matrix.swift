
import simd

typealias Matrix = float4x4

extension Matrix : NearlyEquatable {
  static var identity:Matrix = Matrix(matrix_identity_float4x4)

  var isIdentity:Bool { return self == Matrix.identity }
  var isNearlyIdentity:Bool { return self ~== Matrix.identity }

  init(_ m11: Scalar, _ m12: Scalar, _ m13: Scalar, _ m14: Scalar,
       _ m21: Scalar, _ m22: Scalar, _ m23: Scalar, _ m24: Scalar,
       _ m31: Scalar, _ m32: Scalar, _ m33: Scalar, _ m34: Scalar,
       _ m41: Scalar, _ m42: Scalar, _ m43: Scalar, _ m44: Scalar) {

    self.init(
      [float4(m11, m12, m13, m14),
       float4(m21, m22, m23, m24),
       float4(m31, m32, m33, m34),
       float4(m41, m42, m43, m44)
      ])
  }

  init(scale s: Vector) {
    self.init(diagonal:s.xyz.storage)
  }

  init(translation t: Vector) {
    self.init(diagonal:Vector.unit.storage)
    self[3] = t.xyz.storage
  }

  init(rotation axisAngle: Vector) {
    self.init(quaternion: Quaternion( axisAngle))
  }

  init(quaternion q: Quaternion) {

    self.init(
      1 - 2 * (q.y * q.y + q.z * q.z), 2 * (q.x * q.y + q.z * q.w), 2 * (q.x * q.z - q.y * q.w), 0,
      2 * (q.x * q.y - q.z * q.w), 1 - 2 * (q.x * q.x + q.z * q.z), 2 * (q.y * q.z + q.x * q.w), 0,
      2 * (q.x * q.z + q.y * q.w), 2 * (q.y * q.z - q.x * q.w), 1 - 2 * (q.x * q.x + q.y * q.y), 0,
      0, 0, 0, 1
    )
  }

  @warn_unused_result
  func translate(t:Vector) -> Matrix {
    return self * Matrix(translation: t)
  }

  @warn_unused_result
  func rotate(v:Vector) -> Matrix {

    func rotateX(theta:Scalar) -> Matrix {
      let c = cos(theta), s = sin(theta)
      return Matrix(
        1,  0, 0, 0,
        0,  c, s, 0,
        0, -s, c, 0,
        0,  0, 0, 1
      )
    }
    func rotateY(theta:Scalar) -> Matrix {
      let c = cos(theta), s = sin(theta)
      return Matrix(
        c, 0, -s, 0,
        0, 1,  0, 0,
        s, 0,  c, 0,
        0, 0,  0, 1
      )
    }
    func rotateZ(theta:Scalar) -> Matrix {
      let c = cos(theta), s = sin(theta)
      return Matrix(
        c,  s, 0, 0,
       -s,  c, 0, 0,
        0,  0, 1, 0,
        0,  0, 0, 1
      )
    }
    return self * rotateX(v.x) * rotateY(v.y) * rotateZ(v.z)
  }

  @warn_unused_result
  func scale(v:Vector) -> Matrix {
    return self * Matrix(scale:v)
  }

  var description:String {

    return "\n" +
      "[ \(self[0])\n" +
      "  \(self[1])\n" +
      "  \(self[2])\n" +
      "  \(self[3])]\n"
  }
}

func == (lhs:Matrix, rhs:Matrix) -> Bool { return matrix_equal(lhs.cmatrix, rhs.cmatrix) }
func ~==(lhs:Matrix, rhs:Matrix) -> Bool { return matrix_almost_equal_elements(lhs.cmatrix, rhs.cmatrix, 0.01) }

func * (lhs:Matrix, rhs:Vector) -> Vector { return Vector(matrix_multiply(lhs.cmatrix, rhs.storage)) }
