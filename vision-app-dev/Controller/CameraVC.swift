//
//  CameraVC.swift
//  vision-app-dev
//
//  Created by Donald Belliveau on 2017-12-22.
//  Copyright © 2017 Donald Belliveau. All rights reserved.
//

import UIKit
import AVFoundation
import CoreML
import Vision

// enum

enum FlashState {
    case off
    case on
} // END enum.

class CameraVC: UIViewController {
    
    // Instance Variables
    
    var captureSession: AVCaptureSession!
    var cameraOutput: AVCapturePhotoOutput!
    var previewLayer: AVCaptureVideoPreviewLayer!
    var photoData: Data?
    var flashControlState: FlashState = .off
    var speechSynthesizer = AVSpeechSynthesizer()
    
    // IBOutlets
    
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
    } // END View Did Load.
    
    
    // View Did Appear.
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        previewLayer.frame = cameraView.bounds
        speechSynthesizer.delegate = self
    } // END View Did Appear.
    
    
    // View Will Appear.
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapCameraView))
        tap.numberOfTapsRequired = 1
        
        captureSession = AVCaptureSession()
        captureSession.sessionPreset = AVCaptureSession.Preset.hd1920x1080
        
        let backCamera = AVCaptureDevice.default(for: AVMediaType.video)
        
        do {
            let input = try AVCaptureDeviceInput(device: backCamera!)
            if captureSession.canAddInput(input) == true {
                captureSession.addInput(input)
            }
            
            cameraOutput = AVCapturePhotoOutput()
            
            if captureSession.canAddOutput(cameraOutput) == true {
                captureSession.addOutput(cameraOutput!)
                
                previewLayer = AVCaptureVideoPreviewLayer(session: captureSession!)
                previewLayer.videoGravity = AVLayerVideoGravity.resizeAspect
                previewLayer.connection?.videoOrientation = AVCaptureVideoOrientation.portrait
                
                cameraView.layer.addSublayer(previewLayer!)
                cameraView.addGestureRecognizer(tap)
                captureSession.startRunning()
            }
        } catch {
            debugPrint(error)
        }
    } // END View Will Appear.
    
    
    // Did Tap Camera View.
    @objc func didTapCameraView() {
        let settings = AVCapturePhotoSettings()
        let previewPixelType = settings.availablePreviewPhotoPixelFormatTypes.first! // first is basic iOS photo
        let previewFormat = [kCVPixelBufferPixelFormatTypeKey as String: previewPixelType, kCVPixelBufferWidthKey as String: 160, kCVPixelBufferHeightKey as String: 160]
        
        settings.previewPhotoFormat = previewFormat
        
        if flashControlState == .off {
            settings.flashMode = .off
        } else {
            settings.flashMode = .on
        }
        
        cameraOutput.capturePhoto(with: settings, delegate: self)
    } // END Did Tap Camera View.
    
    
    // Results Method.
    func resultsMethod(request: VNRequest, error: Error?) {
        guard let results = request.results as? [VNClassificationObservation] else { return }
        
        for classification in results {
            if classification.confidence < 0.5 {
                self.identificationLbl.text = "I'm not sure what this is.  Please try again."
                self.confidenceLbl.text = ""
                break
            } else {
                self.identificationLbl.text = classification.identifier
                self.confidenceLbl.text = "CONFIDENCE: \(Int(classification.confidence * 100))%"
                break
            }
        }
    } // END Results Method.
    
    
    // Flash Button Was Pressed.
    @IBAction func flashBtnWasPressed(_ sender: Any) {
        switch flashControlState {
        case .off:
            flashBtn.setTitle("FLASH ON", for: .normal)
            flashControlState = .on
        case .on:
            flashBtn.setTitle("FLASH OFF", for: .normal)
            flashControlState = .on
        }
    } // Flash Button Was Pressed.
    
    
} // END Class.

// Extensions

extension CameraVC: AVCapturePhotoCaptureDelegate {
    
    // Photo Output.
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if let error = error {
            debugPrint(error)
        } else {
            photoData = photo.fileDataRepresentation()
            
            do {
                let model = try VNCoreMLModel(for: SqueezeNet().model)
                let request = VNCoreMLRequest(model: model, completionHandler: resultsMethod)
                let handler = VNImageRequestHandler(data: photoData!)
                try handler.perform([request])
            } catch {
                debugPrint(error)
            }
            
            let image = UIImage(data: photoData!)
            self.captureImageView.image = image
        }
        
    } // END Photo Output.
    
} // END Extension.


extension CameraVC: AVSpeechSynthesizerDelegate {
    
    //
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        // to code.
    }
    
}




















