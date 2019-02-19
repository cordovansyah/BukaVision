//
//  KiosPCV.swift
//  BukaVision
//
//  Created by Cordova Putra on 16/02/19.


import UIKit
import AVFoundation
import CoreML
import Vision

class KiosPCV: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate{
    
    let cameraSession = AVCaptureSession()
    let klasifikasi = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 21))
   
   
    lazy var previewLayer: AVCaptureVideoPreviewLayer = {
        let preview = AVCaptureVideoPreviewLayer(session: self.cameraSession)
        preview.videoGravity = .resizeAspectFill
        return preview
        
    }()
    var model : VNCoreMLModel?
    
    private let sessionQueue = DispatchQueue(label: "session queue", attributes: [], target: nil)

    override func viewDidLoad() {
        super.viewDidLoad()
        let captureDevice = AVCaptureDevice.default(for: .video)!
        
        do{
            let deviceInput = try AVCaptureDeviceInput(device: captureDevice)

            cameraSession.beginConfiguration()
            
            if(cameraSession.canAddInput(deviceInput) == true) {
                cameraSession.addInput(deviceInput)
            }
            
            let dataOutput = AVCaptureVideoDataOutput()
             dataOutput.videoSettings = [((kCVPixelBufferPixelFormatTypeKey as NSString) as String) : NSNumber(value: kCVPixelFormatType_420YpCbCr8BiPlanarFullRange as UInt32)]
            
            dataOutput.alwaysDiscardsLateVideoFrames = true
            if(cameraSession.canAddOutput(dataOutput) == true){
                cameraSession.addOutput(dataOutput)
            }
            
            cameraSession.commitConfiguration()
            let queue = DispatchQueue(label: "com.cordova.BukaVision")
            dataOutput.setSampleBufferDelegate(self, queue: queue)
        }
        catch let error as NSError {
            NSLog("\(error), \(error.localizedDescription)")
        }
        self.loadModel()
        
    }
    

    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
//        let blurEffectView = UIVisualEffectView(effect: blurEffect)
//        blurEffectView.frame = CGRect(x: 0, y: 450, width: 375, height: 150)
//        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
    

        klasifikasi.center = CGPoint(x: 160, y: 485)
        klasifikasi.textAlignment = .center
        klasifikasi.text = "I'm a test label"
        klasifikasi.textColor = UIColor.red
        
        
        var frame = view.frame
        frame.size.height = frame.size.height
        previewLayer.frame = frame
        
    
        view.layer.addSublayer(previewLayer)
//        self.view.addSubview(blurEffectView)
//        self.view.addSubview(klasifikasi)
        cameraSession.startRunning()
    }
    
    private func loadModel() {
        model = try? VNCoreMLModel(for: test2().model)
    }
    
    //Ini berfungsi untuk mengaktifkan fitur 'tangkap video'
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection){
        connection.videoOrientation = .portrait
        guard let pixelBuffer: CVPixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
        
        let request = VNCoreMLRequest(model: model!){ (fineshedReq, err) in
            guard let results = fineshedReq.results as? [VNClassificationObservation] else {return}
            guard let firstObservation = results.first else {return}
            
            DispatchQueue.main.async {
                //Scanner Extensions
                
                if firstObservation.identifier == "indomie-goreng" {
//                    self.klasifikasi.text = "Ini indomie"
                    
                    let indomieContainer = "product-indomie.png"
                    let indomieImage = UIImage(named: indomieContainer)
                    let indomieImageview = UIImageView(image: indomieImage!)
                    
                    indomieImageview.frame = CGRect(x: 0, y: 495, width: 320, height: 82)
                    indomieImageview.contentMode = .scaleAspectFit
                    
                    self.view.addSubview(indomieImageview)

                } else if firstObservation.identifier == "teh-kotak"{
//                    self.klasifikasi.text = "Ini teh kotak"
                    
                    //Button Container for Each Modules
                    let indomieBtnContainer = UIButton(frame: CGRect(x: 0, y: 495, width: 320, height: 82))
                    indomieBtnContainer.tintColor = UIColor.clear
                    
                    
                    let tehkotakContainer = "product-teh-kotak.png"
                    let tehkotakImage = UIImage(named: tehkotakContainer)
                    let tehkotakImageview = UIImageView(image: tehkotakImage!)
                    tehkotakImageview.frame = CGRect(x: 0, y: 495, width: 320, height: 82)
                    tehkotakImageview.contentMode = .scaleAspectFit
                    
                    self.view.addSubview(tehkotakImageview)
                    
                } else if firstObservation.identifier == "undefined" {
                    let undefinedContainer = "scandulu.png"
                    let undefinedImage = UIImage(named: undefinedContainer)
                    let undefinedImageView = UIImageView(image: undefinedImage!)
                    undefinedImageView.frame = CGRect(x: 0, y: 495, width: 320, height: 82)
                    undefinedImageView.contentMode = .scaleAspectFit
                    
                    
                    
                    let scanIndicator = "indicator.png"
                    let scanIndicatorImage = UIImage(named: scanIndicator)
                    let scanIndicatorImageView = UIImageView(image: scanIndicatorImage!)
                    
                    scanIndicatorImageView.frame = CGRect(x: -30, y: 64, width: 375, height: 31)
                    
                    self.view.addSubview(undefinedImageView)
                    self.view.addSubview(scanIndicatorImageView)
                }
                
            }
        }
        try? VNImageRequestHandler(cvPixelBuffer: pixelBuffer, options: [:]).perform([request])
    }
}

//        let request = VNCoreMLRequest(model: model!) {
//            (finishedReq, err) in
//            guard let results = finishedReq.results as? [VNClassificationObservation] else {return}
//            guard let firstObservation = results.first else { return }
//
//                DispatchQueue.main.async {
//
//                    self.klasifikasi.text = firstObservation.identifier
//
//            }
//        }
