//
//  LocalPlayer.swift
//  EnterAffectiveCloudDemo
//
//  Created by Enter on 2020/6/28.
//  Copyright © 2020 Enter. All rights reserved.
//

import Foundation
import AVFoundation

class LocalPlayer {

    init?(_ url: URL) {
        do {
            self.player = try AVAudioPlayer(contentsOf: url)
            self.player.prepareToPlay()
            self.setupSession()
        } catch {
            return nil
        }
    }
    var isLoop: Bool = false {
        didSet {
            if isLoop {
                self.player.numberOfLoops = -1
            } else {
                self.player.numberOfLoops = 1
            }
        }
    }

    var current: TimeInterval {
        return player.currentTime
    }

    var duration: TimeInterval {
        return player.duration
    }

    let player: AVAudioPlayer

    func play() {
        self.player.play()
    }

    func pause() {
        self.player.pause()
    }

    func stop() {
        self.player.stop()
    }

    private func setupSession() {
        try! AVAudioSession.sharedInstance().setCategory(.playback,
                                                    mode: .default)
    }
}
