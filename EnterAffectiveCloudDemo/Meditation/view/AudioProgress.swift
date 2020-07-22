//
//  MusicProgress.swift
//  Flowtime
//
//  Created by Enter on 2019/5/6.
//  Copyright © 2019 Enter. All rights reserved.
//

import UIKit
import Lottie

class AudioProgress: UIView {
    
    var circleColor = UIColor(red: 71.0/255.0, green: 86.0/255.0, blue: 176.0/255.0, alpha: 1)
    private let _audioAnimateColor = UIColor.white
    private let _halfWhiteColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.5)
    private var _bgColor = UIColor.clear
    private var _shapeLayer: CAShapeLayer?
    private var _bezierPath: UIBezierPath?
    private var _roundPath: UIBezierPath?
    private var _needDownloadAudio: Bool = false
    private var _waveProgress: BaseLoader = BaseLoader()
    private let strokeWidth: CGFloat = 4.0
    private let _aView = AnimationView()
    private var firstLayout = true

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        //fatalError("init(coder:) has not been implemented")
        super.init(coder: aDecoder)
        self.backgroundColor = UIColor.clear
    }
    
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        let context = UIGraphicsGetCurrentContext()!
        context.setLineWidth(strokeWidth)
        context.setStrokeColor(circleColor.cgColor)
        //context.setFillColor(_bgColor.cgColor)
        context.addPath(_bezierPath!.cgPath)
        context.drawPath(using: .stroke)
        
        context.setFillColor(_bgColor.cgColor)
        context.addPath(_roundPath!.cgPath)
        context.drawPath(using: .fill)
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if firstLayout {
            firstLayout = false
            _bezierPath = circleBezierPath()
            _roundPath = roundBezierPath()
            setNeedsDisplay()
            AudioProgress()
            downloadProgressSetting()
        }
    }
    
    public var needDownloadAudio: Bool {
        get {
            return _needDownloadAudio
        }
        set {
            _needDownloadAudio = newValue
            if newValue == true {
                _bgColor = UIColor.clear
                
            } else {
                _bgColor = _halfWhiteColor
                
            }
            setNeedsDisplay()
        }
    }
    

    /// current BezierPath
    ///
    /// - Returns: circlePath
    private func circleBezierPath() -> UIBezierPath{
        let halfWidth = self.bounds.width / 2
        let halfHeight = self.bounds.height / 2
        
        let circlePath = UIBezierPath(arcCenter: CGPoint(x: halfWidth, y: halfHeight), radius: halfWidth-2, startAngle: CGFloat(Double.pi*3/2), endAngle: CGFloat(Double.pi*7/2), clockwise: true)
        return circlePath
    }
    
    /// current BezierPath
    ///
    /// - Returns: roundPath
    private func roundBezierPath() -> UIBezierPath{
        let halfWidth = self.bounds.width / 2
        let halfHeight = self.bounds.height / 2
        
        let circlePath = UIBezierPath(arcCenter: CGPoint(x: halfWidth, y: halfHeight), radius: halfWidth-4, startAngle: CGFloat(Double.pi*3/2), endAngle: CGFloat(Double.pi*7/2), clockwise: true)
        return circlePath
    }
    
    /// set audio progress
    private func AudioProgress() {
        _shapeLayer = CAShapeLayer()
        self.layer.addSublayer(_shapeLayer!)
        _shapeLayer?.path = _bezierPath?.cgPath
        _shapeLayer?.lineWidth = CGFloat(strokeWidth)
        _shapeLayer?.strokeColor = _audioAnimateColor.cgColor
        _shapeLayer?.fillColor = UIColor.clear.cgColor
        _shapeLayer?.strokeStart = 0
        _shapeLayer?.strokeEnd = 0
    }
    
    
    /// set audioProgress animation
    ///
    /// - Parameters:
    ///   - percent: (0-1)
    ///   - animationDuration: 1s
    public func AudioProgressAnimate(percent: CGFloat) {
        if percent <= 1.0001 {  //精度问题
            _shapeLayer?.strokeEnd = percent
        }
    }
    
    
    /// set wave progress
    private func downloadProgressSetting() {
        _waveProgress = WaveProgress.createProgressBasedLoader(with: _bezierPath!.cgPath, on: self)
        _waveProgress.loaderColor = UIColor.white
        _waveProgress.loaderAlpha = 0.5
        _waveProgress.loaderBackgroundColor = UIColor.clear
        _waveProgress.loaderStrokeColor = UIColor.clear
        _waveProgress.backgroundColor = UIColor.clear
        _waveProgress.mainBgColor = UIColor.clear
    }
    
    /// circle animation
    public func downloadProgressAnimate(percent: CGFloat) {
        if _waveProgress.isHidden {
            _waveProgress.showLoader()
        }
        _waveProgress.progress = percent
    }
    
    /// remove wave animation
    public func downloadProgressRemove() {
        if !_waveProgress.isHidden {
            _waveProgress.removeLoader()
        }
    }

}
