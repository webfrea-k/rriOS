//
//  BorderLayer.swift
//  CircularProgressClock
//
//  Created by Simon Hočevar on 22/03/2018.
//  Copyright © 2018 Simon Hočevar. All rights reserved.
//

import UIKit

class BorderLayer: CALayer {
    var lineColor: CGColor = UIColor.red.cgColor
    var lineWidth: CGFloat = 4.0
    var startAngle: CGFloat = 0.0
    @NSManaged var endAngle: CGFloat
    
    override class func needsDisplay(forKey key: String) -> Bool {
        if key == "endAngle" {
            return true
        }
        return super.needsDisplay(forKey: key)
    }
    
    override func draw(in ctx: CGContext) {
        let center = CGPoint(x:bounds.width/2, y: bounds.height/2)
        
        ctx.beginPath()
        ctx.setStrokeColor(lineColor)
        ctx.setLineWidth(lineWidth)
        ctx.addArc(
            center: center,
            radius: bounds.height/2 - lineWidth,
            startAngle: startAngle,
            endAngle: endAngle,
            clockwise: false
        )
        ctx.drawPath(using: .stroke)
        
    }
}

