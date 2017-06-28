//
//  ViewController.swift
//  LiveCameraFiltering
//
//  Created by Simon Gladman on 05/07/2015.
//  Copyright © 2015 Simon Gladman. All rights reserved.
//
// Thanks to: http://www.objc.io/issues/21-camera-and-photos/camera-capture-on-ios/

import UIKit
import AVFoundation
import CoreMedia

extension UIColor {
    var coreImageColor: CIColor {
        return CIColor(color: self)
    }
    var components: (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
        let coreImageColor = self.coreImageColor
        return (coreImageColor.red, coreImageColor.green, coreImageColor.blue, coreImageColor.alpha)
    }
}

extension Array where Element: Comparable {
    public func indMax() -> Int? {
        guard
            let max = self.max(),
            let index = self.index(of: max) else { return nil }
        return Int(index)
    }
}

var lastValues : Float = 0.0;
var lastChecks = [false,false];

var nb = 0;

var nbFrame = 0;

var binData : [Float] = [119.228, 119.454, 121.565, 121.766, 123.716, 123.85, 125.315, 125.391, 123.767, 124.629, 126.008,
           126.354, 127.469, 127.757, 128.881, 129.073, 129.653, 126.477, 127.89, 128.288, 129.362, 130.003,
           131.028, 131.189, 131.884, 131.496, 129.211, 129.568, 130.853, 131.201, 132.565, 132.96, 133.435, 133.57,
           133.583, 130.261, 131.046, 131.419, 132.399, 133.104, 133.891, 134.269, 134.408, 131.275, 131.535,
           131.669, 132.433, 133.227, 134.341, 134.634, 135.061, 135.151, 133.157, 131.87, 132.19, 132.714, 133.742,
           134.402, 135.039, 135.355, 135.509, 132.767, 136.257, 136.702, 137.088, 137.922, 138.584, 139.044,
           139.496, 138.291, 136.706, 136.837, 138.294, 138.951, 140.046, 140.479, 140.973, 141.158, 138.032,
           138.126, 136.236, 136.598, 137.654, 138.237, 138.544, 138.961, 135.386, 135.88, 136.227, 136.562,
           137.325, 137.877, 138.325, 138.657, 138.89, 135.235, 135.472, 135.766, 136.097, 136.789, 137.45, 137.913,
           138.263, 138.476, 138.095, 135.247, 135.097, 135.778, 136.118, 136.787, 137.293, 137.753, 137.994,
           137.494, 135.428, 135.532, 135.684, 135.981, 136.684, 137.223, 137.693, 137.962, 137.139, 135.433,
           135.244, 135.759, 136.186, 136.879, 137.387, 137.71, 137.911, 137.156, 135.663, 135.587, 136.028,
           136.401, 136.943, 137.265, 137.555, 137.628, 135.382, 135.527, 135.775, 136.098, 136.604, 136.936,
           137.257, 137.481, 135.299, 134.977, 134.943, 135.237, 135.798, 136.302, 136.781, 137.066, 137.153,
           134.366, 134.467, 134.84, 135.281, 135.872, 136.399, 136.802, 137.08, 137.047, 134.787, 134.813, 135.308,
           135.641, 136.176, 136.544, 136.843, 137.072, 136.074, 135.137, 135.249, 135.426, 135.915, 136.368,
           136.657, 136.861, 136.513, 134.787, 134.856, 135.163, 135.54, 136.094, 136.429, 136.702, 136.571,
           134.778, 135.129, 135.234, 135.496, 135.972, 136.217, 136.396, 134.167, 134.454, 134.601, 134.878,
           135.447, 135.892, 136.152, 136.375, 133.649, 133.888, 133.855, 133.986, 134.732, 135.327, 135.72,
           136.098, 133.622, 133.641, 133.81, 134.16, 134.828, 135.317, 135.678, 135.81, 133.376, 133.707, 134.129,
           134.565, 135.18, 135.607, 135.888, 136.072, 133.205, 133.562, 133.759, 134.18, 134.882, 135.306, 135.702]
