
import simd


// Scalar type

typealias Scalar = Float
typealias scalar2 = float2
typealias scalar3 = float3
typealias scalar4 = float4
typealias scalar4x4 = float4x4


// Nearly equal operator and its protocol
infix operator ~== {
  associativity none
  precedence 130
}

protocol NearlyEquatable {
  @warn_unused_result
  func ~==(lhs:Self, rhs:Self) -> Bool
}


protocol FloatingPointValidation {
  var isNaN:Bool { get }
  var isFinite:Bool { get }
  var isInfinite:Bool { get }
}

protocol SignedPackedNumberType {
  @warn_unused_result
  prefix func -(x: Self) -> Self

  @warn_unused_result
  func -(lhs: Self, rhs: Self) -> Self
}

protocol FiniteConvertible : FloatingPointValidation {
  @warn_unused_result
  func makeFinite() -> Self
  mutating func formFinite()
}

protocol IntegerConvertible {
  var rounded:Self { get }
  var ceiled:Self  { get }
  var floored:Self { get }

  func roundTo(nearest:Scalar) -> Self
  func floorTo(nearest:Scalar) -> Self
  func ceilTo(nearest:Scalar)  -> Self
}

protocol InterpolateArithmeticType {
  @warn_unused_result
  func +(lhs: Self, rhs: Self) -> Self
  @warn_unused_result
  func -(lhs: Self, rhs: Self) -> Self
  @warn_unused_result
  func *(lhs: Self, rhs: Scalar) -> Self
}

protocol VectorStorage : Equatable, SignedPackedNumberType, NearlyEquatable, FiniteConvertible, InterpolateArithmeticType , CustomStringConvertible {
  associatedtype T
  var storage:T { get set }
}

// Float2 and Float4 definition
protocol Scalar2 : VectorStorage {
  var storage:scalar2 {get set}
  init()
  init(_ storage:scalar2)
}

protocol Scalar4 : VectorStorage {
  var storage:scalar4 {get set}
  init()
  init(_ storage:scalar4)
}

//
// MARK: - Protocol Extensions
//

// MARK: - Scalar
extension Scalar : FiniteConvertible, InterpolateArithmeticType {

  static let epsilon = FLT_EPSILON
  static let zero = Scalar(0)
  static let min = FLT_MIN
  static let max = FLT_MAX
  static let graphicalEpsilon = (epsilon * 65536)


  static let Pi = Scalar(M_PI)
  static let HalfPi = Scalar(M_PI_2)
  static let QuarterPi = Scalar(M_PI_4)
  static let TwoPi = Scalar(M_PI * 2)
  static let DegreesPerRadian = 180 / Pi
  static let RadiansPerDegree = Pi / 180
  static let Epsilon: Scalar = 0.0001

  func makeFinite() -> Scalar {
    if self.isNaN {
      return .zero
    }
    else if self.isInfinite {
      return isSignMinus ? -.max : .max
    }
    return self
  }
  mutating func formFinite() {
    if self.isNaN {
      self = .zero
    }
    if self.isInfinite {
      self = isSignMinus ? -.max : .max
    }
  }

}



//
// MARK: - Float2
//
extension Scalar2 {

  init(_ x:Scalar, _ y:Scalar) {
    self.init()
    storage = scalar2(x, y)
  }
  var x:Scalar {
    get { return storage.x }
    set { storage.x = newValue }
  }
  var y:Scalar {
    get { return storage.y }
    set { storage.y = newValue }
  }

}

extension Scalar2 {
  var isNaN:Bool { return x.isNaN || y.isNaN }
  var isFinite:Bool { return x.isFinite && y.isFinite }
  var isInfinite:Bool { return x.isFinite || y.isInfinite }
}

extension Scalar2 {
  func makeFinite() -> Self {
    return Self(x.makeFinite(), y.makeFinite())
  }
  mutating func formFinite() {
    x.formFinite()
    y.formFinite()
  }
}

extension Scalar2 {
  var rounded:Self { return Self(rint_float2(storage)) }
  var ceiled:Self { return Self(ceil(storage)) }
  var floored:Self { return Self(floor(storage)) }
}

extension Scalar2 {
  var description:String { return storage.debugDescription }
}

func +<T:Scalar2>(lhs:T, rhs:T) -> T { return T(lhs.storage + rhs.storage) }
func -<T:Scalar2>(lhs:T, rhs:T) -> T { return T(lhs.storage - rhs.storage) }
func *<T:Scalar2>(lhs:T, rhs:T) -> T { return T(lhs.storage * rhs.storage) }
func /<T:Scalar2>(lhs:T, rhs:T) -> T { return T(lhs.storage / rhs.storage) }

prefix func -<T:Scalar2>(x:T) -> T { return T(-x.storage) }

