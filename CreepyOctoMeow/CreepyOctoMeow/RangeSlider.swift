//
//  RangeSlider.swift
//  CreepyOctoMeow
//
//  Created by Ariel Rodriguez on 9/13/15.
//  Copyright © 2015 Ariel Rodriguez. All rights reserved.
//

import UIKit

@IBDesignable
class RangeSlider: UIControl {
    @IBInspectable var rangeColor:UIColor = UIColor.redColor()
    @IBInspectable var trackColor:UIColor = UIColor.blackColor()
    @IBInspectable var absoluteMinimumValue:Double = 0 {
        didSet {
            self.currentMinimumValue = self.absoluteMinimumValue
        }
    }
    @IBInspectable var absoluteMaximumValue:Double = 100 {
        didSet {
            self.currentMaximumValue = self.absoluteMaximumValue
        }
    }
    @IBInspectable var currentMinimumValue:Double! {
        didSet {
            self.sendActionsForControlEvents(UIControlEvents.ValueChanged)
        }
    }
    @IBInspectable var currentMaximumValue:Double! {
        didSet {
            self.sendActionsForControlEvents(UIControlEvents.ValueChanged)
        }
    }
    
    private var panning:Bool = false
    private var activeKnob:UIImageView!
    private var minValueSpan:Double {
        get {
            let knobWidth = Double(self.knob.size.width)
            return (self.absoluteMaximumValue-self.absoluteMinimumValue) * (knobWidth / (Double((self.bounds.size.width))-knobWidth))
        }
    }
    private var valueFudge:Double {
        get {
            return (self.absoluteMaximumValue-self.absoluteMinimumValue)/100.0
        }
    }
    
    let knob = UIImage(assetIdentifier: UIImage.AssetIdentifier.Knob)
    
    var minKnobImageView:UIImageView!
    var maxKnobImageView:UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setup()
    }
    
    func setup() {
        self.minKnobImageView = UIImageView(image: self.knob)
        self.maxKnobImageView = UIImageView(image: self.knob)
        self.minKnobImageView.userInteractionEnabled = true
        self.maxKnobImageView.userInteractionEnabled = true
        self.addSubview(minKnobImageView)
        self.addSubview(maxKnobImageView)
        
        self.translatesAutoresizingMaskIntoConstraints = false
        let gestureRecognizer = UIPanGestureRecognizer(target: self, action: Selector("handlePanGesture:"))
        self.addGestureRecognizer(gestureRecognizer)
    }
    
    override func drawRect(rect: CGRect) {
        let boundsSize = self.bounds.size
        let knobWidth = self.knob.size.width
        
        let adjustedBoundsWidth = boundsSize.width - knobWidth
        let trackPosition = boundsSize.height / 2.0
        
        let possibleWidth:CGFloat = CGFloat(self.absoluteMaximumValue - self.absoluteMinimumValue)
        
        let offsetCurrentMinimumValue:CGFloat = CGFloat(self.currentMinimumValue - self.absoluteMinimumValue)
        let offsetCurrentMaximumValue:CGFloat = CGFloat(self.currentMaximumValue - self.absoluteMinimumValue)
        let minKnobX = ((offsetCurrentMinimumValue / possibleWidth) * adjustedBoundsWidth) + (knobWidth / 2.0)
        let maxKnobX = ((offsetCurrentMaximumValue / possibleWidth) * adjustedBoundsWidth) + (knobWidth / 2.0)
        
        let minOutTrack = UIBezierPath()
        let track = UIBezierPath()
        let maxOutTrack = UIBezierPath()
        
        minOutTrack.lineWidth = 1.0
        maxOutTrack.lineWidth = 1.0
        track.lineWidth = 20.0
        
        self.trackColor.setStroke()
        
        minOutTrack.moveToPoint(CGPointMake(knobWidth/2.0, trackPosition))
        minOutTrack.addLineToPoint(CGPointMake(minKnobX, trackPosition))
        minOutTrack.closePath()
        minOutTrack.stroke()
        
        maxOutTrack.moveToPoint(CGPointMake(maxKnobX, trackPosition))
        maxOutTrack.addLineToPoint(CGPointMake((boundsSize.width-(knobWidth/2.0)), trackPosition))
        maxOutTrack.closePath()
        maxOutTrack.stroke()
        
        self.rangeColor.setStroke()
        track.moveToPoint(CGPointMake(minKnobX, trackPosition))
        track.addLineToPoint(CGPointMake(maxKnobX, trackPosition))
        track.closePath()
        track.stroke()
        
        self.minKnobImageView.center = CGPointMake(minKnobX, trackPosition)
        self.maxKnobImageView.center = CGPointMake(maxKnobX, trackPosition)
    }
    
    func handlePanGesture(gesture:UIPanGestureRecognizer) {
        let boundsSize = self.bounds.size
        let knobWidth = self.knob.size.width
        
        let adjustedBoundsWidth = boundsSize.width - knobWidth
        let possibleWidth:CGFloat = CGFloat(self.absoluteMaximumValue - self.absoluteMinimumValue)
       
        switch gesture.state {
        case UIGestureRecognizerState.Began:
            let minX = (CGFloat((self.currentMinimumValue - self.absoluteMinimumValue)) / possibleWidth) * adjustedBoundsWidth + knobWidth / 2.0
            let maxX = (CGFloat((self.currentMaximumValue - self.absoluteMinimumValue)) / possibleWidth) * adjustedBoundsWidth + knobWidth / 2.0
            let gestureX = gesture.locationInView(self).x
            let distMin = abs(gestureX-minX)
            let distMax = abs(gestureX-maxX)
            if distMin < distMax {
                self.activeKnob = minKnobImageView
            } else {
                self.activeKnob = maxKnobImageView
            }
            self.panning = true
        case UIGestureRecognizerState.Changed:
            let translation = gesture.translationInView(self)
            let delta = translation.x / adjustedBoundsWidth
            let updatedVal = (self.activeKnob == self.minKnobImageView ? self.currentMinimumValue : self.currentMaximumValue) + Double(delta) * Double(possibleWidth)
            if self.activeKnob == self.minKnobImageView {
                if (updatedVal >= self.absoluteMinimumValue) && (updatedVal < self.currentMinimumValue || updatedVal < self.currentMaximumValue - self.minValueSpan) {
                    if abs(updatedVal - self.absoluteMinimumValue) > self.valueFudge {
                        self.currentMinimumValue = updatedVal
                    } else {
                        self.currentMinimumValue = self.absoluteMinimumValue
                    }
                }
            } else {
                if (updatedVal <= self.absoluteMaximumValue) && (updatedVal > self.currentMaximumValue || updatedVal > self.currentMinimumValue + self.minValueSpan) {
                    if abs(updatedVal-self.absoluteMaximumValue) > self.valueFudge {
                        self.currentMaximumValue = updatedVal
                    } else {
                        self.currentMaximumValue = self.absoluteMaximumValue
                    }
                }
            }
            gesture.setTranslation(CGPointZero, inView: self)
        case UIGestureRecognizerState.Ended:
            self.panning = false
        default:
            break
        }
        self.setNeedsDisplay()
    }
}


