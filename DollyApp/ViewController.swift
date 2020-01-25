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
        addLabels()
        let image = mainView.asImage()
        print (image)
        saveToLibrary(image: image)
    }
    
    func addLabels() {
        if (imageViewOne != nil) {
            addLabelTo(imageView: imageViewOne, string: "HELLO")
        }
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
    
    func addLabelTo(imageView: UIImageView, string: String) {
        let length = imageView.frame.width
        let offset: CGFloat = 25
        let label = UILabel(frame: CGRect(x: length / 2, y: length - offset, width: length / 2, height: offset))
        label.center.x = imageView.center.x
        label.textColor = UIColor.white
        
        let attributes: [NSAttributedString.Key : Any] = [
            .strokeColor : UIColor.black,
            .foregroundColor : UIColor.white,
            .strokeWidth : -2,
            .font : UIFont.systemFont(ofSize: 20, weight: .heavy),
        ]
        
        let attributedText = NSMutableAttributedString(string: string, attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 20)])
        attributedText.addAttributes(attributes, range: NSRange(location: 0, length: string.count))
        
        label.attributedText = attributedText
        label.textAlignment = .center
        
        mainView.addSubview(label)
        mainView.bringSubview(toFront: label)
    }
    
    func saveToLibrary(image: UIImage) {
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            // we got back an error!
            let ac = UIAlertController(title: "Save error", message: error.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        } else {
            let ac = UIAlertController(title: "Saved!", message: "Your altered image has been saved to your photos.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
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

extension UIView {
    func asImage() -> UIImage {
        if #available(iOS 10.0, *) {
            let renderer = UIGraphicsImageRenderer(bounds: bounds)
            return renderer.image { rendererContext in
                layer.render(in: rendererContext.cgContext)
            }
        } else {
            UIGraphicsBeginImageContext(self.frame.size)
            self.layer.render(in:UIGraphicsGetCurrentContext()!)
            let image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return UIImage(cgImage: image!.cgImage!)
        }
    }
}

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

