use "ponytest"
use ".."

class TestCCounter is UnitTest
  new iso create() => None
  fun name(): String => "crdt.CCounter"

  fun apply(h: TestHelper) =>
    let a = CCounter("a".hash())
    let b = CCounter("b".hash())
    let c = CCounter("c".hash())

    a.increment(1)
    b.decrement(2)
    c.increment(3)

    h.assert_eq[U64](a.value(), 1)
    h.assert_eq[U64](b.value(), -2)
    h.assert_eq[U64](c.value(), 3)
    h.assert_ne[CCounter](a, b)
    h.assert_ne[CCounter](b, c)
    h.assert_ne[CCounter](c, a)

    h.assert_false(a.converge(a))

    h.assert_true(a.converge(b))
    h.assert_true(a.converge(c))
    h.assert_true(b.converge(c))
    h.assert_true(b.converge(a))
    h.assert_true(c.converge(a))
    h.assert_false(c.converge(b))

    h.assert_eq[U64](a.value(), 2)
    h.assert_eq[U64](b.value(), 2)
    h.assert_eq[U64](c.value(), 2)
    h.assert_eq[CCounter](a, b)
    h.assert_eq[CCounter](b, c)
    h.assert_eq[CCounter](c, a)

    a.increment(9)
    b.increment(8)
    c.decrement(7)

    h.assert_eq[U64](a.value(), 11)
    h.assert_eq[U64](b.value(), 10)
    h.assert_eq[U64](c.value(), -5)
    h.assert_ne[CCounter](a, b)
    h.assert_ne[CCounter](b, c)
    h.assert_ne[CCounter](c, a)

    h.assert_true(a.converge(b))
    h.assert_true(a.converge(c))
    h.assert_true(b.converge(c))
    h.assert_true(b.converge(a))
    h.assert_true(c.converge(a))
    h.assert_false(c.converge(b))

    h.assert_eq[U64](a.value(), 12)
    h.assert_eq[U64](b.value(), 12)
    h.assert_eq[U64](c.value(), 12)
    h.assert_eq[CCounter](a, b)
    h.assert_eq[CCounter](b, c)
    h.assert_eq[CCounter](c, a)

class TestCCounterDelta is UnitTest
  new iso create() => None
  fun name(): String => "crdt.CCounter (ẟ)"

  fun apply(h: TestHelper) =>
    let a = CCounter("a".hash())
    let b = CCounter("b".hash())
    let c = CCounter("c".hash())

    var a_delta = a.increment(1)
    var b_delta = b.decrement(2)
    var c_delta = c.increment(3)

    h.assert_eq[U64](a.value(), 1)
    h.assert_eq[U64](b.value(), -2)
    h.assert_eq[U64](c.value(), 3)
    h.assert_ne[CCounter](a, b)
    h.assert_ne[CCounter](b, c)
    h.assert_ne[CCounter](c, a)

    h.assert_false(a.converge(a_delta))

    h.assert_true(a.converge(b_delta))
    h.assert_true(a.converge(c_delta))
    h.assert_true(b.converge(c_delta))
    h.assert_true(b.converge(a_delta))
    h.assert_true(c.converge(a_delta))
    h.assert_true(c.converge(b_delta))

    h.assert_eq[U64](a.value(), 2)
    h.assert_eq[U64](b.value(), 2)
    h.assert_eq[U64](c.value(), 2)
    h.assert_eq[CCounter](a, b)
    h.assert_eq[CCounter](b, c)
    h.assert_eq[CCounter](c, a)

    a_delta = a.increment(9)
    b_delta = b.increment(8)
    c_delta = c.decrement(7)

    h.assert_eq[U64](a.value(), 11)
    h.assert_eq[U64](b.value(), 10)
    h.assert_eq[U64](c.value(), -5)
    h.assert_ne[CCounter](a, b)
    h.assert_ne[CCounter](b, c)
    h.assert_ne[CCounter](c, a)

    h.assert_true(a.converge(b_delta))
    h.assert_true(a.converge(c_delta))
    h.assert_true(b.converge(c_delta))
    h.assert_true(b.converge(a_delta))
    h.assert_true(c.converge(a_delta))
    h.assert_true(c.converge(b_delta))

    h.assert_eq[U64](a.value(), 12)
    h.assert_eq[U64](b.value(), 12)
    h.assert_eq[U64](c.value(), 12)
    h.assert_eq[CCounter](a, b)
    h.assert_eq[CCounter](b, c)
    h.assert_eq[CCounter](c, a)
