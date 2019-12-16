//
//  GiveUpFirstResponder.swift
//  EnterAffectiveCloudDemo
//
//  Created by Enter on 2019/12/13.
//  Copyright © 2019 Enter. All rights reserved.
//

import UIKit

class GiveUpFirstResponderTextField: UITextField {

    override var canBecomeFirstResponder: Bool{
        return false
    }

}
