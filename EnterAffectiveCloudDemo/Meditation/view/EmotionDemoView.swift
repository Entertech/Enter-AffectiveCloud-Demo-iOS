//
//  EmotionDemoView.swift
//  EnterAffectiveCloudDemo
//
//  Created by Enter on 2020/2/6.
//  Copyright © 2020 Enter. All rights reserved.
//

import UIKit

class EmotionDemoView: UIView {
    /// param:愉悦度,  激活度
    public var emotionValue:(Int, Int) = (0, 0) {
        willSet {
            DispatchQueue.main.async {
                self.dot.snp.remakeConstraints {
                    $0.width.height.equalTo(6)
                    $0.left.equalToSuperview().offset(self.minWidth*CGFloat(newValue.0))
                    $0.bottom.equalToSuperview().offset(-self.minHeight*(CGFloat(newValue.1)))
                }
            }
            var name = ""
            switch newValue {
            case (0...22, 76...100):
                name = "P0-22A75-100"
                
            case (23...45, 76...100):
                name = "P22-45A75-100"

            case (46...55, 76...100):
                name = "P45-55A75-100"

            case (56...78, 76...100):
                name = "P55-78A75-100"

            case (79...100, 76...100):
                name = "P78-100A75-100"

            case (0...40, 0...25):
                name = "P0-40A0-25"

            case (41...60, 0...25):
                name = "P40-60A0-25"

            case (61...100, 0...25):
                name = "P60-100A0-25"

            case (61...100, 26...50):
                name = "P60-100A25-50"

            case (0...40, 26...50):
                name = "P0-40A25-50"

            case (0...45, 51...75):
                name = "P0-45A50-75"

            case (76...100, 51...75):
                name = "P75-100A50-75"

            default:
                name = "else"
            }
            if name != gifName {
                DispatchQueue.main.async {
                    for e in self.subviews {
                        if e.isKind(of: UIImageView.classForCoder()) {
                            e.removeFromSuperview()
                            break
                        }
                    }
                    let gifImageView = UIImageView()
                    self.addSubview(gifImageView)
                    gifImageView.animationImages = UIImage.resolveGifImage(gif: name, any: self.classForCoder)
                    gifImageView.animationDuration = 3
                    gifImageView.animationRepeatCount = Int.max
                    gifImageView.startAnimating()
                    gifImageView.snp.makeConstraints {
                        $0.top.equalToSuperview().offset(0)
                        $0.bottom.equalToSuperview().offset(-16)
                        $0.right.equalToSuperview().offset(-40)
                        $0.width.equalTo(gifImageView.snp.height).dividedBy(1.17)
                    }
                    self.gifName = name
                }

                
            }
            
        }
    }
    private var gifName:String = "else"
    private let chartView = UIView()

