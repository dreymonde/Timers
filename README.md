# Timers

**Swift NSTimers that don't suck**

<a href="https://u24.gov.ua">
  <img src="Media/donate.png" height="70">
</a>

---

> Medium article: [Simplifying Swift Timers: solving memory leaks & complexity once and for all](https://medium.com/@olegdreyman/simplify-working-with-timers-in-swift-uikit-1fecfeba4f29)

**Timers** is a lightweight package that provides a convenient way to handle and manage timers in Swift, especially in view controllers to automatically manage lifetime of timers.

```swift
import Timers

final class RefreshingViewController: UIViewController {
    let timers = Timers()

    func viewDidLoad() {
        super.viewDidLoad()
        
        timers.addRepeating(timeInterval: 1.0, withTarget: self) { (self) in
            self.reloadData()
        }
    }
    
    func reloadData() {
        // reload your data here
    }
}
```


**Timers** takes care of invalidating the timers when the view controller is deinitialized, eliminating the need to do it manually.

> **Note**<br>
> Help save Ukraine. [Donate via United24](https://u24.gov.ua), the official fundraising platform by the President of Ukraine

<a href="https://u24.gov.ua">
  <img src="Media/united24.jpg" width="75%" height="75%">
</a>

## Features

- [x] Automatically manages timers lifetime: no need to worry about memory leaks
- [x] Repeated timers
- [x] One-off timers
- [x] Timers that fire at a specific date and then repeat with a set interval
- [x] Full access to `Foundation.Timer` APIs for more complex use cases
- [x] Easy to extend
- [x] Unit-tested

## Installation

### Swift Package Manager
1. Click File &rarr; Swift Packages &rarr; Add Package Dependency.
2. Enter `https://github.com/dreymonde/Timers.git`

> **Note**<br>
> **Timers** is a very simple library and only consists of one file (Timers.swift). Do not expect updates, this release is likely final. If you need additional functionality, feel free to fork or copy Timers.swift directly into your project and extend. PRs are also welcome.

## Guide

> All these timers are managed by the `Timers` instance and are invalidated automatically when the `Timers` instance is deallocated.

### Creating a Basic Repeating Timer

```swift
import Timers

final class MyViewController: UIViewController {
    let timers = Timers()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        timers.addRepeating(timeInterval: 1.0, withTarget: self) { (self, timer) in
            self.reloadData()
        }
    }
    
    func reloadData() {
        // reload your data here
    }
}
```

### Creating a Repeating Timer with Tolerance
```swift
timers.addRepeating(timeInterval: 1.0, tolerance: 0.1, withTarget: self) { (self) in
    self.reloadData()
}
```
In this case, the timer will have a slight tolerance of 0.1 seconds which allows the system to adjust the firing of the timer for better system performance.

### Creating a Timer that Fires Once at a Specific Date
```swift
let date = Date().addingTimeInterval(5) // Date 5 seconds from now

timers.fireAt(date, withTarget: self) { (self) in
    self.reloadData()
}

// or:

timers.fireAfter(timeInterval: 5, withTarget: self) { (self) in
    self.reloadData()
}
```

### Creating a Timer that Fires at a Specific Date and Repeats at a Set Interval
```swift
timers.addRepeating(
    initiallyFireAt: Date().addingTimeInterval(10),
    thenRepeatWithInterval: 5.0,
    withTarget: self
) { (self, timer) in
    self.reloadData()
}
```

### Creating a Timer Manually

For a more custom use case where you want to add the timer manually:

```swift
let customTimer = Timer(timeInterval: 1.0, repeats: true) { _ in
    print("This is a custom timer")
}

timers.addTimerManually(timer: customTimer)
```

### Clearing All Timers

At any point if you want to stop and invalidate all timers you can call:

```swift
timers.clear()
```

## See also

 - **[Time](https://github.com/dreymonde/Time)** by [@dreymonde](https://github.com/dreymonde) - Type-safe time calculations in Swift, powered by generics
 - **[DateBuilder](https://github.com/dreymonde/DateBuilder)** by [@dreymonde](https://github.com/dreymonde) - Create dates and date components easily, of any complexity (e.g. "first Thursday of the next month")