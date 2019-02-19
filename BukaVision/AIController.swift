import UIKit
import AVFoundation
import CoreML
import Vision



class AIController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate{
    
    
   //Identity

//    @IBOutlet var modal: UIImageView!
    @IBOutlet weak var buttonTest: UIButton! //indomie
    @IBOutlet weak var qrtarget: UIImageView!
    @IBOutlet weak var targetViewer: PreviewView!
    @IBOutlet weak var productViewer: PreviewView!
    @IBOutlet weak var classLabel: UILabel!
    private let session = AVCaptureSession()
    private var isSessionRunning = false
    private let sessionQueue = DispatchQueue(label: "Camera Session Queue", attributes: [], target: nil)
    private var permissionGranted = false
    
   
    @IBOutlet weak var tehkotakbtn: UIButton!
    @IBOutlet weak var oneitem: UIImageView!
     @IBOutlet weak var cart: UIButton!

    var model: VNCoreMLModel?
    
    let classificationLabel = UILabel(frame: CGRect(x: 80, y: 250, width: 400, height: 150))
    let confidenceLabel = UILabel(frame: CGRect(x: 150, y: 550, width: 400, height: 150))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
//        let namaGambar = "cart.png"
//        let gambar = UIImage(named: namaGambar)
//
//        let gambarCart = UIImageView(image: gambar!)
//        let cartTap = UITapGestureRecognizer(target: self, action: #selector(segueCO))
//        gambarCart.isUserInteractionEnabled = true
//        gambarCart.addGestureRecognizer(cartTap)
//
//         gambarCart.frame = CGRect(x: 0, y: 670, width: 320, height: 82)
//
//        let imageName = "product-indomie.png"
//        let image = UIImage(named: imageName)
//        let imageView = UIImageView(image: image!)
//
//        let singleTap = UITapGestureRecognizer(target: self, action: #selector(toCheckout))
//        imageView.isUserInteractionEnabled = true
//        imageView.addGestureRecognizer(singleTap)
        
//
        buttonTest.addTarget(self, action: #selector(buttonAppear), for: .touchUpInside)
        tehkotakbtn.addTarget(self, action: #selector(tehkotakmuncul), for: .touchUpInside)
        cart.addTarget(self, action: #selector(gotoCheckout), for: .touchUpInside)
//
//        webviewbutton.addTarget(self, action: #selector(tap), for: .touchUpInside)
        //Label
    
//        label.center = CGPoint(x: 20, y: 20)
//        label.textAlignment =
//            NSTextAlignment.center
        
        //Blur
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = CGRect(x: 0, y: 500, width: 375, height: 125)
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//        self.footer.delegate = self
//        self.footer.dataSource = self
        self.view.addSubview(blurEffectView)
        self.view.addSubview(classificationLabel)
       
        
        self.productViewer.videoPreviewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        
//        self.productViewer.videoPreviewLayer.video
        self.productViewer.session = session
        
        self.checkPermission()
        
        self.sessionQueue.async { [unowned self] in
            self.configureSession()
        }
        
        self.loadModel()
    }
    
    @objc func buttonAppear(){
        let imageName = "product-indomie.png"
        let image = UIImage(named: imageName)
        let imageView = UIImageView(image: image!)
        
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(toCheckout))
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(singleTap)
        
        let imageAnimation = UIViewPropertyAnimator(duration: 0.8, dampingRatio:0.7){
            self.qrtarget.frame = CGRect(x: 93.5, y: 220.5, width: 130, height: 120)
            self.qrtarget.image = UIImage(named: "targetyellow")
        }
        
        let imageAnimationClose = UIViewPropertyAnimator(duration: 0.2, dampingRatio:0.7){
            self.qrtarget.image = UIImage(named: "target")
        }
        

        
        imageView.frame = CGRect(x: 0, y: 670, width: 320, height: 82)
        imageView.contentMode = .scaleAspectFit

        let animator = UIViewPropertyAnimator(duration: 0.7, dampingRatio: 0.7){
            imageView.frame = CGRect(x: 0, y: 500, width: 320, height: 82)
        }
        let animatorClose = UIViewPropertyAnimator(duration: 0.7, dampingRatio: 0.7){
            imageView.frame = CGRect(x: 0, y: 670, width: 320, height: 82)
        }
        self.view.addSubview(imageView)
        imageAnimation.startAnimation()
        animator.startAnimation(afterDelay: 0.2)
        animatorClose.startAnimation(afterDelay: 3)
        imageAnimationClose.startAnimation(afterDelay: 3)
      
    }
    
    @objc func tehkotakmuncul(){
        let imageName = "product-teh-kotak.png"
        let image = UIImage(named: imageName)
        let imageView = UIImageView(image: image!)
        
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(toCheckout))
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(singleTap)
        
        let imageAnimation = UIViewPropertyAnimator(duration: 0.8, dampingRatio:0.7){
            self.qrtarget.frame = CGRect(x: 93.5, y: 220.5, width: 130, height: 120)
            self.qrtarget.image = UIImage(named: "targetyellow")
        }
        
//        let imageAnimationClose = UIViewPropertyAnimator(duration: 0.2, dampingRatio:0.7){
//            self.qrtarget.image = UIImage(named: "target")
//        }
        
        imageView.frame = CGRect(x: 0, y: 670, width: 320, height: 82)
        imageView.contentMode = .scaleAspectFit
        
        let animator = UIViewPropertyAnimator(duration: 0.7, dampingRatio: 0.7){
            imageView.frame = CGRect(x: 0, y: 500, width: 320, height: 82)
        }
        let animatorClose = UIViewPropertyAnimator(duration: 0.7, dampingRatio: 0.7){
            imageView.frame = CGRect(x: 0, y: 670, width: 320, height: 82)
        }
        self.view.addSubview(imageView)
        imageAnimation.startAnimation()
        animator.startAnimation(afterDelay: 0.2)
        animatorClose.startAnimation(afterDelay: 3)
//        imageAnimationClose.startAnimation(afterDelay: 3)
    }
    
