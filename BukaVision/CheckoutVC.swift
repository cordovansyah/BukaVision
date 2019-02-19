//
//  Webview.swift
//  BukaVision
//
//  Created by Cordova Putra on 14/02/19.
//  Copyright © 2019 Sri Raghu Malireddi. All rights reserved.
//

import Foundation
import UIKit
import WebKit

class CheckoutVC : UIViewController {
    
//    @IBOutlet weak var webview: WKWebView!
 
    @IBOutlet weak var webviewconnect: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        
        let url = NSURL (string: "https://hackafun.ahmadzakiy.com/?id=indomie-goreng");
        let request = NSURLRequest(url: url! as URL);
        webviewconnect.load(request as URLRequest);
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
}
