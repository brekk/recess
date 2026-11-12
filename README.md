# recess

timers and intervals for Madlib

[![Madlib Project Badge](https://img.shields.io/badge/madlib-purple?logo=github&logoSize=auto)](//github.com/madlib-lang/madlib) <!-- $MADLIB.projectBadge -->
[![recess v1.0.0](https://img.shields.io/badge/v1.0.0-purple?label=version)](//github.com/brekk/recess) <!-- $MADLIB.json.version -->

---

# Usage

There are two core functions of `recess`.

## withIntervalOnComplete

The first is `withIntervalOnComplete`

It has the signature:

```madlib_
withIntervalOnComplete :: ({} -> {}) -> Integer -> (a -> {}) -> ({} ->{})
```
And takes the form:
```
```madlib_
stopFunction = withIntervalOnComplete(nullaryCallbackOnEnd, milliseconds, nullaryCallbackOnTick)`
```
Often you don't have a reason to do anything for the final callback, if this hypothetical you is the you of today, you can also use `withInterval` which just partially applies a no-op for `nullartyCallbackOnEnd`.

```madlib_
stopFunction = withInterval(milliseconds, nullaryCallbackOnTick)`
```

Here's a runnable example

```madlib^#withInterval.example

import Date from "Date"
import IO from "IO"
import Wish from "Wish"

import Recess from "recess"


main = () => {
  t = 0
  stop :: Recess.TimeSpanner {}
  stop = Recess.withInterval(
    200,
    () => {
      // ew, mutants!
      t := t + 1
      pipe(
        IO.pTrace(" " ++ show(t) ++ ". "),
      )(Date.now())
    },
  )
  Recess.wait(5000, stop)
}
```
## wishIntervalSource

The second core API of `recess` is `wishIntervalSource`, and its related function `wishInterval`.

`wishIntervalSource` takes the form:

```madlib_
wishWithAggregateValue = wishIntervalSource(initialValue, milliseconds, nullaryCancellationCallback, unaryOnEndCallback, binaryOnTickCallback)
```

To make that a little more concrete, here's an example:

```madlib^#wishIntervalSource

import Date from "Date"
import IO from "IO"
import Wish from "Wish"

import Recess from "recess"

alias Agg = { i :: Integer, lastUpdated :: Date.DateTime }
again :: ({} -> {}) -> Agg -> Agg
again = (stop, agg) => {
  j = agg.i + 1
  lastUpdated = Date.now()
  IO.pTrace(" " ++ show(agg.i) ++ ". ", lastUpdated)
  updated = { ...agg, i: j, lastUpdated }
  return if (j > 10) do {
    stop()
    return agg
  } else {
    updated
  }
}
onCancel = () => {}

onEnd = pipe(
  IO.pTrace("WHAT?"),
  .lastUpdated,
  Date.toDateInfo,
  ({ month, day, hours, minutes, year }) => "TODAY IS: "
    ++ show(day)
    ++ "/"
    ++ show(month)
    ++ "/"
    ++ show(year),
)
main = () => {
  pipe(
    Recess.wishIntervalSource(
      $,
      200,
      onCancel
      onEnd,
      again,
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
  )({ i: 0, lastUpdated: Date.now() })
}

```
This will run 10 times (`j > 10`) with 200 milliseconds between each call, printing the current iteration and a date time. Then it will print "WHAT?" with the full end state, and then print "TODAY IS: " and the last date formatted as a string.