var melanieData : [Double] = [124.326, 123.746, 125.018, 125.42, 126.617, 127.098, 128.002, 127.296, 127.797, 127.994, 128.84,
                   129.217, 129.769, 129.083, 129.491, 129.525, 130.259, 130.633, 130.565, 130.083, 130.535, 130.664,
                   131.461, 131.831, 131.263, 131.026, 131.53, 131.726, 132.453, 132.738, 132.32, 132.297, 132.664,
                   132.993, 133.644, 133.675, 133.523, 133.629, 134.052, 134.435, 134.956, 135.085, 134.412, 134.398,
                   134.723, 134.977, 135.116, 135.337, 134.497, 134.226, 134.518, 134.681, 134.888, 135.191, 134.355,
                   134.151, 134.194, 134.293, 134.808, 135.097, 134.465, 133.821, 133.998, 133.986, 134.541, 134.93,
                   135.23, 134.439, 134.484, 134.535, 134.833, 135.242, 135.612, 134.719, 134.626, 134.628, 134.799,
                   135.122, 135.464, 134.317, 133.81, 133.556, 133.742, 133.952, 134.573, 133.531, 132.816, 132.445,
                   132.587, 132.734, 133.236, 132.749, 132.121, 131.849, 132.034, 132.142, 132.64, 132.862, 132.033,
                   131.679, 131.774, 131.79, 132.469, 132.834, 132.847, 132.297, 132.574, 132.632, 133.037, 133.349,
                   133.841, 133.264, 133.618, 133.754, 133.947, 134.234, 134.944, 134.614, 134.253, 134.253, 134.295,
                   134.562, 134.784, 135.125, 134.312, 133.999, 134.193, 134.261, 134.645, 135.012, 135.266, 134.497,
                   134.256, 134.229, 137.802, 138.266, 138.665, 139.194, 139.512, 139.03, 139.12, 139.242, 139.501,
                   139.794, 141.621, 140.955, 142.232, 141.915, 140.217, 140.312, 139.491, 139.804, 140.076, 140.407,
                   139.889, 139.801, 139.935, 139.984, 140.192, 140.434, 140.645, 140.902, 140.003, 140.066, 140.082,
                   140.197, 140.395, 140.572, 140.781, 140.34, 140.104, 140.194, 140.197, 140.284, 140.461, 140.607,
                   139.962, 139.811, 139.816, 139.816, 139.944, 140.076, 140.046, 139.454, 139.291, 139.209, 139.168,
                   139.303, 139.394, 138.934, 138.629, 138.441, 138.395, 138.537, 138.645, 138.815, 138.205, 138.084,
                   138.036, 138.088, 138.214, 138.345, 138.406, 137.785, 137.665, 137.54, 137.586, 137.631, 137.811,
                   137.838, 137.255, 137.057, 136.967, 137.01, 137.185, 137.347, 137.495, 136.842, 136.715, 136.696,
                   136.787, 137.006, 137.234, 137.517, 136.868, 136.666, 136.658, 136.662, 136.868, 137.076, 137.329,
                   136.935, 136.575, 136.518, 136.566, 136.835, 137.185, 137.503, 137.656, 137.132, 137.067, 137.193,
                   137.392, 137.674, 137.935, 138.067, 137.466, 137.53, 137.51, 137.695, 137.943, 138.266, 137.648,
                   137.291, 137.191, 137.2, 137.419, 137.625, 137.652, 136.871, 136.703, 136.676]
