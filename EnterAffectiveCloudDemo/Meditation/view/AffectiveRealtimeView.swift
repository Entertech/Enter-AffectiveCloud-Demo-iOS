//
//  AffectiveRealtimeView.swift
//  EnterAffectiveCloudDemo
//
//  Created by Enter on 2020/2/5.
//  Copyright © 2020 Enter. All rights reserved.
//

import UIKit

class AffectiveRealtimeView: UIView {
    
    public var values: (Float, Float, Float, Float, Float) = (0,0,0,0,0) {
        willSet {
            attentionArray.append(newValue.0)
            if attentionArray.count > 200 {
                attentionArray.remove(at: 0)
            }
            relaxationArray.append(newValue.1)
            if relaxationArray.count > 200 {
                relaxationArray.remove(at: 0)
            }
            arousalArray.append(newValue.2)
            if arousalArray.count > 200 {
                arousalArray.remove(at: 0)
            }
            pleasureArray.append(newValue.3)
            if pleasureArray.count > 200 {
                pleasureArray.remove(at: 0)
            }
            pressureArray.append(newValue.4)
            if pressureArray.count > 200 {
                pressureArray.remove(at: 0)
            }
            setNeedsDisplay()
        }
    }
    
    public var attentionValue: Float = 0 {
        willSet {
            attentionArray.append(newValue)
            if attentionArray.count > 200 {
                attentionArray.remove(at: 0)
            }
            setNeedsDisplay()
        }
    }
    
    public var relaxationValue: Float = 0 {
        willSet {
            relaxationArray.append(newValue)
            if relaxationArray.count > 200 {
                relaxationArray.remove(at: 0)
            }
        }
    }
    
    public var arousalValue: Float = 0 {
        willSet {
            arousalArray.append(newValue)
            if arousalArray.count > 200 {
                arousalArray.remove(at: 0)
            }
        }

    }
    
    public var pleasureValue: Float = 0 {
        willSet {
            pleasureArray.append(newValue)
            if pleasureArray.count > 200 {
                pleasureArray.remove(at: 0)
            }
        }
    }
    
    public var pressureValue: Float = 0 {
        willSet {
            pressureArray.append(newValue)
            if pressureArray.count > 200 {
                pressureArray.remove(at: 0)
            }
        }
    }
    
    private enum AffectiveType: Int {
        case pressure = 4
        case pleasure = 3
        case arousal = 2
        case relaxation = 1
        case attention = 0
    }
    
    private var attentionArray: [Float] = []
    private var relaxationArray: [Float] = []
    private var arousalArray: [Float] = []
    private var pleasureArray: [Float] = []
    private var pressureArray: [Float] = []
    
    private var dots: [UIView] = []
    private var lines: [AffectiveType] = [.attention, .relaxation, .arousal, .pleasure, .pressure]
    private let chartView = UIView()
    private let colors: [UIColor] = [#colorLiteral(red: 0.368627451, green: 0.4588235294, blue: 0.9960784314, alpha: 1),#colorLiteral(red: 0.3215686275, green: 0.6352941176, blue: 0.4862745098, alpha: 1),#colorLiteral(red: 1, green: 0.7725490196, blue: 0.4352941176, alpha: 1),#colorLiteral(red: 0.4, green: 0.2823529412, blue: 1, alpha: 1),#colorLiteral(red: 1, green: 0.4, blue: 0.5098039216, alpha: 1)]
    private let lineName: [String] = [lang("注意力"), lang("放松度"), lang("激活度"), lang("愉悦度"), lang("压力值")]
    private var height: CGFloat = 0
    private var width: CGFloat = 0
    private var minHeight: CGFloat = 0
    private var minWidth: CGFloat = 0
    private var heightSplit: CGFloat = 100
    private var widthSplit: CGFloat = 160.0 / 0.8
    private var chartLeft: CGFloat = 0
    private var chartRight: CGFloat = 0
    private var chartBottom: CGFloat = 0
    private var chartTop: CGFloat = 0
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUI()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        height = chartView.bounds.height
        width = chartView.bounds.width
        minWidth = width / widthSplit
        minHeight = height / heightSplit
        chartLeft = chartView.frame.origin.x
        chartTop = chartView.frame.origin.y
        chartBottom = chartTop + height
        chartRight = chartLeft + width
        drawGrid()
    }
    
