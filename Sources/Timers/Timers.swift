import Foundation

public final class Timers {
    
    internal var timers: [Foundation.Timer] = []
    
    public init() { }
    
    public func clear() {
        for timer in timers {
            timer.invalidate()
        }
        timers = []
    }
    
    deinit {
        clear()
    }
}

// MARK: - Core Functions

extension Timers {
    public func manuallyAddTimer(
        runLoop: RunLoop = .main,
        runLoopMode: RunLoop.Mode = .common,
        timer: Timer
    ) {
        runLoop.add(timer, forMode: runLoopMode)
        timers.append(timer)
    }

    public typealias TimerBlock = (Timer) -> Void
    
    public func addCustomTimer<TargetType: AnyObject>(
        withTarget target: TargetType,
        handler: @escaping (TargetType, Timer) -> Void,
        runLoop: RunLoop = .main,
        runLoopMode: RunLoop.Mode = .common,
        makeTimer: @escaping (_ timerBlock: @escaping TimerBlock) -> Timer
    ) {
        let newTimer = makeTimer { [weak target] (timer) in
            if let target {
                handler(target, timer)
            }
        }
        manuallyAddTimer(
            runLoop: runLoop,
            runLoopMode: runLoopMode,
            timer: newTimer
        )
    }
}

// MARK: - Public Helper Functions

extension Timers {
    public func addRepeating<TargetType: AnyObject>(
        timeInterval: TimeInterval,
        tolerance: TimeInterval = 0,
        withTarget target: TargetType,
        handler: @escaping (TargetType, Timer) -> Void
    ) {
        addCustomTimer(withTarget: target, handler: handler) { timerBlock in
            let timer = Timer(timeInterval: timeInterval, repeats: true, block: timerBlock)
            timer.tolerance = tolerance
            return timer
        }
    }

    public func addRepeating<TargetType: AnyObject>(
        timeInterval: TimeInterval,
        tolerance: TimeInterval = 0,
        withTarget target: TargetType,
        handler: @escaping (TargetType) -> Void
    ) {
        addRepeating(
            timeInterval: timeInterval,
            tolerance: tolerance,
            withTarget: target,
            handler: { target, _ in handler(target) }
        )
    }
}

extension Timers {
    public func addRepeating<TargetType: AnyObject>(
        initiallyFireAt fireAt: Date,
        thenRepeatWithInterval timeInterval: TimeInterval,
        tolerance: TimeInterval = 0,
        withTarget target: TargetType,
        handler: @escaping (TargetType, Timer) -> Void
    ) {
        addCustomTimer(
            withTarget: target,
            handler: handler,
            makeTimer: { timerBlock in
                let timer = Timer(
                    fire: fireAt,
                    interval: timeInterval,
                    repeats: true,
                    block: timerBlock
                )
                timer.tolerance = tolerance
                return timer
            }
        )
    }
    
    public func addRepeating<TargetType: AnyObject>(
        initiallyFireAt fireAt: Date,
        thenRepeatWithInterval timeInterval: TimeInterval,
        tolerance: TimeInterval = 0,
        withTarget target: TargetType,
        handler: @escaping (TargetType) -> Void
    ) {
        addRepeating(
            initiallyFireAt: fireAt,
            thenRepeatWithInterval: timeInterval,
            tolerance: tolerance,
            withTarget: target,
            handler: { target, _ in handler(target) }
        )
    }
}

extension Timers {
    /// Fires once
    public func fireAt<TargetType: AnyObject>(
        _ fireAt: Date,
        withTarget target: TargetType,
        handler: @escaping (TargetType) -> Void
    ) {
        addCustomTimer(
            withTarget: target,
            handler: { target, _ in handler(target) },
            makeTimer: { timerBlock in
                Timer(fire: fireAt, interval: 0, repeats: false, block: timerBlock)
            }
        )
    }
    
    /// Fires once
    public func fireAfter<TargetType: AnyObject>(
        timeInterval: TimeInterval,
        withTarget target: TargetType,
        handler: @escaping (TargetType) -> Void
    ) {
        fireAt(
            Date().addingTimeInterval(timeInterval),
            withTarget: target,
            handler: handler
        )
    }
}
