//
//  CameraVC.swift
//  vision-app-dev
//
//  Created by Donald Belliveau on 2017-12-22.
//  Copyright © 2017 Donald Belliveau. All rights reserved.
//

import UIKit

class CameraVC: UIViewController {
    
    //
    
    @IBOutlet weak var captureImageView: RoundedShadowImageView!
    @IBOutlet weak var flashBtn: RoundedShadowButton!
    @IBOutlet weak var identificationLbl: UILabel!
    @IBOutlet weak var confidenceLbl: UILabel!
    @IBOutlet weak var cameraView: UIView!
    @IBOutlet weak var roundedLblView: RoundedShadowView!
    
    // Functions
    
    // View Did Load.
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    } // END View Did Load.
    
    
    
    
} // END Class.

