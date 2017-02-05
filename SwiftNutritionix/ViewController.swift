//
//  ViewController.swift
//  SwiftNutritionix
//
//  Created by Lea rygg on 04/02/2017.
//  Copyright © 2017 Lea rygg. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

class ViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate  {
    var session: AVCaptureSession!
    var device: AVCaptureDevice!
    var input: AVCaptureDeviceInput!
    var output: AVCaptureMetadataOutput!
    var prevLayer: AVCaptureVideoPreviewLayer!
    var parentVC: ViewController!
    var highlightView: UIView!
    
    
    var detectionString: String? = nil
    var lastBarcodeValue: String? = nil
    
    @IBOutlet weak var scanButtonOutlet: NSLayoutConstraint!
    
    
    @IBAction func scanButtonPressed(_ sender: Any) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        highlightView = UIView()
        highlightView.autoresizingMask = [.flexibleTopMargin, .flexibleLeftMargin, .flexibleRightMargin, .flexibleBottomMargin]
        highlightView.layer.borderColor = UIColor.green.cgColor
        highlightView.layer.borderWidth = 3
        self.view.addSubview(highlightView)
        session = AVCaptureSession()
        device = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        var error: Error? = nil
        input = try? AVCaptureDeviceInput(device: device)
        if input != nil {
            session.addInput(input)
        }
        else {
            print("Error: \(error)")
        }
        output = AVCaptureMetadataOutput()
        output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        session.addOutput(output)
        output.metadataObjectTypes = output.availableMetadataObjectTypes
        prevLayer = AVCaptureVideoPreviewLayer(session: session)
        prevLayer.frame = self.view.bounds
        prevLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
        self.view.layer.addSublayer(prevLayer)
        session.startRunning()
        self.view.bringSubview(toFront: highlightView)
    }
    
    func captureOutput(_ captureOutput: AVCaptureOutput, didOutputMetadataObjects metadataObjects: [Any], from connection: AVCaptureConnection) {
        detectionString = nil
        var highlightViewRect = CGRect.zero
        var barCodeObject: AVMetadataMachineReadableCodeObject?
        var barCodeTypes: [Any] = [AVMetadataObjectTypeUPCECode, AVMetadataObjectTypeCode39Code,AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode93Code, AVMetadataObjectTypeCode128Code, AVMetadataObjectTypePDF417Code, AVMetadataObjectTypeQRCode, AVMetadataObjectTypeAztecCode]
        for metadata in metadataObjects {
            for type in barCodeTypes {
              //  if (((metadata as! AVMetadataObject).type == type) {
                    barCodeObject = (prevLayer.transformedMetadataObject(for: (metadata as? AVMetadataMachineReadableCodeObject)) as? AVMetadataMachineReadableCodeObject)
                    highlightViewRect = (barCodeObject?.bounds)!
                    detectionString = (metadata as? AVMetadataMachineReadableCodeObject)?.stringValue
                    print(detectionString)
                if detectionString != nil {
                    print(callNutritionix(withUPC: detectionString!))

                }
                    break
              //  }
            }
        }
        if detectionString != nil {
            if (detectionString == lastBarcodeValue) {
                return
            }
            lastBarcodeValue = detectionString
            self.returnToCallingController()
        }
        highlightView.frame = highlightViewRect
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func returnToCallingController() {
        // [parentVC setBarcode :lastBarcodeValue];
        // lastBarcodeValue = nil;     // allow re-scanning of same barcode when re-activated
        self.dismiss(animated: true, completion: { _ in })
    }
    
    func getBarcode() -> String {
        detectionString = nil
        return lastBarcodeValue!
    }
    
   /* func callNutritionix(withUPC upc: String) -> NSDictionary {
        var request = NSMutableURLRequest(url: URL(string: "https://api.nutritionix.com/v1_1/search/")!)
        let session = URLSession.shared
        request.httpMethod = "POST"
        
        var funcResponse: NSDictionary = [:]
        
        var params = [
            "appId" : "1dd52508",
            "appKey" : "652d458dadcc84c7a01f68b5195690c3",
            "fields" : [],
            "limit" : "50",
            "query" : upc,
            ] as [String : Any]
        
        var error:NSError?
        
        do {
            try request.httpBody = JSONSerialization.data(withJSONObject: params)
        } catch {
            print("error")
        }
        
        
    //    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    //    request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        var task = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, err) -> Void in
            var conversionError:NSError?
            
            var jsonDictionary: NSDictionary?
            
            do {
                jsonDictionary = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableLeaves) as? NSDictionary
            } catch {
                print("Error")
            }
            
            if conversionError != nil {
                print(conversionError!.localizedDescription)
                let errorString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                print("Error in parsing: \(errorString)")
            }
            else {
                if jsonDictionary != nil {
                   
                    funcResponse = jsonDictionary!
                }
                else {
                    print("Error could not parse JSON")
                }
            }
        })
        task.resume()
        return funcResponse
    } */
    
}