    @objc func gotoCheckout(){
        performSegue(withIdentifier: "checkOutSegue", sender: nil)
    }
    @objc func toCheckout(){
        //        performSegue(withIdentifier: "checkoutSegue", sender: nil)
        oneitem.alpha = CGFloat(1)
        //        oneitem.isOpaque = false
    }
    
    private func checkPermission() {
        switch AVCaptureDevice.authorizationStatus(for: AVMediaType.video) {
        case .authorized:
            self.permissionGranted = true
        case .notDetermined:
            self.requestPermission()
        default:
            self.permissionGranted = false
        }
    }
    
    private func requestPermission() {
        sessionQueue.suspend()
        AVCaptureDevice.requestAccess(for: AVMediaType.video) { [unowned self] granted in
            self.permissionGranted = granted
            self.sessionQueue.resume()
        }
    }
    
    // Configure session properties
    private func configureSession() {
        guard permissionGranted else { return }
        
        self.session.beginConfiguration()
        self.session.sessionPreset = .hd1280x720
        
        guard let captureDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: AVMediaType.video, position: .back) else { return }
        guard let captureDeviceInput = try? AVCaptureDeviceInput(device: captureDevice) else { return }
        guard self.session.canAddInput(captureDeviceInput) else { return }
        self.session.addInput(captureDeviceInput)
        
        let videoOutput = AVCaptureVideoDataOutput()
        videoOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "sample buffer"))
        videoOutput.videoSettings = [kCVPixelBufferPixelFormatTypeKey as String : kCVPixelFormatType_32BGRA]
        videoOutput.alwaysDiscardsLateVideoFrames = true
        guard self.session.canAddOutput(videoOutput) else { return }
        self.session.addOutput(videoOutput)
        
        self.session.commitConfiguration()
        videoOutput.setSampleBufferDelegate(self, queue: sessionQueue)
    }

    
    private func loadModel() {
        model = try? VNCoreMLModel(for: test2().model)
        //
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.sessionQueue.async {
            self.session.startRunning()
            self.isSessionRunning = self.session.isRunning
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.sessionQueue.async { [unowned self] in
            if self.permissionGranted {
                self.session.stopRunning()
                self.isSessionRunning = self.session.isRunning
            }
        }
        super.viewWillDisappear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        // TODO: Do ML Here
        guard let pixelBuffer: CVPixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
        let request = VNCoreMLRequest(model: model!) {
            (finishedReq, err) in
            guard let results = finishedReq.results as? [VNClassificationObservation] else { return }
            guard let firstObservation = results.first else { return }
            DispatchQueue.main.async {
                
//                self.classificationLabel.text = firstObservation.identifier
            }
        }
        try? VNImageRequestHandler(cvPixelBuffer: pixelBuffer, options: [:]).perform([request])
        
    }
}
