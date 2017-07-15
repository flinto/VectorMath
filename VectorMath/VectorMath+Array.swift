
import Foundation

protocol VectorArrayConvertible {
  associatedtype Element

  var asArray:[Element] { get }
}

protocol VectorFloatArrayConvertible {
  var asFloatArray:[Float] { get }
}

extension Array {
  init<T:VectorArrayConvertible>(_ arr:T) where Element == T.Element {
    self = arr.asArray
  }
}

// MARK: -

extension Vector2 : VectorArrayConvertible, VectorFloatArrayConvertible {
  typealias Element = Scalar

  var asArray:[Scalar] {
    return [x, y]
  }

  var asFloatArray:[Float] {
    return [Float(x), Float(y)]
  }
}

extension Vector3 : VectorArrayConvertible, VectorFloatArrayConvertible {
  typealias Element = Scalar

  var asArray:[Scalar] {
    return [x, y, z]
  }

  var asFloatArray:[Float] {
    return [Float(x), Float(y), Float(z)]
  }
}

extension Vector4 : VectorArrayConvertible, VectorFloatArrayConvertible {
  typealias Element = Scalar

  var asArray:[Scalar] {
    return [x, y, z, w]
  }

  var asFloatArray:[Float] {
    return [Float(x), Float(y), Float(z), Float(w)]
  }
}

extension Quaternion : VectorArrayConvertible, VectorFloatArrayConvertible {
  typealias Element = Scalar

  var asArray:[Scalar] {
    return [x, y, z, w]
  }

  var asFloatArray:[Float] {
    return [Float(x), Float(y), Float(z), Float(w)]
  }
}

extension Matrix3 : VectorArrayConvertible, VectorFloatArrayConvertible {
  typealias Element = Scalar

  var asArray:[Scalar] {
    return [m11, m12, m13, m21, m22, m23, m31, m32, m33]
  }

  var asFloatArray:[Float] {
    return [Float(m11), Float(m12), Float(m13), Float(m21), Float(m22), Float(m23), Float(m31), Float(m32), Float(m33)]
  }

}

extension Matrix4 : VectorArrayConvertible, VectorFloatArrayConvertible {
  typealias Element = Scalar

  var asArray:[Scalar] {
    return [m11, m12, m13, m14, m21, m22, m23, m24, m31, m32, m33, m34, m41, m42, m43, m44]
  }

  var asFloatArray:[Float] {
    return [Float(m11), Float(m12), Float(m13), Float(m14), Float(m21), Float(m22), Float(m23), Float(m24),
            Float(m31), Float(m32), Float(m33), Float(m34), Float(m41), Float(m42), Float(m43), Float(m44)]
  }

}
