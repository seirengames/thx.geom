package thx.geom.d2;

import thx.geom.d2.*;
import thx.geom.core.*;
import utest.Assert;

class TestSize {
  public function new() {}

  public function testBasics() {
    var size = Size.create(10, 20);
    Assert.equals(200, size.area);
    Assert.equals(60, size.perimeter);
  }
}
