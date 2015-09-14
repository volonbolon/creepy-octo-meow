//
//  ViewController.swift
//  CreepyOctoMeow
//
//  Created by Ariel Rodriguez on 9/13/15.
//  Copyright © 2015 Ariel Rodriguez. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var minLabel: UILabel!
    @IBOutlet weak var maxLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let rs = RangeSlider(frame: CGRectZero)
        
        rs.absoluteMaximumValue = 3_000_000
        rs.absoluteMinimumValue = 1_500_000
        
        rs.currentMaximumValue = 2_800_000
        rs.currentMinimumValue = 2_000_000
        rs.addTarget(self, action: Selector("rsValueChanged:"), forControlEvents: UIControlEvents.ValueChanged)
        
        rs.backgroundColor = UIColor.whiteColor()
        
        self.view.addSubview(rs)
        
        let xc = NSLayoutConstraint(item: self.view, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: rs, attribute: NSLayoutAttribute.CenterX, multiplier: 1.0, constant: 0.0)
        let yc = NSLayoutConstraint(item: self.view, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: rs, attribute: NSLayoutAttribute.CenterY, multiplier: 1.0, constant: 0.0)
        let hc = NSLayoutConstraint(item: rs, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: 50)
        let wc = NSLayoutConstraint(item: rs, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: 200)
        
        rs.addConstraints([wc, hc])
        self.view.addConstraints([xc,yc])
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func rsValueChanged(sender:RangeSlider) {
        let min = sender.currentMinimumValue
        let max = sender.currentMaximumValue
        self.minLabel.text = String(min)
        self.maxLabel.text = String(max)
    }

}

