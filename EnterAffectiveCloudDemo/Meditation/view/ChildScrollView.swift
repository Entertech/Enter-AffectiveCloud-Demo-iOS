//
//  ChildScrollView.swift
//  EnterAffectiveCloudDemo
//
//  Created by Enter on 2020/7/1.
//  Copyright © 2020 Enter. All rights reserved.
//

import UIKit

class ChildScrollView: UIScrollView, UIGestureRecognizerDelegate {

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer == self.panGestureRecognizer {
            let panGes = gestureRecognizer as! UIPanGestureRecognizer
            
            if self.contentOffset.y == 0 && panGes.velocity(in: panGes.view).y > 0{
                return true
            }
        }
        return false
    }
}
