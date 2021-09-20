//
//  SlotAnimator.swift
//  Leaderboard
//
//  Created by Amin
//

import UIKit

class SlotAnimator {
    
    typealias VoidHandler = ()->Void
    typealias UpdateHandler = (Int)->Void
    
    private var timer: Timer?
    private var duration: TimeInterval = 2
    
    private var completionHandler: VoidHandler?
    private var updateHandler: UpdateHandler?
    
    private let oldValue: Int
    private var newValue: Int
    
    init(from oldValue: Int, to newValue: Int) {
        self.oldValue = oldValue
        self.newValue = newValue
    }
    
    deinit {
        timer?.invalidate()
    }
    
    @discardableResult
    func observeUpdates(_ handler: @escaping UpdateHandler) -> Self {
        self.updateHandler = handler
        return self
    }
    
    @discardableResult
    func observeCompletion(_ handler: @escaping VoidHandler) -> Self {
        self.completionHandler = handler
        return self
    }
    
    func start(duration: TimeInterval = 2, after delay: TimeInterval = 0) {
        self.duration = duration
        updateHandler?(oldValue)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) { [weak self] in
            self?.startTimer()
        }
    }
    
    func cancel() {
        timerCompleted()
    }
    
    private func startTimer() {
        let isAscending = oldValue < newValue
        
        let interval = 0.1
        let changePerInterval = Int(Double(duration) / interval)
        let deltaIncrement = max(1, abs(oldValue - newValue) / changePerInterval)
        
        var currentValue = oldValue
        timer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { [weak self] (timer) in
            guard let _weakSelf = self else { timer.invalidate(); return }
            
            currentValue = {
                if isAscending {
                    return min(_weakSelf.newValue, currentValue + deltaIncrement)
                } else {
                    return max(_weakSelf.newValue, currentValue - deltaIncrement)
                }
            }()
            
            _weakSelf.updateHandler?(currentValue)
            
            if currentValue == _weakSelf.newValue {
                _weakSelf.timerCompleted()
            }
        }
    }
    
    func timerCompleted() {
        timer?.invalidate()
        completionHandler?()
    }
}
