//
//  ViewController.swift
//  PrototypeApp
//
//  Created by New User on 10/14/18.
//  Copyright © 2018 New User. All rights reserved.
//


import UIKit

//code to identify color of pixels in RGB
extension UIImage {
    public func getPixelColor(pos: CGPoint) -> UIColor {
        
        let pixelData = self.cgImage!.dataProvider!.data
        let data: UnsafePointer<UInt8> = CFDataGetBytePtr(pixelData)
        
        let pixelInfo: Int = ((Int(self.size.width) * Int(pos.y)) + Int(pos.x)) * 4
        
        let r = CGFloat(data[pixelInfo]) / CGFloat(255.0)
        let g = CGFloat(data[pixelInfo+1]) / CGFloat(255.0)
        let b = CGFloat(data[pixelInfo+2]) / CGFloat(255.0)
        let a = CGFloat(data[pixelInfo+3]) / CGFloat(255.0)
        
        return UIColor(red: r, green: g, blue: b, alpha: a)
        }
}



class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    
// This is the label that displays the number when calculate is hit
    @IBOutlet weak var piCalc: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // this code is for the filter (not yet integrated)
//        if let image = UIImage(named: "pupil.jpg"){
//           let originalImage = CIImage(image: image)
//           let filter = CIFilter(name: "CISharpenLuminance")
//           filter?.setDefaults()
  //         filter?.setValue(originalImage, forKey: kCIInputImageKey)
 //          if let outputImage = filter?.outputImage{
 //               let newImage = UIImage(ciImage: outputImage)
//                pupil.image = newImage
        
            }


//Displays the image
    @IBOutlet weak var pupil: UIImageView!
    
    @IBOutlet weak var testLabel: UILabel!
    
    // code to access camera: take picture button
    @IBAction func camera(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .camera;
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    // code to access photo library: upload photo button
    @IBAction func library(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary;
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
    }

// code to display selected image and crop
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.editedImage] as! UIImage
        pupil.image = image
        dismiss(animated:true, completion: nil)
    }
    

//defines the area of the circle. The loop checks whether or not the points are within this

    
    //defines the colors that are "black" and part of the pupil. Not all pixels in the pupil will be exactly black, rather, a varying range of dark shades that appear black.

let black = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
// calculate pi button. Checks "x" number of pixels. "Black" points inside the circle are added to i, others are added to o. Divides to get ratio and displays this ratio.
    
    @IBAction func calculate(_ sender: Any) {
        var i = 0
        var o = 0
        var x = 0
        while x < 2000{
            let image = pupil.image
            let Xmin = Int(pupil.frame.minX)
            let Ymin = Int(pupil.frame.minY)
            let Xmax = Int(pupil.frame.maxX)
            let Ymax = Int(pupil.frame.maxY)
            let radius = Int(pupil.frame.size.width)/2
            let xCenter = Int(Xmin + radius)
            let yCenter = Int(Ymin + radius)
            let circle1 = UIBezierPath(arcCenter: CGPoint(x: xCenter, y: yCenter), radius: CGFloat(radius), startAngle: CGFloat(0), endAngle: CGFloat(Double.pi * 2), clockwise: true)
            let point = CGPoint(x:Int.random(in:Xmin...Xmax),y:Int.random(in: Ymin...Ymax))
            let color = image?.getPixelColor(pos: point)
            if circle1.contains(point) && color == black{
                //print(color)
                //print(point)
                
                i += 1}
            else{
                o += 1}
            
            x += 1}
        let ratio = 4 * Float(i)/Float(x)
            
//            print(color)
//            print(point)
            piCalc.text = String(ratio)
        
   
    }


    
    // face detection using CI Image library
    func faceDetect() {
        //get the image from image view
        let faceImage = CIImage(image: pupil.image!)!//unwrap imageview
        
        //set up detector
        let accuracy = [CIDetectorAccuracy: CIDetectorAccuracyHigh]
        let faceDetetector = CIDetector(ofType: CIDetectorTypeFace, context: nil, options: accuracy)
        let faces = faceDetetector?.features(in: faceImage)
        
        if !(faces!.isEmpty) { //if faces is not empty, has features
            for face in faces as! [CIFaceFeature] {
                var hasEyeVisible = "An eye is visible"
                    
                if (!face.hasLeftEyePosition) || (!face.hasRightEyePosition) //no eyes
                {
                    hasEyeVisible = "No eyes found in photo"
                }
                
                testLabel.text = hasEyeVisible
            }
            
            
        }
        
    }
    
    
}







