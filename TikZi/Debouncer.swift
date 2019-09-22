//
//  Debouncer.swift
//  TikZi
//
//  Created by Luka Kerr on 21/9/19.
//  Copyright © 2019 Luka Kerr. All rights reserved.
//

import Foundation

class Debouncer {

  var callback: (() -> Void)
  var delay: Double
  weak var timer: Timer?

  init(delay: Double, callback: @escaping (() -> Void)) {
    self.delay = delay
    self.callback = callback
  }

  public func call() {
    timer?.invalidate()

    let nextTimer = Timer.scheduledTimer(
      timeInterval: delay,
      target: self,
      selector: #selector(fire),
      userInfo: nil,
      repeats: false
    )

    timer = nextTimer
  }

  @objc private func fire() {
    callback()
  }

}
