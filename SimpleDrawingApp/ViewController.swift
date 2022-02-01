//
//  ViewController.swift
//  SimpleDrawingApp
//
//  Created by Brian Advent on 11.06.20.
//  Copyright © 2020 Brian Advent. All rights reserved.
//

import UIKit
import PencilKit
import PhotosUI

private let reuseIdentifier = "cell"

class collectionCell:UICollectionViewCell{
    
    @IBOutlet weak var imageView: UIImageView!
}

class ViewController: UIViewController,  PKToolPickerObserver,UICollectionViewDelegate, UICollectionViewDataSource {
    
    

    @IBOutlet weak var pencilFingerButton: UIBarButtonItem!
    @IBOutlet weak var canvasView: Canvas2!
    
    @IBOutlet weak var myCollectionView: UICollectionView!
    @IBOutlet weak var undoButton: UIBarButtonItem!
    @IBOutlet weak var clearCanvasButton: UIBarButtonItem!
    var hw_images = [UIImage]()
    var meta_data = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        canvasView.alwaysBounceVertical = true
        canvasView.allowsFingerDrawing = true
        myCollectionView.delegate = self
        myCollectionView.dataSource = self
        

        
        let locationstr = (NSLocale.preferredLanguages[0] as String?)!
      if locationstr.contains("fr"){
          undoButton.title = "annuler"
       
      }
        if locationstr.contains("de"){
          undoButton.title = "Früher"
    }

        NotificationCenter.default.addObserver(self, selector: #selector(myFunction), name: .shootPicture, object: nil)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("canvasSize width", canvasView.layer.frame.size.width)//parent
        print("canvasSize height", canvasView.layer.frame.size.height)//parent
    }
    
