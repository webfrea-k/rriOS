//
//  CircularProgressClock.swift
//  Rain Radar
//
//  Created by Simon Hočevar on 22/03/2018.
//  Copyright © 2018 Simon Hočevar. All rights reserved.
//

//
//  CircularProgressClock.swift
//  CircularProgressClock
//
//  Created by Simon Hočevar on 22/03/2018.
//  Copyright © 2018 Simon Hočevar. All rights reserved.
//

import Foundation

import UIKit

@IBDesignable
open class CircularProgressClock: UIView {
    var view: UIView!
    
    static let startAngle = 3/2 * CGFloat.pi
    static let endAngle = 7/2 * CGFloat.pi
    
    let darkBorderLayer = BorderLayer()
    let progressBorderLayer = BorderLayer()
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBInspectable var title: String = "" {
        didSet {
            titleLabel.text = title
        }
    }
    
    @IBInspectable var progress: CGFloat = 0.0 {
        didSet {
            progressBorderLayer.endAngle = CircularProgressClock.radianForValue(progress)
        }
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadViewFromNib()
        commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib()
        commonInit()
    }
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        darkBorderLayer.frame = self.bounds
        progressBorderLayer.frame = self.bounds
        
        progressBorderLayer.setNeedsDisplay()
        darkBorderLayer.setNeedsDisplay()
    }
    
    open func commonInit() {
        darkBorderLayer.lineColor = UIColor(
            red: 255/255,
            green: 255/255,
            blue: 255/255,
            alpha: 1
            ).cgColor
        darkBorderLayer.startAngle = CircularProgressClock.startAngle
        darkBorderLayer.endAngle = CircularProgressClock.endAngle
        self.layer.addSublayer(darkBorderLayer)
        
        progressBorderLayer.lineColor = UIColor(
            red: 0/255,
            green: 122/255,
            blue: 255/255,
            alpha: 1
            ).cgColor
        progressBorderLayer.startAngle = CircularProgressClock.startAngle
        progressBorderLayer.endAngle = CircularProgressClock.endAngle
        self.layer.addSublayer(progressBorderLayer)
    }
    
    func loadViewFromNib() {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil).first as! UIView
        
        view.frame = bounds
        
        view.autoresizingMask = [
            UIViewAutoresizing.flexibleWidth,
            UIViewAutoresizing.flexibleHeight
        ]
        addSubview(view)
        self.view = view
    }
    
    internal class func radianForValue(_ value: CGFloat) -> CGFloat {
        let realValue = CircularProgressClock.sanitizeValue(value)
        return (realValue * 4/2 * CGFloat.pi / 100) + CircularProgressClock.startAngle
    }
    
    internal class func sanitizeValue(_ value: CGFloat) -> CGFloat {
        var realValue = value
        if value < 0 {
            realValue = 0
        } else if value > 100 {
            realValue = 100
        }
        return realValue
    }
    
}

