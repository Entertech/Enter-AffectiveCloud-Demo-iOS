//
//  DrawerView.swift
//  EnterAffectiveCloudDemo
//
//  Created by Enter on 2020/7/1.
//  Copyright © 2020 Enter. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

enum ChildVCState {
    case hidden
    case showHalf
    case showAll
    case null
}

class DrawerView: UIView, UIGestureRecognizerDelegate {
    
    private let showHalfY = Preference.screenHeight / 2 - 100                          //orign.y的view在中间位置
    let highCenter = Preference.screenHeight / 2 + 66                          //view在高的center.y
    lazy var middleCenter = Preference.screenHeight * 3 / 2 - 95 - showHalfY   //view在中的center.y
    var lowCenter: CGFloat {
        var offset = 0
        if !Device.current.isiphoneX  {
            offset = 30
        }
        return Preference.screenHeight * 3 / 2 - 95 + CGFloat(offset)
    }
    
    let nullCenter = Preference.screenHeight*3/2+24
    //view在低的center.y
    public var rx_vcState: Variable<ChildVCState> = Variable(.hidden)              //view的状态
    private let dispose = DisposeBag()
    private var tapGesture: UITapGestureRecognizer?
    private var panGesture: UIPanGestureRecognizer?
    var isNeedJump = true
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initMethod()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initMethod()
    }
    
    private func initMethod() {
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.showDataTap(_ :)))
        panGesture = UIPanGestureRecognizer(target: self, action: #selector(self.showDataPan(_:)))
        self.addGestureRecognizer(tapGesture!)
        self.addGestureRecognizer(panGesture!)
        tapGesture?.delegate = self
        panGesture?.delegate = self
        self.layer.cornerRadius = 20
        vcState = .hidden
        
    }
    
    public var gestureEnable: Bool {
        get {
            return tapGesture!.isEnabled
        }
        set {
            tapGesture?.isEnabled = newValue
            panGesture?.isEnabled = newValue
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        //监听center
        if isNeedJump {
            isNeedJump = false
            self.rx.observe(CGPoint.self, #keyPath(UIView.center)).subscribe(onNext: { (point) in
                let value = Preference.screenHeight * 3 / 2 - point!.y
                if value < 96 { //view最低位置 通过snp控制
                    self.vcState = .hidden
                    self.superview?.backgroundColor = UIColor(white: 0, alpha: 0)
                } else if value >= 96 && value < self.showHalfY + 100 {
                    self.vcState = .showHalf
                    self.superview?.backgroundColor = UIColor(white: 0, alpha: 0)
                } else {
                    self.superview?.backgroundColor = UIColor(white: 0, alpha: (value - self.showHalfY - 100) / 500)
                    self.vcState = .showAll
                }
            }).disposed(by: dispose)
        }

    }
    
    //子视图位置
    public var vcState: ChildVCState {
        get {
            return rx_vcState.value
        }
        set {
            rx_vcState.value = newValue
        }
    }
    public func viewShow(_ state: ChildVCState, finishBlock: EmptyBlock? = nil) {
        var offset: CGFloat = 0
        
        switch (state) {
        case .hidden:
            offset = middleCenter
        case .showHalf:
            offset = highCenter
        case .showAll:
            offset = middleCenter
        case .null:
            offset = nullCenter
        }
        UIView.animate(withDuration: 0.3, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 5, options: .curveEaseInOut, animations: {
            self.center = CGPoint(x: self.center.x, y: offset + 10)
        }) { (finish) in
            finishBlock?()
        }
    }
    
    @objc private func showDataTap(_ sender: UITapGestureRecognizer) {
        let tapPoint: CGPoint = sender.location(in: self)
        if tapPoint.y < 100 {
            viewShow(vcState)
        }
    }
    
    @objc private func showDataPan(_ sender: UIPanGestureRecognizer) {
        let centerY: CGFloat = (sender.view?.center.y)!
        if sender.state == .ended {
            
            let vel: CGPoint = sender.velocity(in: self.superview)
            if (vel.y > 0) { //down
                var offset: CGFloat = 0
                if vcState == .showHalf {
                    offset = lowCenter
                } else if vcState == .showAll {
                    offset = middleCenter
                }
                if offset != 0 {
                    UIView.animate(withDuration: 0.3, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 10, options: .curveEaseInOut, animations: {
                        self.center = CGPoint(x: self.center.x, y: offset)
                    }) { (finish) in
                        
                    }
                }
            } else {
                var offset: CGFloat = 0
                if centerY >= highCenter && centerY < middleCenter {
                    offset = highCenter
                } else if centerY >= middleCenter {
                    offset = middleCenter
                }
                if offset != 0 {
                    UIView.animate(withDuration: 0.3, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 10, options: .curveEaseInOut, animations: {
                        self.center = CGPoint(x: self.center.x, y: offset + 10)
                    }) { (finish) in
                        
                    }
                }
                
            }
        } else  {
            let transform: CGPoint = sender.translation(in: self.superview)
            var transformY = centerY + transform.y
            if transformY > lowCenter {
                transformY = lowCenter
            } else if transformY < highCenter {
                transformY = highCenter
            }
            self.center = CGPoint(x: self.center.x, y: transformY )
            sender.setTranslation(CGPoint(x: 0, y: 0), in: sender.view?.superview)
        }
    }
    
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if gestureRecognizer.isKind(of: UITapGestureRecognizer.classForCoder()) {
            if (NSStringFromClass(touch.view!.classForCoder) == "UITableViewCellContentView") || (NSStringFromClass(touch.view!.classForCoder) == "Flowtime.LessonCell") {
                return false
            }
        }
        
        return true
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer.isKind(of: UIPanGestureRecognizer.classForCoder()) {
            if otherGestureRecognizer.view!.isKind(of: UITableView.classForCoder()) {
                let tv = otherGestureRecognizer.view as! UITableView
                if tv.isScrollEnabled {
                    if tv.contentOffset.y <= 0.1 && (panGesture?.velocity(in: tv).y)! > CGFloat(0){
                        tv.isScrollEnabled = false
                    } else {
                        return false
                    }
                }
                tv.isScrollEnabled = true
                return true
            }
        }
        return false
    }
    
}