    private func setUI() {
        self.layer.cornerRadius = 8
        let titleLabel = UILabel()
        self.addSubview(titleLabel)
        titleLabel.text = lang("情绪变化")
        titleLabel.font = UIFont.systemFont(ofSize: 15)
        titleLabel.textColor = #colorLiteral(red: 0.137254902, green: 0.137254902, blue: 0.137254902, alpha: 1)
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(8)
            $0.left.equalToSuperview().offset(16)
        }

        for i in 0...4 {
            let textBtn = UIButton()
            self.addSubview(textBtn)
            textBtn.setTitle(lineName[i], for: .normal)
            textBtn.setTitleColor(#colorLiteral(red: 0.6, green: 0.6, blue: 0.6, alpha: 1), for: .normal)
            textBtn.titleLabel?.font = UIFont.systemFont(ofSize: 8)
            textBtn.titleLabel?.textAlignment = .left
            textBtn.tag = i
            textBtn.addTarget(self, action: #selector(setLine(_:)), for: .touchUpInside)
            textBtn.snp.makeConstraints {
                $0.height.equalTo(13)
                $0.width.equalTo(32)
                $0.right.equalTo(-(22 + i * 32 + 20 * i))
                $0.centerY.equalTo(titleLabel.snp.centerY)
            }
            
            let dot = UIView()
            self.addSubview(dot)
            dot.backgroundColor = colors[i]
            dot.layer.cornerRadius = 3
            dot.snp.makeConstraints {
                $0.right.equalTo(textBtn.snp.left).offset(-3)
                $0.width.height.equalTo(6)
                $0.centerY.equalTo(titleLabel.snp.centerY)
            }
            dots.append(dot)
        }
        
        self.addSubview(chartView)
        chartView.backgroundColor = .clear
        chartView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(33)
            $0.bottom.equalToSuperview().offset(-24)
            $0.left.equalToSuperview().offset(16)
            $0.right.equalToSuperview().offset(-8)
        }
        var labels: UILabel?
        for i in 0...7 {
            let numLabel = UILabel()
            self.addSubview(numLabel)
            numLabel.text = "\(i*20 + 20)"
            numLabel.textAlignment = .left
            numLabel.font = UIFont.systemFont(ofSize: 8)
            numLabel.textColor = #colorLiteral(red: 0.137254902, green: 0.137254902, blue: 0.137254902, alpha: 1)
            numLabel.snp.makeConstraints {
                $0.bottom.equalToSuperview().offset(-6)
                $0.width.equalTo(chartView.snp.width).dividedBy(8)
                if i == 0 {
                    $0.right.equalTo(chartView.snp.right).offset(-2)
                } else {
                    $0.right.equalTo(labels!.snp.left)
                }
            }
            labels = numLabel
        }
        
        let unitLabel = UILabel()
        self.addSubview(unitLabel)
        unitLabel.text = lang("(秒)")
        unitLabel.textAlignment = .center
        unitLabel.font = UIFont.systemFont(ofSize: 8)
        unitLabel.textColor = #colorLiteral(red: 0.137254902, green: 0.137254902, blue: 0.137254902, alpha: 1)
        unitLabel.snp.makeConstraints {
            $0.right.equalToSuperview().offset(-8)
            $0.bottom.equalToSuperview().offset(-6)
        }
    }
    
    @objc func setLine(_ sender: UIButton) {
        let index = sender.tag
        guard let tag = AffectiveType(rawValue: index) else { return }
        if lines.contains(tag) {
            for i in 0..<lines.count {
                if lines[i] == tag {
                    lines.remove(at: i)
                    break
                }
            }
            dots[index].backgroundColor = .lightGray
        } else {
            dots[index].backgroundColor = colors[index]
            lines.append(tag)
        }
        
    }
    
    private func drawGrid() {
        guard height != 0 else {
            return
        }
        let dashLineColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        var strideBy = height / 4.0 - 0.1
        for i in stride(from: 0, to: height, by: strideBy) {
            let dashPath = UIBezierPath()
            dashPath.move(to: CGPoint(x: 0, y: i))
            dashPath.addLine(to: CGPoint(x: width, y: i))
            let dashLayer = CAShapeLayer()
            dashLayer.lineWidth = 0.3
            dashLayer.backgroundColor = UIColor.clear.cgColor
            dashLayer.strokeColor = dashLineColor.cgColor
            dashLayer.path = dashPath.cgPath
            chartView.layer.addSublayer(dashLayer)
        }
        
        strideBy = width / 16 - 0.05
        for i in stride(from: 0, to: width, by: strideBy) {
            let dashPath = UIBezierPath()
            dashPath.move(to: CGPoint(x: i, y: 0))
            dashPath.addLine(to: CGPoint(x: i, y: height))
            let dashLayer = CAShapeLayer()
            dashLayer.lineWidth = 0.3
            dashLayer.backgroundColor = UIColor.clear.cgColor
            dashLayer.strokeColor = dashLineColor.cgColor
            dashLayer.path = dashPath.cgPath
            chartView.layer.addSublayer(dashLayer)
        }
    }
    
