
import simd


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
// MARK: - Rect
//
struct Rect : Equatable, NearlyEquatable {

  static let zero:Rect = Rect()

  var origin:Point = .zero
  var size:Size    = .zero

  init() {}

  init(p1:Point, p2:Point, proportional:Bool = false) {
    origin = p1
    size = Size(p2.storage - p1.storage)
    if proportional {
      size.width = abs(size.height) * sign(size.width)
    }
    standardizeInPlace()
  }

  init(origin:Point, size:Size) {
    self.origin = origin
    self.size = size
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

  @warn_unused_result
  func rectForLineDrawing() -> Rect {
    let tl = origin.floored.storage + float2(0.5)
    let br = bottomRight.ceiled.storage - tl - float2(1)
    return Rect(origin:Point(tl), size:Size(br))
  }

  var cornerPoints:[Point] {
    return [topLeft, topRight, bottomRight, bottomLeft]
  }

  var sidePoints:[Point] {
    return [topCenter, middleRight, bottomCenter, middleLeft]
  }

  @warn_unused_result
  func union(r:Rect) -> Rect {
    fatalError("Not implemented")
  }

  mutating func unionInPlace(r:Rect) {
    fatalError("Not implemented")
  }

  var standardized:Rect { fatalError("Not Implemented") }

  mutating func standardizeInPlace() {
    //fatalError("Not implemented")
  }

  static func union(rects:[Rect]) -> Rect {
    if var union = rects.first {
      for i in 1 ..< rects.count {
        union.unionInPlace(rects[i])
      }
      return union
    }
    else {
      return Rect.zero
    }
  }

}

func ==(lhs:Rect, rhs:Rect) -> Bool { return lhs.origin == rhs.origin && lhs.size == rhs.size }
func ~==(lhs:Rect, rhs:Rect) -> Bool { return lhs.origin ~== rhs.origin && lhs.size ~== rhs.size }