var brice2Data : [Float] = [118.138, 120.409, 123.18, 120.929, 112.423, 115.759, 124.934, 130.071, 134.338, 136.468, 137.418,
              135.325, 134.55, 134.559, 133.307, 134.327, 135.16, 135.412, 131.612, 133.539, 134.445, 134.919,
              135.864, 136.297, 136.922, 133.871, 135.547, 136.294, 136.691, 137.271, 137.699, 137.478, 135.323,
              136.461, 136.908, 137.096, 137.71, 138.656, 135.119, 138.2, 140.058, 140.735, 140.724, 141.171,
              140.938, 140.443, 140.74, 141.601, 142.003, 142.797, 142.787, 141.777, 143.611, 142.886, 142.435,
              142.817, 143.334, 139.409, 141.396, 143.034, 143.145, 144.117, 145.727, 144.293, 142.119, 144.891,
              145.903, 146.589, 147.525, 145.357, 138.847, 140.526, 142.958, 142.012, 143.476, 144.609, 145.188,
              139.312, 139.052, 142.257, 142.296, 143.53, 144.433, 144.874, 144.487, 132.206, 135.033, 135.729,
              136.413, 138.916, 140.094, 140.796, 137.025, 133.902, 136.841, 136.787, 137.99, 139.319, 139.9,
              140.304, 133.852, 135.924, 137.549, 138.362, 139.898, 140.602, 141.046, 136.061, 135.838, 138.123,
              137.768, 138.857, 140.209, 140.961, 140.385, 136.622, 139.055, 139.925, 140.511, 141.614, 142.358,
              142.687, 137.436, 139.061, 140.476, 141.317, 142.359, 144.058, 144.318, 138.012, 140.856, 141.845,
              142.193, 143.357, 143.903, 142.852, 136.157, 138.372, 138.92, 140.311, 141.966, 142.546, 143.152,
              134.976, 135.275, 136.679, 137.919, 139.737, 140.552, 141.185, 141.295, 134.807, 138.191, 139.147,
              139.743, 141.21, 141.963, 142.607, 143.168, 137.051, 138.849, 141.013, 141.599, 142.865, 143.555,
              144.024, 144.365, 142.554, 139.301, 142.34, 142.633, 143.401, 144.347, 144.754, 145.29, 144.873,
              139.829, 142.266, 143.388, 144.206, 145.265, 145.879, 146.427, 146.091, 142.449, 143.998, 144.827,
              145.356, 146.513, 147.08, 147.648, 146.289, 142.908, 144.716, 145.281, 146.109, 147.427, 147.983,
              148.45, 142.951, 143.632, 145.261, 145.839, 147.316, 148.2, 148.749, 148.87, 142.778, 144.356, 145.49]

var colors : [Float] = [];

class ViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate
{
    let mainGroup = UIStackView()
    let imageView = UIImageView(frame: CGRect.zero)
    var backCamera :AVCaptureDevice?  = nil;
    var captureSession :AVCaptureSession?  = nil;
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        view.addSubview(mainGroup)
        mainGroup.axis = UILayoutConstraintAxis.vertical
        mainGroup.distribution = UIStackViewDistribution.fill
        
        mainGroup.addArrangedSubview(imageView)
        
        imageView.contentMode = UIViewContentMode.scaleAspectFit
        
        let captureSession = AVCaptureSession()
        captureSession.sessionPreset = AVCaptureSessionPresetLow
        
        backCamera = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        
        do
        {
            let input = try AVCaptureDeviceInput(device: backCamera)
            captureSession.addInput(input)
        }
        catch
        {
            print("can't access camera")
            return
        }
        
        //used to set the framerate of the camera.
        try? backCamera?.lockForConfiguration()
        
        if(backCamera!.isFocusModeSupported(.continuousAutoFocus)) {
            backCamera!.focusMode = .continuousAutoFocus
        }
        
        backCamera?.isSubjectAreaChangeMonitoringEnabled = true;
        //backCamera?.activeFormat = captureSession.
        backCamera?.activeVideoMinFrameDuration = CMTimeMake(1, 9)
        backCamera?.activeVideoMaxFrameDuration = CMTimeMake(1, 9)
        if ((backCamera?.hasTorch)! && (backCamera?.isTorchAvailable)!){
            try? backCamera?.setTorchModeOnWithLevel(AVCaptureMaxAvailableTorchLevel)
        }
        backCamera?.unlockForConfiguration()
        
        
        // although we don't use this, it's required to get captureOutput invoked
        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        view.layer.addSublayer(previewLayer!)
        
        let videoOutput = AVCaptureVideoDataOutput()
        
        videoOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "sample buffer delegate", attributes: []))
        if captureSession.canAddOutput(videoOutput)
        {
            captureSession.addOutput(videoOutput)
        }
        
        captureSession.startRunning();
    }
    
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputSampleBuffer sampleBuffer: CMSampleBuffer!, from connection: AVCaptureConnection!)
    {
        nbFrame = nbFrame + 1;
        
        if (nbFrame >= 200){
            try? backCamera?.lockForConfiguration()
            
            if(backCamera!.isFocusModeSupported(.continuousAutoFocus)) {
                backCamera!.focusMode = .continuousAutoFocus
            }
            
            backCamera?.isSubjectAreaChangeMonitoringEnabled = true;
            //backCamera?.activeFormat = captureSession.
            backCamera?.activeVideoMinFrameDuration = CMTimeMake(1, 30)
            backCamera?.activeVideoMaxFrameDuration = CMTimeMake(1, 30)
            if ((backCamera?.hasTorch)! && (backCamera?.isTorchAvailable)!){
                try? backCamera?.torchMode = AVCaptureTorchMode.off
            }
            backCamera?.unlockForConfiguration()
            captureSession?.stopRunning();
            
            //computeValues(colors);
        }
        else{
            let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer)
            
            let ciimage = CIImage(cvPixelBuffer: pixelBuffer!);
            
            CVPixelBufferUnlockBaseAddress(pixelBuffer!, CVPixelBufferLockFlags(rawValue: 0));
            
            
            let filter = CustomFilter();
            filter.setValue(ciimage, forKey: kCIInputImageKey)
            let context = CIContext();
            let img:CGImage = context.createCGImage(ciimage, from: ciimage.extent)!;
            
            let filteredImage = UIImage(ciImage: filter.value(forKey: kCIOutputImageKey) as! CIImage!)
            
            let newValues = getRowvalues(img: img);
            
            if  !lastChecks[0] && !lastChecks[1] && lastValues>newValues{
                print("boom", nb, lastChecks)
                nb += 1;
            }
            lastChecks.removeFirst();
            lastChecks.append(lastValues>newValues)
            
            //print(lastValues>newValues);
            //print(lastValues)
            
            lastValues = newValues
            colors.append(newValues);
            
            
            DispatchQueue.main.async
                {
                    //send the data back here
                    self.imageView.image = filteredImage
            }
        }
    }
    
    override func viewDidLayoutSubviews()
    {
        let topMargin = topLayoutGuide.length
        
        mainGroup.frame = CGRect(x: 0, y: topMargin, width: view.frame.width, height: view.frame.height - topMargin).insetBy(dx: 5, dy: 5)
    }
    
    func getRowvalues(img : CGImage) -> Float{
        
        let width = img.width;
        let height = img.height;
        
        let checkHeightMin = (height/2)-15-50;
        let checkHeightMax = (height/2)+15-50;
        
        let checkWidthtMin = (width/2)-20;
        let checkWidthMax = (width/2)+20;
        
        
        var sum : Float = 0.0;
        for i in checkHeightMin ..< checkHeightMax{
            
            for j in checkWidthtMin ..< checkWidthMax{
                sum += Float(getPixelColor(pos: CGPoint(x:j , y:i), image: img).components.red);
            }
        }
        return sum / Float(((checkHeightMax-checkHeightMin)*(checkWidthMax-checkWidthtMin)));
    }
    
    func getPixelColor(pos: CGPoint, image : CGImage ) -> UIColor {
        let pixelData = image.dataProvider!.data
        let data : UnsafePointer<UInt8> = CFDataGetBytePtr(pixelData)
        
        let pixelInfo : Int = ((Int(image.width) * Int(pos.y) + Int(pos.x)*4))
        
        let r = CGFloat(data[pixelInfo])
        let g = CGFloat(data[pixelInfo+1])
        let b = CGFloat(data[pixelInfo+2])
        let a = CGFloat(data[pixelInfo+3])
        
        let gray =
            r*0.6+g+0.3+b*0.11;
        
        return UIColor(red: gray, green: gray, blue: gray, alpha: a)
    }
}




