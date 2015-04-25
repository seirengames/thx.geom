package thx.geom.d2;

class LineSegment implements ISegment {
  public var start(default, null) : Point;
  public var end(default, null) : Point;
  public function new(start : Point, end : Point) {
    this.start = start;
    this.end = end;
  }

  public function toVector()
    return Vector.linked(
      function( ) return end.x - start.x,
      function( ) return end.y - start.y,
      function(v) {
        end.x = start.x + v;
        return v;
      },
      function(v) {
        end.y = start.y + v;
        return v;
      }
    );

  public function toString()
    return 'LineSegment(${start.x},${start.y},${end.x},${end.y})';
}
