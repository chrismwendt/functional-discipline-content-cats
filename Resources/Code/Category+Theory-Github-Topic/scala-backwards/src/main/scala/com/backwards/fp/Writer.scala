package com.backwards.fp

import com.backwards.fp.monoid.Monoid

final case class Writer[W: Monoid, A](run: () => (W, A))

object Writer {
  def tell[W: Monoid](w: W): Writer[W, Unit] =
    Writer(() => (w, ()))
}