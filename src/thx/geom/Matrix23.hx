package thx.geom;

import thx.geom.d2.Point;
import thx.geom.d2.Vector;

using thx.core.Arrays;
using thx.core.Floats;
import thx.geom.m.*;

abstract Matrix23(M23) from M23 to M23 {
  public static var identity(default, null) = new Matrix23(new MutM23(1, 0, 0, 1, 0, 0));

  public static function create(a : Float, b : Float, c : Float, d : Float, e : Float, f : Float) : Matrix23
    return new MutM23(a, b, c, d, e, f);

  public var a(get, set) : Float;
  public var b(get, set) : Float;
  public var c(get, set) : Float;
  public var d(get, set) : Float;
  public var e(get, set) : Float;
  public var f(get, set) : Float;

  inline public function new(m : M23)
    this = m;

  public function flipX() : Matrix23
    return mul(-1, 0, 0, 1, 0, 0);

  public function flipY() : Matrix23
    return mul(1, 0, 0, -1, 0, 0);

  @:op(A*B) public function multiply(other : Matrix23) : Matrix23
    return mul(other.a, other.b, other.c, other.d, other.e, other.f);

  private function mul(a : Float, b : Float, c : Float, d : Float, e : Float, f : Float) : Matrix23
    return create(
      this.a * a + this.c * b,
      this.b * a + this.d * b,
      this.a * c + this.c * d,
      this.b * c + this.d * d,
      this.a * e + this.c * f + this.e,
      this.b * e + this.d * f + this.f
    );

  public function inverse() : Matrix23 {
    var det1 = this.a * this.d - this.b * this.c;
    if(det1 == 0.0)
      throw "Matrix cannot be inverted";

    var idet = 1.0 / det1,
        det2 = f * c - e * d,
        det3 = e * b - f * a;

    return create(
      d * idet,
     -b * idet,
     -c * idet,
      a * idet,
      det2 * idet,
      det3 * idet
    );
  }

  inline public function isIdentity()
    return equals(identity);

  public function isInvertible()
    return (a * d - b * c) != 0.0;

  public function rotate(angle : Float) : Matrix23 {
    var c = angle.cos(),
        s = angle.sin();
    return mul(c, s, -s, -c, 0, 0);
  }

  public function translate(x : Float, y : Float) : Matrix23
    return mul(1, 0, 0, 1, x, y);

  public function scale(scaleFactor : Float) : Matrix23
    return mul(scaleFactor, 0, 0, scaleFactor, 0, 0);

  public function getScale() : Vector
    return Vector.create(
      Math.sqrt(a * a + c * c),
      Math.sqrt(b * b + d * d)
    );

  public function getDecompositionTRSR() {
    var m00   = a,
        m10   = b,
        m01   = c,
        m11   = d,
        E     = (m00 + m11) / 2,
        F     = (m00 - m11) / 2,
        G     = (m10 + m01) / 2,
        H     = (m10 - m01) / 2,
        Q     = Math.sqrt(E * E + H * H),
        R     = Math.sqrt(F * F + G * G),
        sx    = Q + R,
        sy    = Q - R,
        a1    = Math.atan2(G, F),
        a2    = Math.atan2(H, E),
        theta = (a2 - a1) / 2,
        phi   = (a2 + a1) / 2;

    return {
        translation: create(1, 0, 0, 1, this.e, this.f),
        rotation: identity.rotate(phi),
        scale: create(sx, 0, 0, sy, 0, 0),
        rotation0: identity.rotate(theta)
    };
  }

  // TODO
  // rotateAt(angle, center)
  // rotateFromVector(angle, vector)
  // scaleAt(scaleFactor, center)
  // scaleNonUniformAt(scaleFactor, center)
  // skewX(radians)
  // skewY(radians)

  public function scaleNonUniform(scaleX : Float, scaleY : Float) : Matrix23
    return mul(scaleX, 0, 0, scaleY, 0, 0);

  public function skewX(angle : Float) : Matrix23
    return mul(1, 0, angle.tan(), 1, 0, 0);

  public function skewY(angle : Float) : Matrix23
    return mul(1, angle.tan(), 0, 1, 0, 0);

  public function equals(other : Matrix23) : Bool
    return a == other.a &&
           b == other.b &&
           c == other.c &&
           d == other.d &&
           e == other.e &&
           f == other.f;

  public function toString()
    return 'matrix($a,$b,$c,$d,$e,$f)';

  inline function get_a() : Float return this.a;
  inline function get_b() : Float return this.b;
  inline function get_c() : Float return this.c;
  inline function get_d() : Float return this.d;
  inline function get_e() : Float return this.e;
  inline function get_f() : Float return this.f;
  inline function set_a(v : Float) : Float return this.a = v;
  inline function set_b(v : Float) : Float return this.b = v;
  inline function set_c(v : Float) : Float return this.c = v;
  inline function set_d(v : Float) : Float return this.d = v;
  inline function set_e(v : Float) : Float return this.e = v;
  inline function set_f(v : Float) : Float return this.f = v;
}