    @objc func myFunction(notification: Notification) {
        let myImage = canvasView.snapshot
        
        print("snapShot width",myImage?.size.width)
        
        print("snapShot height",myImage?.size.height)
        
        if myImage == nil{
            return
        }
        
        print(notification.object ?? "") //myObject
        print(notification.userInfo ?? "") //[AnyHashable("key"): "Value"]
        print(notification.userInfo?["data"] ?? "")
        
        if  notification.userInfo?["max_x"]  == nil || notification.userInfo?["max_y"]  == nil || notification.userInfo?["min_x"]  == nil ||
            notification.userInfo?["min_y"]  == nil {
            return
        }
        
        var p_max_x:CGFloat = notification.userInfo?["max_x"] as! CGFloat
        var p_max_y:CGFloat = notification.userInfo?["max_y"] as! CGFloat
        var p_min_x:CGFloat = notification.userInfo?["min_x"] as! CGFloat
        var p_min_y:CGFloat = notification.userInfo?["min_y"] as! CGFloat
        
        if p_max_x == 0.0 && p_min_x == 0.0 && p_max_y == 0.0 && p_min_y == 0.0{
            return
        }
        
        p_max_x += 5
        p_max_y += 5
        p_min_x -= 5
        p_min_y -= 5

        p_max_x *= UIScreen.main.scale
        p_max_y *= UIScreen.main.scale
        p_min_x *= UIScreen.main.scale
        p_min_y *= UIScreen.main.scale

        
        print("max_x",p_max_x)
        print("max_y",p_max_y)
        print("min_x",p_min_x)
        print("min_y",p_min_y)
        
        let  croppedImage = self.cropImage(imageToCrop: myImage!, toRect: CGRect(
            x: p_min_x,
            y: p_min_y,
            width: p_max_x-p_min_x,
            height: p_max_y-p_min_y)
            )
//        saving to album 1920 886
//        UIImageWriteToSavedPhotosAlbum(croppedImage, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
        
        hw_images.append(croppedImage)
        meta_data.append("")
        print(hw_images)
        
        myCollectionView.reloadData()
    }
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

    }
    
    override var prefersHomeIndicatorAutoHidden: Bool {
        return true
    }
    
    @IBAction func toogleFingerOrPencil (_ sender: Any) {
        let wholeCanvasImg = canvasView.snapshot//GetImage()
//        canvasView.allowsFingerDrawing.toggle()
//        pencilFingerButton.title = canvasView.allowsFingerDrawing ? "Finger" : "Pencil"
        //Line Break
        canvasView.max_x += 5
        canvasView.max_y += 5
        canvasView.min_x -= 5
        canvasView.min_y -= 5
            
        canvasView.max_x *= UIScreen.main.scale
        canvasView.max_y *= UIScreen.main.scale
        canvasView.min_x *= UIScreen.main.scale
        canvasView.min_y *= UIScreen.main.scale

           
           let  croppedImage = cropImage(imageToCrop: wholeCanvasImg!, toRect: CGRect(
            x: canvasView.min_x,
            y: canvasView.min_y,
            width: canvasView.max_x-canvasView.min_x,
            height: canvasView.max_y-canvasView.min_y)
            )
        
//        save on album
//        UIImageWriteToSavedPhotosAlbum(croppedImage, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
        
  
     
     
        hw_images.append(croppedImage)
        meta_data.append("linebreak")
        
        canvasView.max_x = 0.0
        canvasView.max_y = 0.0
        canvasView.min_x = 99999999.9
        canvasView.min_y = 99999999.9
        canvasView.clear()
        
    }
    
    @IBAction func saveDrawingToCameraRoll(_ sender: Any) {
        canvasView.max_x = 0.0
        canvasView.max_y = 0.0
        canvasView.min_x = 99999999.9
        canvasView.min_y = 99999999.9
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let vcP = storyBoard.instantiateViewController(withIdentifier: "edit") as! EditViewController
        vcP.modalPresentationStyle = .fullScreen
        vcP.hw_images = hw_images
        vcP.meta_data = meta_data
        self.present(vcP, animated:false, completion:nil)
    }
    
    func cropImage(imageToCrop:UIImage, toRect rect:CGRect) -> UIImage{
        let imageRef:CGImage = imageToCrop.cgImage!.cropping(to: rect)!
        let cropped:UIImage = UIImage(cgImage:imageRef)
        return cropped
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        hw_images.count

    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! collectionCell
        let resized = hw_images[indexPath.item].resized(to:  CGSize(width: 120, height: 60))
        
        // Resize to height = 100 points.
        let newImage = UIImage(cgImage: hw_images[indexPath.item].cgImage!, scale: CGFloat(10/hw_images[indexPath.item].cgImage!.height), orientation: .up)
        cell.imageView.image = resized
        
        return cell
    }

    
    
    @IBAction func clearCanvasAction(_ sender: Any) {
        let wholeCanvasImg = canvasView.snapshot//GetImage()
        canvasView.max_x += 5
        canvasView.max_y += 5
        canvasView.min_x -= 5
        canvasView.min_y -= 5
        canvasView.max_x *= UIScreen.main.scale
        canvasView.max_y *= UIScreen.main.scale
        canvasView.min_x *= UIScreen.main.scale
        canvasView.min_y *= UIScreen.main.scale

            
           let  croppedImage = cropImage(imageToCrop: wholeCanvasImg!, toRect: CGRect(
            x: canvasView.min_x,
            y: canvasView.min_y,
            width: canvasView.max_x-canvasView.min_x,
            height: canvasView.max_y-canvasView.min_y)
            )
        
//        save on album
//        UIImageWriteToSavedPhotosAlbum(croppedImage, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
        
        hw_images.append(croppedImage)
        meta_data.append("")
        
        canvasView.max_x = 0.0
        canvasView.max_y = 0.0
        canvasView.min_x = 99999999.9
        canvasView.min_y = 99999999.9
        canvasView.clear()
        myCollectionView.reloadData()
        myCollectionView.scrollToNextItem()
    }
    
    @IBAction func undo_action(_ sender: Any) {
        if !canvasView.drawing.strokes.isEmpty{
            canvasView.drawing.strokes.removeLast()
        }
    }
}

class Canvas2: PKCanvasView {
    
    //
    var max_x : CGFloat = 0.0
    var max_y : CGFloat = 0.0
    var min_x : CGFloat = 99999999.9
    var min_y : CGFloat = 99999999.9
    
