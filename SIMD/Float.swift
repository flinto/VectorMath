
import simd


// Scalar type
typealias Scalar = Float


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
protocol Float2 : VectorStorage {
  var storage:float2 {get set}
  init()
  init(_ storage:float2)
}

protocol Float4 : VectorStorage {
  var storage:float4 {get set}
  init()
  init(_ storage:float4)
}

//
// MARK: - Protocol Extensions
//

// MARK: - Scalar
extension Scalar : FiniteConvertible, InterpolateArithmeticType {

  static let epsilon = FLT_EPSILON
  static let zero = Float(0)
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
extension Float2 {

  init(_ x:Float, _ y:Float) {
    self.init()
    storage = float2(x, y)
  }
  var x:Float {
    get { return storage.x }
    set { storage.x = newValue }
  }
  var y:Float {
    get { return storage.y }
    set { storage.y = newValue }
  }

}

extension Float2 {
  var isNaN:Bool { return x.isNaN || y.isNaN }
  var isFinite:Bool { return x.isFinite && y.isFinite }
  var isInfinite:Bool { return x.isFinite || y.isInfinite }
}

extension Float2 {
  func makeFinite() -> Self {
    return Self(x.makeFinite(), y.makeFinite())
  }
  mutating func formFinite() {
    x.formFinite()
    y.formFinite()
  }
}

extension Float2 {
  var rounded:Self { return Self(rint_float2(storage)) }
  var ceiled:Self { return Self(ceil(storage)) }
  var floored:Self { return Self(floor(storage)) }
}

extension Float2 {
  var description:String { return storage.debugDescription }
}

func +<T:Float2>(lhs:T, rhs:T) -> T { return T(lhs.storage + rhs.storage) }
func -<T:Float2>(lhs:T, rhs:T) -> T { return T(lhs.storage - rhs.storage) }
func *<T:Float2>(lhs:T, rhs:T) -> T { return T(lhs.storage * rhs.storage) }
func /<T:Float2>(lhs:T, rhs:T) -> T { return T(lhs.storage / rhs.storage) }

prefix func -<T:Float2>(x:T) -> T { return T(-x.storage) }

func +=<T:Float2>(inout lhs:T, rhs:T) { lhs.storage += rhs.storage }
func -=<T:Float2>(inout lhs:T, rhs:T) { lhs.storage -= rhs.storage }
func *=<T:Float2>(inout lhs:T, rhs:T) { lhs.storage *= rhs.storage }
func /=<T:Float2>(inout lhs:T, rhs:T) { lhs.storage /= rhs.storage }

func ==<T:Float2>(lhs:T, rhs:T) -> Bool { return float2_equal(lhs.storage, rhs.storage) }
func ~==<T:Float2>(lhs:T, rhs:T) -> Bool { return float2_nearly_equal(lhs.storage, rhs.storage) }

func *<T:Float2>(lhs:T, rhs:Float) -> T { return T(lhs.storage * float2(rhs)) }



//
// MARK: - Float4
//
extension Float4 {
  init(_ x:Float, _ y:Float, _ z:Float, _ w:Float) {
    self.init()
    self.storage = float4(x, y, z, w)
  }
  var x:Float {
    get { return storage.x }
    set { storage.x = newValue }
  }
  var y:Float {
    get { return storage.y }
    set { storage.y = newValue }
  }
  var z:Float {
    get { return storage.z }
    set { storage.z = newValue }
  }
  var w:Float {
    get { return storage.w }
    set { storage.w = newValue }
  }
}

extension Float4 {
  var isNaN:Bool { return x.isNaN || y.isNaN || z.isNaN || w.isNaN }
  var isFinite:Bool { return x.isFinite && y.isFinite && z.isFinite && w.isFinite }
  var isInfinite:Bool { return x.isFinite || y.isInfinite || z.isFinite || w.isInfinite }
}

extension Float4 {
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

extension Float4 {
  var rounded:Self { return Self(rint_float4(storage)) }
  var ceiled:Self { return Self(ceil(storage)) }
  var floored:Self { return Self(floor(storage)) }
}

extension Float4 {
  var description:String { return storage.debugDescription }
}

func +<T:Float4>(lhs:T, rhs:T) -> T { return T(lhs.storage + rhs.storage) }
func -<T:Float4>(lhs:T, rhs:T) -> T { return T(lhs.storage - rhs.storage) }
func *<T:Float4>(lhs:T, rhs:T) -> T { return T(lhs.storage * rhs.storage) }
func /<T:Float4>(lhs:T, rhs:T) -> T { return T(lhs.storage / rhs.storage) }

prefix func -<T:Float4>(x:T) -> T { return T(-x.storage) }

func +=<T:Float4>(inout lhs:T, rhs:T) { lhs.storage += rhs.storage }
func -=<T:Float4>(inout lhs:T, rhs:T) { lhs.storage -= rhs.storage }
func *=<T:Float4>(inout lhs:T, rhs:T) { lhs.storage *= rhs.storage }
func /=<T:Float4>(inout lhs:T, rhs:T) { lhs.storage /= rhs.storage }

func ==<T:Float4>(lhs:T, rhs:T) -> Bool { return float4_equal(lhs.storage, rhs.storage) }
func ~==<T:Float4>(lhs:T, rhs:T) -> Bool { return float4_nearly_equal(lhs.storage, rhs.storage) }

func *<T:Float4>(lhs:T, rhs:Float) -> T { return T(lhs.storage * float4(rhs)) }



//
// MARK: - Point
//
struct Point : Float2 {
  var storage:float2

  init() { storage = float2() }
  init(x:Float, y:Float) { self.init(x, y) }
  init(_ storage:float2) { self.storage = storage }
}



//
// MARK: - Size
//
struct Size : Float2 {
  var storage:float2

  init() { storage = float2() }
  init(_ storage:float2) { self.storage = storage }
  init(width:Float, height:Float) { storage = float2(width, height) }

  var width:Float {
    get { return x }
    set { x = newValue }
  }

  var height:Float {
    get { return y }
    set { y = newValue }
  }
}


//
// MARK: - Lerp
//
func lerp<T:InterpolateArithmeticType>(from:T, _ to:T) -> (Float) -> T {
  let d = to - from

  func __lerp(t:Float) -> T {
    return from + d * t
  }
  return __lerp
}



