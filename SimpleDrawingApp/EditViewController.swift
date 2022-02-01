//
//  EditViewController.swift
//  SimpleDrawingApp
//
//  Created by yujin on 2021/12/04.
//  Copyright © 2021 Brian Advent. All rights reserved.
//

import UIKit
import PhotosUI

class EditViewController: UIViewController,UIScrollViewDelegate, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    var hw_images = [UIImage]()
    var meta_data = [String]()
    var image_location_x :CGFloat = 10.0
    var image_location_y :CGFloat = 30.0
    var imageDeleteButton:UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if hw_images.count > 0{
            scrollView.contentSize = (CGSize(width: self.view.frame.width, height: self.view.frame.height*6))
//            print("height of view",self.view.frame.height*3)
        }else{
            scrollView.contentSize = (CGSize(width: self.view.frame.width, height: self.view.frame.height*1))
        }
        
        //https://stackoverflow.com/questions/29030426/how-to-create-custom-view-programmatically-in-swift-having-controls-text-field
//        export_view.frame = CGRect.init(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height*3)
        
//        print(scrollView.contentSize.width)
//        print(scrollView.contentSize.height)
        
        for index in hw_images.indices {
//            let ratioX = hw_images[index].size.width / hw_images[index].size.width
//            let ratioY = hw_images[index].size.height / hw_images[index].size.height
            
      
//            let resized = resizeImage(image: hw_images[index], newHeight: CGFloat(50.0))
            
            let imageView = UIImageView(image: hw_images[index])
            imageView.contentMode = .scaleAspectFit
            
            //TODO
            // ipodtouch imageScale = 0.175
            var imageScale = 0.175
            imageView.transform = imageView.transform.scaledBy(
              x: imageScale,
              y: imageScale
            )
            
            print("imageViewHeight",imageView.layer.frame.size.height)
            
            //TODO image_location_y = 50.0 ipodTouch
            //other 80
            
     
            
            if imageView.layer.frame.size.width + 10 + image_location_x <= self.view.layer.frame.width {
                
            }else{
                image_location_x = 10
                image_location_y += 80.0
            }
            
           
            
            //TODO if contains letter y or p or q then we have to do something
            if imageView.layer.frame.size.height > CGFloat(19.0){
                //letter p,q,y
                imageView.frame = CGRect(x: image_location_x, y: image_location_y, width: imageView.frame.size.width, height: imageView.frame.size.height)
                
            }else{
                imageView.frame = CGRect(x: image_location_x, y: image_location_y, width: imageView.frame.size.width, height: imageView.frame.size.height)
            }
         
            imageView.isUserInteractionEnabled = true
            imageView.layer.zPosition = 3
            imageView.tag = index
            scrollView.addSubview(imageView)
            
            
            
            if meta_data[index] == "linebreak"{
                image_location_x = 10
                image_location_y += 80.0
            }else{
                image_location_x += imageView.frame.size.width
                //white space
                image_location_x += 15.0
            }
            
            //
           
            
            let tapGesture = UITapGestureRecognizer(
              target: self,
              action: #selector(handleTap)
            )

            // 4
            tapGesture.delegate = self
            imageView.addGestureRecognizer(tapGesture)
            
            
            let panGesture = UIPanGestureRecognizer(
              target: self,
              action: #selector(handlePan)
            )
            
            panGesture.delegate = self
            imageView.addGestureRecognizer(panGesture)
            
            let pinchGesture = UIPinchGestureRecognizer(
              target: self,
              action: #selector(handlePinch)
            )
            
            pinchGesture.delegate = self
            imageView.addGestureRecognizer(pinchGesture)
            
            let rotateGesture = UIRotationGestureRecognizer(
              target: self,
              action: #selector(handleRotate)
            )
            
            rotateGesture.delegate = self
            imageView.addGestureRecognizer(rotateGesture)
        }

     
        
        print(hw_images)
        
    }
    
    func resizeImage(image: UIImage, newHeight: CGFloat) -> UIImage {

       let scale = newHeight / image.size.height
       let newWidth = image.size.width * scale
       UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
       image.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
       let newImage = UIGraphicsGetImageFromCurrentImageContext()!
       UIGraphicsEndImageContext()

       return newImage
   }
    
    @IBAction func BackAction(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let vcP = storyBoard.instantiateViewController(withIdentifier: "initial") as! ViewController
        vcP.modalPresentationStyle = .fullScreen
        vcP.hw_images = hw_images
        vcP.meta_data = meta_data
        self.present(vcP, animated:false, completion:nil)
    }
    
    @IBAction func SaveAction(_ sender: Any) {
        let image_height_size = image_location_y + CGFloat(50.0)
        image_location_x = 10.0
        image_location_y = 30.0
        
        let size = CGSize(width: self.view.frame.width, height: image_height_size)
        UIGraphicsBeginImageContext(size)
        
        for index in hw_images.indices {
            let imageView = UIImageView(image: hw_images[index])
            imageView.contentMode = .scaleAspectFit
            
            var imageScale = 0.175
            imageView.transform = imageView.transform.scaledBy(
              x: imageScale,
              y: imageScale
            )
            
            print("imageViewHeight",imageView.layer.frame.size.height)
            
            if imageView.layer.frame.size.width + 10 + image_location_x <= self.view.layer.frame.width {
                
            }else{
                image_location_x = 10
                image_location_y += 80.0
            }
            
           
            
            //TODO if contains letter y or p or q then we have to do something
            if imageView.layer.frame.size.height > CGFloat(19.0){
                //letter p,q,y
                imageView.frame = CGRect(x: image_location_x, y: image_location_y, width: imageView.frame.size.width, height: imageView.frame.size.height)
                
            }else{
                imageView.frame = CGRect(x: image_location_x, y: image_location_y, width: imageView.frame.size.width, height: imageView.frame.size.height)
            }
            
            imageView.image!.draw(in: CGRect(x: image_location_x, y: image_location_y, width: imageView.frame.size.width, height: imageView.frame.size.height))
            
            if meta_data[index] == "linebreak"{
                image_location_x = 10
                image_location_y += 70.0
            }else{
                image_location_x += imageView.frame.size.width
                //white space
                image_location_x += 15.0
            }
        }
        
        let finalImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
//        save on album
        UIImageWriteToSavedPhotosAlbum(finalImage!, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
    }
    
    @IBOutlet weak var deleteButton: UIBarButtonItem!
    
    
    
    @IBAction func DeleteAction(_ sender: Any) {
        
        let locationstr = (NSLocale.preferredLanguages[0] as String?)!
        var message = "All data will be lost."
        var ok = "Ok"
        var no = "Cancel"
        if locationstr.contains( "de")
        {
            message = "Alle Daten gehen verloren."
            no = "Abbrechen"
            ok = "OK"
        }
        
        if locationstr.contains( "fr")
        {
            message = "Toutes les données seront perdues."
            no = "annuler"
            ok = "d'accord"
        }
        
        //TODO DISPLAY MODAL
        
        let refreshAlert = UIAlertController(title: "Refresh", message: message, preferredStyle: UIAlertController.Style.alert)

        refreshAlert.addAction(UIAlertAction(title: ok, style: .default, handler: { (action: UIAlertAction!) in
              print("Handle Ok logic here")
            self.hw_images.removeAll()
            self.meta_data.removeAll()
            
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let vcP = storyBoard.instantiateViewController(withIdentifier: "initial") as! ViewController
            vcP.modalPresentationStyle = .fullScreen
            vcP.hw_images = self.hw_images
            vcP.meta_data = self.meta_data
            self.present(vcP, animated:false, completion:nil)
        }))

        refreshAlert.addAction(UIAlertAction(title: no, style: .cancel, handler: { (action: UIAlertAction!) in
              print("Handle Cancel Logic here")
        }))

        present(refreshAlert, animated: true, completion: nil)
        
       
        
    }
    
    
    @objc func handlePan(_ gesture: UIPanGestureRecognizer) {
      // 1
      let translation = gesture.translation(in: view)

      // 2
      guard let gestureView = gesture.view else {
        return
      }

      gestureView.center = CGPoint(
        x: gestureView.center.x + translation.x,
        y: gestureView.center.y + translation.y
      )

      // 3
      gesture.setTranslation(.zero, in: view)

      guard gesture.state == .ended else {
        return
      }

      // 4
      let velocity = gesture.velocity(in: view)
      let magnitude = sqrt((velocity.x * velocity.x) + (velocity.y * velocity.y))
      let slideMultiplier = magnitude / 200

      // 5
      let slideFactor = 0.1 * slideMultiplier
      // 6
      var finalPoint = CGPoint(
        x: gestureView.center.x + (velocity.x * slideFactor),
        y: gestureView.center.y + (velocity.y * slideFactor)
      )

      // 7
      finalPoint.x = min(max(finalPoint.x, 0), view.bounds.width)
      finalPoint.y = min(max(finalPoint.y, 0), view.bounds.height)

      // 8
      UIView.animate(
        withDuration: Double(slideFactor * 2),
        delay: 0,
        // 9
        options: .curveEaseOut,
        animations: {
          gestureView.center = finalPoint
      })
    }
      
    @objc func handlePinch(_ gesture: UIPinchGestureRecognizer) {
      guard let gestureView = gesture.view else {
        return
      }

//        var letsmultiplyit = gesture.scale
//        if gesture.scale > 1.0{
//            letsmultiplyit *= 1.05 * letsmultiplyit
//        }
//
//        if gesture.scale < 1.0{
//            letsmultiplyit *= 0.95 * letsmultiplyit
//        }
        
        
      gestureView.transform = gestureView.transform.scaledBy(
        x: gesture.scale,
        y: gesture.scale
//        x:letsmultiplyit,
//        y:letsmultiplyit
      )
      gesture.scale = 1
    }
    
    @objc func handleRotate(_ gesture: UIRotationGestureRecognizer) {
      guard let gestureView = gesture.view else {
        return
      }

      gestureView.transform = gestureView.transform.rotated(
        by: gesture.rotation
      )
      gesture.rotation = 0
    }
    
    @objc func handleTap(_ gesture: UITapGestureRecognizer) {
        gesture.view?.tag
        let location = gesture.location(in: self.view)
        
        if imageDeleteButton != nil{
            imageDeleteButton.removeFromSuperview()
        }
        
        imageDeleteButton = UIButton()
        imageDeleteButton.frame = CGRect(x: location.x, y: location.y, width: 30, height: 30)
        imageDeleteButton.layer.cornerRadius = 0.5 * imageDeleteButton.bounds.size.width
        imageDeleteButton.backgroundColor = UIColor.red
        imageDeleteButton.setTitle("×", for: .normal)
        imageDeleteButton.tag = gesture.view!.tag
        imageDeleteButton.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        self.view.addSubview(imageDeleteButton)
        
    }
    
    @objc func buttonAction(sender: UIButton!) {
        
        let myimgviewes = scrollView.subviews.filter{$0 is UIImageView}
        
        for view in myimgviewes{
                view.removeFromSuperview()
        }
        print("Button tapped",sender.tag)
        
        hw_images.remove(at: sender.tag)
        meta_data.remove(at: sender.tag)
      
        
        if imageDeleteButton != nil{
            imageDeleteButton.removeFromSuperview()
        }
        
        image_location_x = 10.0
        image_location_y = 30.0
        
        print(hw_images)
        
        for index in hw_images.indices {
//            let ratioX = hw_images[index].size.width / hw_images[index].size.width
//            let ratioY = hw_images[index].size.height / hw_images[index].size.height
            
      
//            let resized = resizeImage(image: hw_images[index], newHeight: CGFloat(50.0))
            
            let imageView = UIImageView(image: hw_images[index])
            imageView.contentMode = .scaleAspectFit
            
            //TODO
            // ipodtouch imageScale = 0.175
            var imageScale = 0.175
            imageView.transform = imageView.transform.scaledBy(
              x: imageScale,
              y: imageScale
            )
            
            print("imageViewHeight",imageView.layer.frame.size.height)
            
            //TODO image_location_y = 50.0 ipodTouch
            //other 80
            
     
            
            if imageView.layer.frame.size.width + 10 + image_location_x <= self.view.layer.frame.width {
                
            }else{
                image_location_x = 10
                image_location_y += 80.0
            }
            
           
            
            //TODO if contains letter y or p or q then we have to do something
            if imageView.layer.frame.size.height > CGFloat(19.0){
                //letter p,q,y
                imageView.frame = CGRect(x: image_location_x, y: image_location_y, width: imageView.frame.size.width, height: imageView.frame.size.height)
                
            }else{
                imageView.frame = CGRect(x: image_location_x, y: image_location_y, width: imageView.frame.size.width, height: imageView.frame.size.height)
            }
         
            imageView.isUserInteractionEnabled = true
            imageView.layer.zPosition = 3
            imageView.tag = index
            scrollView.addSubview(imageView)
            
            
            
            if meta_data[index] == "linebreak"{
                image_location_x = 10
                image_location_y += 80.0
            }else{
                image_location_x += imageView.frame.size.width
                //white space
                image_location_x += 15.0
            }
            
            //
           
            
            let tapGesture = UITapGestureRecognizer(
              target: self,
              action: #selector(handleTap)
            )

            // 4
            tapGesture.delegate = self
            imageView.addGestureRecognizer(tapGesture)
            
            
            let panGesture = UIPanGestureRecognizer(
              target: self,
              action: #selector(handlePan)
            )
            
            panGesture.delegate = self
            imageView.addGestureRecognizer(panGesture)
            
            let pinchGesture = UIPinchGestureRecognizer(
              target: self,
              action: #selector(handlePinch)
            )
            
            pinchGesture.delegate = self
            imageView.addGestureRecognizer(pinchGesture)
            
            let rotateGesture = UIRotationGestureRecognizer(
              target: self,
              action: #selector(handleRotate)
            )
            
            rotateGesture.delegate = self
            imageView.addGestureRecognizer(rotateGesture)
        }

     
    }

}
