//
//  BuxticProgressBar.swift
//
//  Implements circular progress bar with gradient coloring
//   - Background bluring with given gradient colors
//   - Progress tracker with gradient colors
//   - Given a possibility to configure sizes
//
//  Created by Levon Poghosyan on 23/12/2020.
//  Copyright © 2020 Levon Poghosyan. All rights reserved.
//

import Foundation
import UIKit

class BuxticProgressBar: UIView {
    
    // MARK: - Progress displayed on circle and central label
    
    var progress: CGFloat = 0.4 {
        didSet { setNeedsDisplay() }
    }
    
    // MARK: - Percentage attributes
    var percentageColor: UIColor? = .systemRed {
        didSet { setNeedsDisplay() }
    }
    var percentageFont: UIFont? {
        didSet { setNeedsDisplay() }
    }
    
    var isPercentageHidden: Bool = false {
        didSet { setNeedsDisplay() }
    }
    
    // MARK: - Blured background coloring
    
    var blurStartGradientColor: UIColor = UIColor.systemRed {
        didSet { setNeedsDisplay() }
    }
    var blurEndGradientColor: UIColor = UIColor.systemBlue {
        didSet { setNeedsDisplay() }
    }
    
    var backOpacity: CGFloat = 0.1 {
        didSet { setNeedsDisplay() }
    }
    
    // MARK: - Tracker coloring
    
    var trackGradientStartColor: UIColor = UIColor.systemRed {
        didSet { setNeedsDisplay() }
    }
    var trackGradientEndColor: UIColor = UIColor.systemBlue {
        didSet { setNeedsDisplay() }
    }
    
    var trackBackgroundColor: UIColor? = .white {
        didSet { setNeedsDisplay() }
    }

    // MARK: - Tracker attributes
    
    var trackPadding: CGFloat = 12 {
        didSet { setNeedsDisplay() }
    }
    var trackerWidth: CGFloat = 20 {
        didSet { setNeedsDisplay() }
    }
    
    // MARK: - Tarcker background color
    var trackBackgroundWidth: CGFloat = 10 {
        didSet { setNeedsDisplay() }
    }
    
    private let percentage: UILabel = UILabel()
    
    // Background
    private let gradient : CAGradientLayer = CAGradientLayer()
    
    // Background Blur
    private let gradientBlur : CAGradientLayer = CAGradientLayer()
    
    // Circle Tracker
    private var backgroundMask = CAShapeLayer()
    
    // Tracker Background
    private var progressLayer = CAShapeLayer()
    
    init(gradientStartColor: UIColor, gradientEndColor: UIColor) {
        self.trackGradientStartColor = gradientStartColor
        self.trackGradientEndColor = gradientEndColor
        self.blurStartGradientColor = gradientStartColor
        self.blurEndGradientColor = gradientEndColor
        super.init(frame: .zero)
        setupLayers()
        self.addSubview(self.percentage)
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)
        gradient.frame = self.bounds
    }

    private func setupLayers() {
        // set layer properties
        layer.shadowRadius = 5
        layer.masksToBounds = true
        layer.borderWidth = 0.0
        
        gradient.colors = [trackGradientEndColor.cgColor, trackGradientStartColor.cgColor]
        gradient.startPoint = CGPoint(x: 1, y: 0)
        gradient.endPoint = CGPoint(x: 0, y: 1)
        layer.addSublayer(gradient)

        gradientBlur.opacity = Float(self.backOpacity)
        gradientBlur.colors = [blurEndGradientColor.cgColor, blurStartGradientColor.cgColor]
        gradientBlur.startPoint = CGPoint(x: 1, y: 0)
        gradientBlur.endPoint = CGPoint(x: 0, y: 1)
        layer.addSublayer(gradientBlur)
        
        backgroundMask.lineWidth = trackerWidth
        backgroundMask.fillColor = nil
        backgroundMask.strokeColor = UIColor.black.cgColor
        gradient.mask = backgroundMask

        progressLayer.lineWidth = trackBackgroundWidth
        progressLayer.fillColor = nil
        layer.addSublayer(progressLayer)
        layer.transform = CATransform3DMakeRotation(CGFloat(90 * Double.pi / 180), 0, 0, -1)
        
        self.percentage.layer.transform = CATransform3DMakeRotation(CGFloat(90 * Double.pi / 180), 0, 0, 1)
    }

    override func draw(_ rect: CGRect) {
        self.shapeMainLayer(rect)
        self.drawBackground(rect)
        self.drawProgressCircle(rect)
        self.shapePercentage(rect)
    }

    // MARK: - Main layer shape
    func shapeMainLayer(_ rect: CGRect) {
        layer.cornerRadius = rect.height / 2
    }

    // MARK: - Draw Background
    
    func drawBackground(_ rect: CGRect) {
        gradient.frame = self.bounds
        gradientBlur.frame = self.bounds
    }
    
    // MARK: - Progress circle
    func drawProgressCircle(_ rect: CGRect) {
        let trackerRect = CGRect(x: rect.origin.x + self.trackPadding,
                                 y: rect.origin.y + self.trackPadding,
                                 width: rect.width - 2 * trackPadding,
                                 height: rect.height - 2 * trackPadding)
        let circlePath = UIBezierPath(ovalIn: trackerRect.insetBy(dx: self.trackerWidth / 2, dy: self.trackerWidth / 2))
        backgroundMask.path = circlePath.cgPath
        backgroundMask.lineCap = .butt
        backgroundMask.strokeStart = 0
        backgroundMask.strokeEnd = progress

        let delta = (self.trackerWidth - self.trackBackgroundWidth) / 2
        let trackerBackRect = CGRect(x: rect.origin.x + self.trackPadding + delta,
                                     y: rect.origin.y + self.trackPadding + delta,
                                 width: rect.width - 2 * trackPadding - 2 * delta,
                                height: rect.height - 2 * trackPadding - 2 * delta)
        let trackBackCirclePath = UIBezierPath(ovalIn: trackerBackRect.insetBy(dx: self.trackBackgroundWidth / 2,
                                                                           dy: self.trackBackgroundWidth / 2))
        progressLayer.path = trackBackCirclePath.cgPath
        progressLayer.lineCap = .butt
        progressLayer.strokeStart = progress
        progressLayer.strokeEnd = 1
        progressLayer.strokeColor = self.trackBackgroundColor?.cgColor
    }
    
    // MARK: - Main layer shape
    func shapePercentage(_ rect: CGRect) {
        self.percentage.frame = rect
        self.percentage.textAlignment = .center
        self.percentage.textColor = self.percentageColor
        self.percentage.font = self.percentageFont
        
        // Update the text
        let convert: CGFloat = progress * CGFloat(100)
        self.percentage.text = String(format: "%d%%", Int(convert))
        self.percentage.isHidden = self.isPercentageHidden
    }
}