    override func draw(_ rect: CGRect) {
        if lines.contains(.attention) {
            let array = attentionArray
            let count = array.count
            var nodeArray: [CGPoint] = Array.init()
            guard let context = UIGraphicsGetCurrentContext() else {
                return
            }
            
            for (index,e) in array.enumerated() {
                if index > 200 {
                    break
                }
                let pointX = chartRight - (CGFloat(count-index-1) * minWidth)
                let pointY = chartBottom - CGFloat(e) * minHeight
                let node = CGPoint(x: pointX, y: pointY)
                nodeArray.append(node)
            }
            context.setStrokeColor(colors[0].cgColor)
            context.setLineWidth(1)
            context.setLineJoin(.round)
            context.move(to: CGPoint(x: 1, y: chartBottom))
            context.addLines(between: nodeArray)
            context.strokePath()
        }
        if lines.contains(.relaxation) {
            let array = relaxationArray
            let count = array.count
            var nodeArray: [CGPoint] = Array.init()
            guard let context = UIGraphicsGetCurrentContext() else {
                return
            }
            
            for (index,e) in array.enumerated() {
                if index > 200 {
                    break
                }
                let pointX = chartRight - (CGFloat(count-index-1) * minWidth)
                let pointY = chartBottom - CGFloat(e) * minHeight
                let node = CGPoint(x: pointX, y: pointY)
                nodeArray.append(node)
            }
            context.setStrokeColor(colors[1].cgColor)
            context.setLineWidth(1)
            context.setLineJoin(.round)
            context.move(to: CGPoint(x: 1, y: chartBottom))
            context.addLines(between: nodeArray)
            context.strokePath()
        }
        if lines.contains(.arousal) {
            let array = arousalArray
            let count = array.count
            var nodeArray: [CGPoint] = Array.init()
            guard let context = UIGraphicsGetCurrentContext() else {
                return
            }
            
            for (index,e) in array.enumerated() {
                if index > 200 {
                    break
                }
                let pointX = chartRight - (CGFloat(count-index-1) * minWidth)
                let pointY = chartBottom - CGFloat(e) * minHeight
                let node = CGPoint(x: pointX, y: pointY)
                nodeArray.append(node)
            }
            context.setStrokeColor(colors[2].cgColor)
            context.setLineWidth(1)
            context.setLineJoin(.round)
            context.move(to: CGPoint(x: 1, y: chartBottom))
            context.addLines(between: nodeArray)
            context.strokePath()
        }
        if lines.contains(.pleasure) {
            let array = pleasureArray
            let count = array.count
            var nodeArray: [CGPoint] = Array.init()
            guard let context = UIGraphicsGetCurrentContext() else {
                return
            }
            
            for (index,e) in array.enumerated() {
                if index > 200 {
                    break
                }
                let pointX = chartRight - (CGFloat(count-index-1) * minWidth)
                let pointY = chartBottom - CGFloat(e) * minHeight
                let node = CGPoint(x: pointX, y: pointY)
                nodeArray.append(node)
            }
            context.setStrokeColor(colors[3].cgColor)
            context.setLineWidth(1)
            context.setLineJoin(.round)
            context.move(to: CGPoint(x: 1, y: chartBottom))
            context.addLines(between: nodeArray)
            context.strokePath()
        }
        if lines.contains(.pressure) {
            let array = pressureArray
            let count = array.count
            var nodeArray: [CGPoint] = Array.init()
            guard let context = UIGraphicsGetCurrentContext() else {
                return
            }
            
            for (index,e) in array.enumerated() {
                if index > 200 {
                    break
                }
                let pointX = chartRight - (CGFloat(count-index-1) * minWidth)
                let pointY = chartBottom - CGFloat(e) * minHeight
                let node = CGPoint(x: pointX, y: pointY)
                nodeArray.append(node)
            }
            context.setStrokeColor(colors[4].cgColor)
            context.setLineWidth(1)
            context.setLineJoin(.round)
            context.move(to: CGPoint(x: 1, y: chartBottom))
            context.addLines(between: nodeArray)
            context.strokePath()
        }
        

        
    }
}