    func clear(){
        self.drawing = PKDrawing()
        
        max_x = 0.0
        max_y = 0.0
        min_x = 99999999.9
        min_y = 99999999.9
    }
    

  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    touches.forEach { touch in
        
        print("Canvas2 width",self.layer.frame.width)
        print("Canvas2 height",self.layer.frame.height)
        //safe layout constraints are working here
        print(self.layer.frame.origin)
        let touchPoint = touch.location(in: self)
        
        //TODO GET IMAGE if touchPoint.x is in the first 1/4 area AND touchPoint.y > max_y + 10(offset) AND max_x is in the last 1/4 area then take a ss and rest cordinates.
        
        if touchPoint.x < self.layer.frame.width/4 && max_x > self.layer.frame.width*0.25 && touchPoint.y > max_y + 2{
        
            // Create JSON object
            let messageDictionary : [String: Any] = [ "max_x": max_x, "min_x":min_x, "max_y": max_y, "min_y": min_y ]


            NotificationCenter.default.post(name: .shootPicture, object: "myObject", userInfo: messageDictionary)
            
            max_x = 0.0
            max_y = 0.0
            min_x = 99999999.9
            min_y = 99999999.9
            
        }
        
        
        if touchPoint.x > max_x{
            max_x = touchPoint.x
//            print("max_x \(max_x)")
        }
        
        if touchPoint.x < min_x{
            min_x = touchPoint.x
//            print("min_x \(min_x)")
        }
        
        
        if touchPoint.y > max_y{
            max_y = touchPoint.y
//            print("max_y \(max_y)")
        }
        
        if touchPoint.y < min_y{
            min_y = touchPoint.y
//            print("min_y \(min_y)")
        }
        
    }
  }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        touches.forEach { touch in
            
            
            let touchPoint = touch.location(in: self)
            
            if touchPoint.x > max_x{
                max_x = touchPoint.x
//                print("max_x \(max_x)")
            }
            
            if touchPoint.x < min_x{
                min_x = touchPoint.x
//                print("min_x \(min_x)")
            }
            
            
            
            if touchPoint.y > max_y{
                
                max_y = touchPoint.y
//                print("max_y \(max_y)")
            }
            
            if touchPoint.y < min_y{
                min_y = touchPoint.y
//                print("min_y \(min_y)")
            }
            
        }
        
    }
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        touches.forEach { touch in
            
            let touchPoint = touch.location(in: self)
            
            if max_x > self.layer.frame.width*0.75 && max_y > self.layer.frame.height*0.75{
                // Create JSON object
                
            }
            
            if touchPoint.x > self.layer.frame.width*0.75 && max_x > self.layer.frame.width*0.75 && touchPoint.y > max_y + 2{


               

            }
        }
    }

}

//extension UIImage {
//
//    convenience init?(view: UIView?) {
//        guard let view: UIView = view else { return nil }
//        UIGraphicsBeginImageContextWithOptions(view.bounds.size, false, UIScreen.main.scale)
//        guard let context: CGContext = UIGraphicsGetCurrentContext() else {
//            UIGraphicsEndImageContext()
//            return nil
//        }
//
//        view.layer.render(in: context)
//        let contextImage: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
//        UIGraphicsEndImageContext()
//
//        guard
//            let image: UIImage = contextImage,
//            let pngData: Data = image.pngData()
//            else { return nil }
//        self.init(data: pngData)
//    }
//}
extension Notification.Name {
    static let shootPicture = Notification.Name("shootPicture")
}

//https://stackoverflow.com/questions/29859995/screenshot-showing-up-blank-swift
extension UIView {
    var snapshot: UIImage? {
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, 0)
        defer { UIGraphicsEndImageContext() }
        drawHierarchy(in: bounds, afterScreenUpdates: true)
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}
extension UIImage {
  func resized(to newSize: CGSize) -> UIImage? {
    UIGraphicsBeginImageContextWithOptions(newSize, false, 0)
    defer { UIGraphicsEndImageContext() }

    draw(in: CGRect(origin: .zero, size: newSize))
    return UIGraphicsGetImageFromCurrentImageContext()
  }
}
extension UICollectionView {
    func scrollToNextItem() {
        let contentOffset = CGFloat(floor(self.contentOffset.x + self.bounds.size.width/2))
        self.moveToFrame(contentOffset: contentOffset)
    }

    func scrollToPreviousItem() {
        let contentOffset = CGFloat(floor(self.contentOffset.x - self.bounds.size.width/2))
        self.moveToFrame(contentOffset: contentOffset)
    }

    func moveToFrame(contentOffset : CGFloat) {
        self.setContentOffset(CGPoint(x: contentOffset, y: self.contentOffset.y), animated: true)
    }
}
