//
//  RoundedShadowButton.swift
//  vision-app-dev
//
//  Created by Donald Belliveau on 2017-12-22.
//  Copyright © 2017 Donald Belliveau. All rights reserved.
//

import UIKit

class RoundedShadowButton: UIButton {
    
    // Functions
    
    // Awake From Nib.
    override func awakeFromNib() {
        self.layer.shadowColor = UIColor.darkGray.cgColor
        self.layer.shadowRadius = 15
        self.layer.shadowOpacity = 0.75
        self.layer.cornerRadius = self.frame.height / 2
    } // END Awake From Nib.
    
    
} // END Class.
