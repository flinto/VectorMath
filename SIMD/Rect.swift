
import simd
import QuartzCore

//
// MARK: - Point
//
extension Point {

  static let zero:Point = Point()
  func offsetBy(dx dx:Float, dy:Float) -> Point { return Point(x + dx, y+dy) }

  func distanceTo(other:Point) -> Scalar { return distance(self.storage, other.storage) }

}

func *(lhs:Point, rhs:Scalar) -> Point { return Point(lhs.storage * float2(rhs)) }
func /(lhs:Point, rhs:Scalar) -> Point { return Point(lhs.storage / float2(rhs)) }
func *= (inout lhs:Point, rhs:Scalar)  { return lhs.storage *= float2(rhs) }
func /= (inout lhs:Point, rhs:Scalar)  { return lhs.storage /= float2(rhs) }


//
// MARK: - Size
//
extension Size {
  static let zero:Size = Size()
}


func *(lhs:Size, rhs:Scalar) -> Size { return Size(lhs.storage * float2(rhs)) }
func /(lhs:Size, rhs:Scalar) -> Size { return Size(lhs.storage / float2(rhs)) }
func *= (inout lhs:Size, rhs:Scalar) { return lhs.storage *= float2(rhs) }
func /= (inout lhs:Size, rhs:Scalar) { return lhs.storage /= float2(rhs) }


//
// MARK: - Edge Inset
//

struct EdgeInsets : Float4 {
  var storage:float4

  var top:Float {
    get { return storage.x }
    set { storage.x = newValue }
  }
  var left:Float {
    get { return storage.y }
    set { storage.y = newValue }
  }
  var bottom:Float {
    get { return storage.z }
    set { storage.z = newValue }
  }
  var right:Float {
    get { return storage.w }
    set { storage.w = newValue }
  }
  init(_ storage:float4) {
    self.storage = storage
  }
  init() {
    self.storage = float4()
  }
  init(top:Float = 0, left:Float = 0, bottom:Float = 0, right:Float = 0) {
    self.storage = float4(top, left, bottom, right)
  }

  var description:String {
    return "top:\(top), left:\(left), bottom:\(bottom), right:\(right)"
  }
}

//
// MARK: - Rect
//
struct Rect : Equatable, NearlyEquatable {

  static let zero:Rect = Rect()
  static let null:Rect = Rect(.infinity, .infinity, 0, 0)

  var origin:Point = .zero
  var size:Size    = .zero

  init() {}

  init(p1:Point, p2:Point, proportional:Bool = false) {
    origin = p1
    size = Size(p2.storage - p1.storage)
    if proportional {
      size.width = abs(size.height) * sign(size.width)
    }
    standardize()
  }

  init(origin:Point, size:Size) {
    self.origin = origin
    self.size = size
  }

  init(_ x:Float, _ y:Float, _ w:Float, _ h:Float) {
    self.origin = Point(x, y)
    self.size = Size(w, h)
  }

  var center:Point {
    get { return origin + Point(size.storage / float2(2)) }
    set { origin = newValue - Point(size.storage / float2(2)) }
  }

  var left:Float {
    get { return origin.x }
    set { origin.x = newValue }
  }

  var right:Float {
    get { return origin.x + size.width }
    set { origin.x = newValue - size.width }
  }

  var top:Float {
    get { return origin.y }
    set { origin.y = newValue }
  }

  var bottom:Float {
    get { return origin.y + size.height }
    set { origin.y = newValue - size.height }
  }

  var topRight:Point     { return Point(origin.x + size.width,   origin.y) }
  var topCenter:Point    { return Point(origin.x + size.width/2, origin.y) }
  var topLeft:Point      { return origin }

  var middleRight:Point  { return Point(origin.x + size.width, origin.y + size.height/2) }
  var middleLeft:Point   { return Point(origin.x,              origin.y + size.height/2) }

  var bottomRight:Point  { return origin + Point(size.storage) }
  var bottomCenter:Point { return Point(origin.x + size.width/2, origin.y + size.height) }
  var bottomLeft:Point   { return Point(origin.x,                origin.y + size.height) }

  var isNull:Bool {
    return self == Rect.null
  }

  var isEmpty:Bool {
    return size == .zero
  }

  var integral:Rect {
    var r = self
    r.formIntegral()
    return r
  }

  mutating func formIntegral() {
    standardize()
    let tl = origin.floored.storage
    let br = bottomRight.ceiled.storage - tl
    origin = Point(tl)
    size = Size(br)
  }

  var cornerPoints:[Point] {
    return [topLeft, topRight, bottomRight, bottomLeft]
  }

  var sidePoints:[Point] {
    return [topCenter, middleRight, bottomCenter, middleLeft]
  }

  var standardized:Rect {
    var r = self
    r.standardize()
    return r
  }

  mutating func standardize() {
    if size.width < 0 {
      origin.x += size.width
      size.width = -size.width
    }
    if size.height < 0 {
      origin.y += size.height
      size.height = -size.height
    }
  }

  @warn_unused_result
  func insetted(dx dx: Float, dy: Float) -> Rect {
    var r = self
    r.inset(dx: dx, dy: dy)
    return r
  }

  mutating func inset(dx dx: Float, dy: Float) {
    origin.storage += float2(dx, dy)
    size.storage -= float2(dx, dy) * 2

  }

  @warn_unused_result
  func insetted(insets:EdgeInsets) -> Rect {
    var rect = self
    rect.origin.x    += insets.left
    rect.origin.y    += insets.top
    rect.size.width  -= (insets.left + insets.right)
    rect.size.height -= (insets.top  + insets.bottom)
    return rect
  }

  // TODO: - Replace CGRect function
  @warn_unused_result
  func union(r:Rect) -> Rect {
    return Rect(CGRectUnion(CGRect(self), CGRect(r)))
  }

  mutating func formUnion(r:Rect) {
    updateWithCGRect(CGRectUnion(CGRect(self), CGRect(r)))
  }

  @warn_unused_result
  func intersected(r:Rect) -> Rect {
    return Rect(CGRectIntersection(CGRect(self), CGRect(r)))
  }

  mutating func intersect(r:Rect) {
    updateWithCGRect(CGRectIntersection(CGRect(self), CGRect(r)))
  }

  func intersects(rect:Rect) -> Bool {
    return CGRectIntersectsRect(CGRect(self), CGRect(rect))
  }
  
  func contains(p:Point) -> Bool {
    return CGRect(self).contains(CGPoint(p))
  }

  func contains(r:Rect) -> Bool {
    return CGRect(self).contains(CGRect(r))
  }

  private mutating func updateWithCGRect(r:CGRect) {
    origin = Point(r.origin)
    size = Size(r.size)
  }

  static func union(rects:[Rect]) -> Rect? {
    if var r = rects.first {
      for i in 1..<rects.count {
        r.formUnion(rects[i])
      }
      return r
    }
    return nil
  }


}


func ==(lhs:Rect, rhs:Rect) -> Bool { return lhs.origin == rhs.origin && lhs.size == rhs.size }
func ~==(lhs:Rect, rhs:Rect) -> Bool { return lhs.origin ~== rhs.origin && lhs.size ~== rhs.size }


