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

    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        print ("hey")
    }
    
    func textToImage(drawText text: String, inImage image: UIImage, atPoint point: CGPoint) -> UIImage {
        let textColor = UIColor.white
        let textFont = UIFont(name: "Helvetica Bold", size: 15)!
        
        let scale = UIScreen.main.scale
        UIGraphicsBeginImageContextWithOptions(image.size, false, scale)
        
        let textFontAttributes = [
            NSAttributedString.Key.font: textFont,
            NSAttributedString.Key.foregroundColor: textColor,
            ] as [NSAttributedString.Key : Any]
        image.draw(in: CGRect(origin: CGPoint.zero, size: image.size))
        
        let rect = CGRect(origin: point, size: image.size)
        text.draw(in: rect, withAttributes: textFontAttributes)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    
    @IBAction func addTextToImage(_ sender: Any) {
        
        
        
    }
    
    @IBAction func buttonClicked(_ sender: Any) {
        print("tapped")
        
        let pickerConfig = AssetsPickerConfig()
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
        print ("Save selected assets")
        print (assets)
        // do your job with selected assets
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

