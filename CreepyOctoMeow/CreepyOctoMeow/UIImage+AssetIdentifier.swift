//
//  UIImage+AssetIdentifier.swift
//  CreepyOctoMeow
//
//  Created by Ariel Rodriguez on 9/13/15.
//  Copyright © 2015 Ariel Rodriguez. All rights reserved.
//

import UIKit

extension UIImage {
    enum AssetIdentifier:String {
        case Knob = "knob"
    }
    
    convenience init!(assetIdentifier:AssetIdentifier) {
        self.init(named:assetIdentifier.rawValue)
    }
}