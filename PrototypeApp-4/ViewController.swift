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
    
    
// code to access camera
    @IBAction func camera(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            var imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .camera;
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
// code to access photo library 
    @IBAction func library(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            var imagePicker = UIImagePickerController()
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
let circle1 = UIBezierPath(arcCenter: CGPoint(x: 208, y: 398), radius: CGFloat(120), startAngle: CGFloat(0), endAngle: CGFloat(Double.pi * 2), clockwise: true)
    
    //defines the colors that are "black" and part of the pupil. Not all pixels in the pupil will be exactly black, rather, a varying range of dark shades that appear black.
let black = UIColor(red: 0/40, green: 0/40, blue: 0/40, alpha: 1)
    
// calculate pi button. Checks "x" number of pixels. "Black" points inside the circle are added to i, others are added to o. Divides to get ratio and displays this ratio.
    
    @IBAction func calculate(_ sender: Any) {
        var i = 0
        var o = 0
        var x = 0
        while x < 500{
            let image = pupil.image
            let point = CGPoint(x:Int.random(in: 88...328),y:Int.random(in: 278...518))
            let color = image?.getPixelColor(pos: point)
            if circle1.contains(point){ //&& color == black{
                
                i += 1}
            else{
                o += 1}
            
            x += 1}
        let ratio = Float(i)/Float(o)
            
//            print(color)
//            print(point)
            piCalc.text = String(ratio)
        
   
    }
    
    
// code to graph monte carlo
    
    @IBAction func pi(_ sender: Any) {
        func plot(pupil: UIImage) -> UIImage {
            UIGraphicsBeginImageContext(pupil.size)
            pupil.draw(at: CGPoint.zero)
            
            // Get the current context
            let context = UIGraphicsGetCurrentContext()!
            
            // Draw a red line
            context.setLineWidth(2.0)
            context.setStrokeColor(UIColor.red.cgColor)
            context.move(to: CGPoint(x: 100, y: 100))
            context.addLine(to: CGPoint(x: 200, y: 200))
            context.strokePath()
            let myImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            // Return modified image
            return myImage!
        }
        


        

}



}

