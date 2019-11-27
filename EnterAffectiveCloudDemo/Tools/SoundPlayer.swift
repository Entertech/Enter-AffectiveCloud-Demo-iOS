//
//  SoundPlayer.swift
//  EnterAffectiveCloudDemo
//
//  Created by Enter on 2019/11/15.
//  Copyright © 2019 Enter. All rights reserved.
//

import AudioToolbox

class SoundPlayer {
    var soundID: SystemSoundID = 0
    init(_ url: URL, soundID: SystemSoundID) {
        self.soundID = soundID
        AudioServicesCreateSystemSoundID(url as CFURL, &self.soundID)
    }

    var numberOfLoops = 1

    func play() {
        AudioServicesPlayAlertSound(soundID)
    }
}
