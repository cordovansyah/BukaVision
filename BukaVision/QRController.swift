import UIKit
import AVFoundation

class QRController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    @IBOutlet var videoPreview: UIView!
    //Error handling UX for future semi-production of BukaVision
    enum error: Error {
        case noCameraAvailable
        case videoInputInitFail
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customPopVC()
        customTargetImg()
        do{
            try scanQRCode()
        } catch {
            print("Failed to scan the QR/Barcode.")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.navigationBar.barTintColor = UIColor.clear
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController!.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]

    }
    
    
    //Capture Output
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection){
        if metadataObjects.count > 0 {
            let machineReadableCode = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
            
            if machineReadableCode.type == AVMetadataObject.ObjectType.qr {
                    print("QR Code Detected")
                    performSegue(withIdentifier: "toKiosPCV", sender: self)
            }
        }
    }
    
    func customTargetImg(){
        let imageName = "targetbox.png"
        let image = UIImage(named: imageName)
        let imageView = UIImageView(image: image!)
        imageView.frame = CGRect(x: 53, y: 171, width: 214, height: 226)
        view.addSubview(imageView)
    }
    
    func customPopVC(){
        let backbutton = UIButton(type: .custom)
        backbutton.setImage(UIImage(named: "ic_backfill-1.png"), for: .normal)
//        backbutton.setTitle("Back", for: .normal)
        backbutton.setTitleColor(backbutton.tintColor, for: .normal)
        backbutton.addTarget(self, action: #selector(backAction), for: .touchUpInside)
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backbutton)
    }
    
    
    
    @objc func backAction(){
        self.navigationController?.popViewController(animated: true)
    }
    
    func scanQRCode() throws {
        let avCaptureSession = AVCaptureSession()
        guard let avCaptureDevice = AVCaptureDevice.default(for: AVMediaType.video) else {
            //TODO: AddError Modal Card / Sheet UI for future semi production of BukaVision
            print("No Camera")
            throw error.noCameraAvailable
        }
        guard let avCaptureInput = try? AVCaptureDeviceInput(device: avCaptureDevice) else {
            print("Camera failed to initiate")
            throw error.videoInputInitFail
        }
        let avCaptureMetadataOutput = AVCaptureMetadataOutput()
        avCaptureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        
        avCaptureSession.addInput(avCaptureInput)
        avCaptureSession.addOutput(avCaptureMetadataOutput)
        
        avCaptureMetadataOutput.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]
        
        let avCaptureVideoPreviewLayer = AVCaptureVideoPreviewLayer(session: avCaptureSession)
        avCaptureVideoPreviewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        
        avCaptureVideoPreviewLayer.frame = videoPreview.bounds
        self.videoPreview.layer.addSublayer(avCaptureVideoPreviewLayer)
        avCaptureSession.startRunning()
    }
 
}