    private let dot = UIView()
    private var chartHeight: CGFloat = 0
    private var chartWidth: CGFloat = 0
    private let widthSplit:CGFloat = 100
    private let heightSplit:CGFloat = 100
    private var minWidth:CGFloat = 0
    private var minHeight:CGFloat = 0

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUI()
    }
    private var isFirstTime = true
    override func layoutSubviews() {
        super.layoutSubviews()
        guard isFirstTime else {
            return
        }
        isFirstTime = false
        chartHeight = chartView.bounds.height
        chartWidth = chartView.bounds.width
        minWidth = chartWidth / widthSplit
        minHeight = chartHeight / heightSplit
        
        drawGrid()
        
    }
    
    open override func willMove(toWindow newWindow: UIWindow?) {
        super.willMove(toWindow: newWindow)
        if let _ = newWindow {
            for e in self.subviews {
                if e.isKind(of: UIImageView.classForCoder()) {
                    let iv = e as! UIImageView
                    if !iv.isAnimating {
                        iv.startAnimating()
                    }
                    break
                }
            }
        }
    }
    
    private func setUI() {
        self.backgroundColor = #colorLiteral(red: 0.1176470588, green: 0.1411764706, blue: 0.262745098, alpha: 1)
        self.layer.cornerRadius = 8
        
        self.addSubview(chartView)
        chartView.backgroundColor = .clear
        chartView.snp.makeConstraints {
            $0.left.equalToSuperview().offset(60)
            $0.top.equalToSuperview().offset(16)
            $0.width.equalTo(200)
            $0.bottom.equalToSuperview().offset(-24)
        }
        chartView.addSubview(dot)
        dot.backgroundColor = .cyan
        dot.layer.cornerRadius = 3
        dot.snp.makeConstraints {
            $0.width.height.equalTo(6)
            $0.left.bottom.equalToSuperview()
        }
        
        let leftTopLabel = UILabel()
        leftTopLabel.text = "烦躁"
        leftTopLabel.textColor = UIColor(white: 1, alpha: 0.4)
        leftTopLabel.font = UIFont.systemFont(ofSize: 12)
        chartView.addSubview(leftTopLabel)
        leftTopLabel.snp.makeConstraints {
            $0.left.equalToSuperview().offset(2)
            $0.top.equalToSuperview().offset(1)
        }
        let leftBottomLabel = UILabel()
        leftBottomLabel.text = "郁闷"
        leftBottomLabel.textColor = UIColor(white: 1, alpha: 0.4)
        leftBottomLabel.font = UIFont.systemFont(ofSize: 12)
        chartView.addSubview(leftBottomLabel)
        leftBottomLabel.snp.makeConstraints {
            $0.left.equalToSuperview().offset(2)
            $0.bottom.equalToSuperview().offset(-1)
        }
        let rightTopLabel = UILabel()
        rightTopLabel.text = "兴奋"
        rightTopLabel.textColor = UIColor(white: 1, alpha: 0.4)
        rightTopLabel.font = UIFont.systemFont(ofSize: 12)
        chartView.addSubview(rightTopLabel)
        rightTopLabel.snp.makeConstraints {
            $0.right.equalToSuperview().offset(-2)
            $0.top.equalToSuperview().offset(1)
        }
        
        let rightBottomLabel = UILabel()
        rightBottomLabel.text = "愉悦"
        rightBottomLabel.textColor = UIColor(white: 1, alpha: 0.4)
        rightBottomLabel.font = UIFont.systemFont(ofSize: 12)
        chartView.addSubview(rightBottomLabel)
        rightBottomLabel.snp.makeConstraints {
            $0.right.equalToSuperview().offset(-2)
            $0.bottom.equalToSuperview().offset(-1)
        }
        
        let yLabel = UILabel()
        yLabel.text = "激活"
        yLabel.textColor = .white
        yLabel.textAlignment = .right
        yLabel.font = UIFont.systemFont(ofSize: 8)
        self.addSubview(yLabel)
        yLabel.snp.makeConstraints {
            $0.right.equalTo(chartView.snp.left).offset(-2)
            $0.top.equalToSuperview().offset(18)
        }
        
        let xLabel = UILabel()
        xLabel.text = "愉悦"
        xLabel.textColor = .white
        xLabel.font = UIFont.systemFont(ofSize: 8)
        xLabel.textAlignment = .right
        self.addSubview(xLabel)
        xLabel.snp.makeConstraints {
            $0.top.equalTo(chartView.snp.bottom).offset(2)
            $0.right.equalTo(chartView.snp.right).offset(2)
        }
        let gifImageView = UIImageView()
        self.addSubview(gifImageView)
        gifImageView.animationImages = UIImage.resolveGifImage(gif: "else", any: classForCoder)
        gifImageView.animationDuration = 3
        gifImageView.animationRepeatCount = Int.max
        gifImageView.startAnimating()
        gifImageView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(0)
            $0.bottom.equalToSuperview().offset(-16)
            $0.right.equalToSuperview().offset(-40)
            $0.width.equalTo(gifImageView.snp.height).dividedBy(1.17)
        }
    }
    
    private func drawGrid() {
        let leftPath = UIBezierPath()
        leftPath.move(to: CGPoint(x: 0, y: 1))
        leftPath.addLine(to: CGPoint(x: 0, y: chartHeight))
        let leftLayer = CAShapeLayer()
        leftLayer.lineWidth = 0.3
        leftLayer.backgroundColor = UIColor.clear.cgColor
        leftLayer.strokeColor = UIColor(white: 1, alpha: 0.4).cgColor
        leftLayer.path = leftPath.cgPath
        chartView.layer.addSublayer(leftLayer)
        
        let bottomPath = UIBezierPath()
        bottomPath.move(to: CGPoint(x: 0, y: chartHeight))
        bottomPath.addLine(to: CGPoint(x: chartWidth-1, y: chartHeight))
        let bottomLayer = CAShapeLayer()
        bottomLayer.lineWidth = 0.3
        bottomLayer.backgroundColor = UIColor.clear.cgColor
        bottomLayer.strokeColor = UIColor(white: 1, alpha: 0.4).cgColor
        bottomLayer.path = bottomPath.cgPath
        chartView.layer.addSublayer(bottomLayer)

        let topPath = UIBezierPath()
        topPath.move(to: CGPoint(x: 0, y: 0))
        topPath.addLine(to: CGPoint(x: chartWidth, y: 0))
        let topLayer = CAShapeLayer()
        topLayer.lineWidth = 0.3
        topLayer.lineDashPhase = 1
        topLayer.lineDashPattern = [2, 3]
        topLayer.backgroundColor = UIColor.clear.cgColor
        topLayer.strokeColor = UIColor(white: 1, alpha: 0.4).cgColor
        topLayer.path = topPath.cgPath
        chartView.layer.addSublayer(topLayer)
        
        let rightPath = UIBezierPath()
        rightPath.move(to: CGPoint(x: chartWidth, y: 0))
        rightPath.addLine(to: CGPoint(x: chartWidth, y: chartHeight))
        let rightLayer = CAShapeLayer()
        rightLayer.lineWidth = 0.3
        rightLayer.lineDashPhase = 1
        rightLayer.lineDashPattern = [2, 3]
        rightLayer.backgroundColor = UIColor.clear.cgColor
        rightLayer.strokeColor = UIColor(white: 1, alpha: 0.4).cgColor
        rightLayer.path = rightPath.cgPath
        chartView.layer.addSublayer(rightLayer)
    }
}
