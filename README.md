# recess

time off; timers and intervals for Madlib

[![Madlib Project Badge](https://img.shields.io/badge/madlib-purple?logo=github&logoSize=auto)](//github.com/madlib-lang/madlib) <!-- $MADLIB.projectBadge -->
[![recess v0.0.1](https://img.shields.io/badge/v0.0.1-purple?label=version)](//github.com/brekk/recess) <!-- $MADLIB.json.version -->
import Date from "Date"
import IO from "IO"
import Wish from "Wish"

import Recess from "@/Recess"



regularMain = () => {
  t = 0
  stop :: Recess.TimeSpanner {}
  stop = Recess.withInterval(
    200,
    () => {
      t := t + 1
      pipe(
        IO.pTrace(" " ++ show(t) ++ ". "),
      )(Date.now())
    },
  )
  Recess.wait(5000, stop)
}
alias Agg = { i :: Integer, info :: String }
moremore :: ({} -> {}) -> Agg -> Agg
moremore = (stop, agg) => {
  j = agg.i + 1
  IO.pTrace(" " ++ show(agg.i) ++ ". ", Date.now())
  if (j > 10) do {
    stop()
  }
  return { ...agg, i: j }
}
main = () => {
  pipe(
    Recess.withIntervalAsyncSource(
      200,
      () => {},
      pipe(
        IO.pTrace("WHAT?"),
        (x) => #["yeah!", x],
      ),
      $,
      moremore,
    ),
    Wish.fulfill(
      pipe(
        show,
        IO.putLine,
      ),
      pipe(
        show,
        IO.putLine,
      ),
    ),
  )({ i: 0, info: "started" })
}
