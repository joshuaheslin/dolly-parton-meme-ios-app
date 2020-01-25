//
//  ViewController.swift
//  DollyApp
//
//  Created by Joshua Heslin on 25/1/20.
//  Copyright © 2020 Joshua Heslin. All rights reserved.
//

import Foundation
import UIKit
import AssetsPickerViewController
import Photos

class ViewController: UIViewController {
    
    @IBOutlet weak var mainView: UIView!
    var imageViewOne: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupImageViews()
    }

    func setupImageViews() {
        let screenSize: CGRect = UIScreen.main.bounds
        mainView.backgroundColor = .red
        mainView.frame = CGRect(x: 0, y: 80, width: screenSize.width, height: screenSize.width);
        // so it's square
        
        let image = UIImage(named: "moneky.jpg")
        imageViewOne = UIImageView(image: image)
    
        let imageWidth = mainView.frame.width / 2
        let imageHeight = mainView.frame.width / 2
        
        imageViewOne.frame = CGRect(x: 0 + imageWidth, y: 0, width: imageWidth, height: imageHeight)
        
        mainView.addSubview(imageViewOne)
        mainView.bringSubview(toFront: imageViewOne)
        
    }
    
//    func textToImage(drawText text: String, inImage image: UIImage, atPoint point: CGPoint) -> UIImage {
//        let textColor = UIColor.white
//        let textFont = UIFont(name: "Helvetica Bold", size: 15)!
//
//        let scale = UIScreen.main.scale
//        UIGraphicsBeginImageContextWithOptions(image.size, false, scale)
//
//        let textFontAttributes = [
//            NSAttributedString.Key.font: textFont,
//            NSAttributedString.Key.foregroundColor: textColor,
//            ] as [NSAttributedString.Key : Any]
//        image.draw(in: CGRect(origin: CGPoint.zero, size: image.size))
//
//        let rect = CGRect(origin: point, size: image.size)
//        text.draw(in: rect, withAttributes: textFontAttributes)
//
//        let newImage = UIGraphicsGetImageFromCurrentImageContext()
//        UIGraphicsEndImageContext()
//
//        return newImage!
//    }
    
    func addLabelTo(imageView: UIImageView, text: String) {
        let label = UILabel(frame: CGRect(x: imageView.frame.width / 2, y: imageView.frame.width - 15, width: 30, height: 30))
        label.center.x = imageView.center.x
        label.textColor = UIColor.white
        
        let strokeTextAttributes: [NSAttributedString.Key : Any] = [
            .strokeColor : UIColor.black,
            .foregroundColor : UIColor.white,
            .strokeWidth : -2,
            .font : UIFont.systemFont(ofSize: 20.0),
        ]
        label.attributedText = NSAttributedString(string: "HELLO", attributes: strokeTextAttributes)
        
        imageView.addSubview(label)
        
    }
    
    
    @IBAction func addTextToImage(_ sender: Any) {
        
//        let label = UILabel(frame: CGRect(x: 10, y: 0, width: 30, height: 30))
////        self.imageView.frame.width - 10
//        label.textColor = UIColor.white
//
//
//        let strokeTextAttributes: [NSAttributedString.Key : Any] = [
//            .strokeColor : UIColor.black,
//            .foregroundColor : UIColor.white,
//            .strokeWidth : -2,
//            .font : UIFont.systemFont(ofSize: 20.0),
//        ]
//        label.attributedText = NSAttributedString(string: "HELLO", attributes: strokeTextAttributes)
//
////        self.imageView.addSubview(label)
    }
    
    @IBAction func buttonClicked(_ sender: Any) {
        print("tapped")
        
//        let pickerConfig = AssetsPickerConfig()
//        pickerConfig.assetCellType = CustomAssetCell.classForCoder()
//        picker.pickerConfig = pickerConfig
        
        let picker = AssetsPickerViewController()
        picker.pickerDelegate = self
    
        present(picker, animated: true, completion: nil)
        
    }
    
}

// to handle
extension ViewController: AssetsPickerViewControllerDelegate {
    
    func assetsPickerCannotAccessPhotoLibrary(controller: AssetsPickerViewController) {
        print ("Need permission ot access photo library")
    }
    func assetsPickerDidCancel(controller: AssetsPickerViewController) {
        print ("Asset Picker cancelled")
    }
    func assetsPicker(controller: AssetsPickerViewController, selected assets: [PHAsset]) {
        print ("clicked done")
        print (assets)
//        imageView.image = convertImageFromAsset(asset: assets[0])
    }
    func convertImageFromAsset(asset: PHAsset) -> UIImage {
        let manager = PHImageManager.default()
        let option = PHImageRequestOptions()
        var image = UIImage()
        option.isSynchronous = true
        manager.requestImage(for: asset, targetSize: PHImageManagerMaximumSize, contentMode: .aspectFit, options: option, resultHandler: {(result, info)->Void in
            image = result!
        })
        return image
    }
    func assetsPicker(controller: AssetsPickerViewController, shouldSelect asset: PHAsset, at indexPath: IndexPath) -> Bool {
        // can limit selection count
        print ("should select \(indexPath.row)")
        if controller.selectedAssets.count > 3 {
            // do your job here
            print ("more than 3 selected")
            return false
        }
        return true
    }
    func assetsPicker(controller: AssetsPickerViewController, didSelect asset: PHAsset, at indexPath: IndexPath) {
        print ("did select \(indexPath.row)")
    }
    func assetsPicker(controller: AssetsPickerViewController, shouldDeselect asset: PHAsset, at indexPath: IndexPath) -> Bool {
        print ("should deselect \(indexPath.row)")
        return true
    }
    func assetsPicker(controller: AssetsPickerViewController, didDeselect asset: PHAsset, at indexPath: IndexPath) {
        print ("did deselect \(indexPath.row)")
    }
}