func +=<T:Scalar2>(inout lhs:T, rhs:T) { lhs.storage += rhs.storage }
func -=<T:Scalar2>(inout lhs:T, rhs:T) { lhs.storage -= rhs.storage }
func *=<T:Scalar2>(inout lhs:T, rhs:T) { lhs.storage *= rhs.storage }
func /=<T:Scalar2>(inout lhs:T, rhs:T) { lhs.storage /= rhs.storage }

func ==<T:Scalar2>(lhs:T, rhs:T) -> Bool { return float2_equal(lhs.storage, rhs.storage) }
func ~==<T:Scalar2>(lhs:T, rhs:T) -> Bool { return float2_nearly_equal(lhs.storage, rhs.storage) }

func *<T:Scalar2>(lhs:T, rhs:Scalar) -> T { return T(lhs.storage * scalar2(rhs)) }



//
// MARK: - Float4
//
extension Scalar4 {
  init(_ x:Scalar, _ y:Scalar, _ z:Scalar, _ w:Scalar) {
    self.init()
    self.storage = scalar4(x, y, z, w)
  }
  var x:Scalar {
    get { return storage.x }
    set { storage.x = newValue }
  }
  var y:Scalar {
    get { return storage.y }
    set { storage.y = newValue }
  }
  var z:Scalar {
    get { return storage.z }
    set { storage.z = newValue }
  }
  var w:Scalar {
    get { return storage.w }
    set { storage.w = newValue }
  }
}

extension Scalar4 {
  var isNaN:Bool { return x.isNaN || y.isNaN || z.isNaN || w.isNaN }
  var isFinite:Bool { return x.isFinite && y.isFinite && z.isFinite && w.isFinite }
  var isInfinite:Bool { return x.isFinite || y.isInfinite || z.isFinite || w.isInfinite }
}

extension Scalar4 {
  func makeFinite() -> Self {
    return Self(x.makeFinite(), y.makeFinite(), z.makeFinite(), w.makeFinite())
  }
  mutating func formFinite() {
    x.formFinite()
    y.formFinite()
    z.formFinite()
    w.formFinite()
  }
}

extension Scalar4 {
  var rounded:Self { return Self(rint_float4(storage)) }
  var ceiled:Self { return Self(ceil(storage)) }
  var floored:Self { return Self(floor(storage)) }
}

extension Scalar4 {
  var description:String { return storage.debugDescription }
}

func +<T:Scalar4>(lhs:T, rhs:T) -> T { return T(lhs.storage + rhs.storage) }
func -<T:Scalar4>(lhs:T, rhs:T) -> T { return T(lhs.storage - rhs.storage) }
func *<T:Scalar4>(lhs:T, rhs:T) -> T { return T(lhs.storage * rhs.storage) }
func /<T:Scalar4>(lhs:T, rhs:T) -> T { return T(lhs.storage / rhs.storage) }

prefix func -<T:Scalar4>(x:T) -> T { return T(-x.storage) }

func +=<T:Scalar4>(inout lhs:T, rhs:T) { lhs.storage += rhs.storage }
func -=<T:Scalar4>(inout lhs:T, rhs:T) { lhs.storage -= rhs.storage }
func *=<T:Scalar4>(inout lhs:T, rhs:T) { lhs.storage *= rhs.storage }
func /=<T:Scalar4>(inout lhs:T, rhs:T) { lhs.storage /= rhs.storage }

func ==<T:Scalar4>(lhs:T, rhs:T) -> Bool { return float4_equal(lhs.storage, rhs.storage) }
func ~==<T:Scalar4>(lhs:T, rhs:T) -> Bool { return float4_nearly_equal(lhs.storage, rhs.storage) }

func *<T:Scalar4>(lhs:T, rhs:Scalar) -> T { return T(lhs.storage * scalar4(rhs)) }



//
// MARK: - Point
//
struct Point : Scalar2 {
  var storage:scalar2

  init() { storage = scalar2() }
  init(x:Scalar, y:Scalar) { self.init(x, y) }
  init(_ storage:scalar2) { self.storage = storage }
}



//
// MARK: - Size
//
struct Size : Scalar2 {
  var storage:scalar2

  init() { storage = scalar2() }
  init(_ storage:scalar2) { self.storage = storage }
  init(width:Scalar, height:Scalar) { storage = scalar2(width, height) }

  var width:Scalar {
    get { return x }
    set { x = newValue }
  }

  var height:Scalar {
    get { return y }
    set { y = newValue }
  }
}


//
// MARK: - Lerp
//
func lerp<T:InterpolateArithmeticType>(from:T, _ to:T) -> (Scalar) -> T {
  let d = to - from

  func __lerp(t:Scalar) -> T {
    return from + d * t
  }
  return __lerp
}



