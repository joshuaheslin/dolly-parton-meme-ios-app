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
    
    @IBOutlet weak var clearButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var mainView: UIView!
    
    var imageViewOne: UIImageView!
    var imageViewTwo: UIImageView!
    var imageViewThree: UIImageView!
    var imageViewFour: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        let view = MainView()
        view.styleButton(button: button)
        view.styleSaveButton(button: saveButton)
        view.styleClearButton(button: clearButton)
    
        loadDefaultImages()
        clearButton.isHidden = true
        saveButton.isHidden = true
    }
    
    func loadDefaultImages() {
        let image = UIImage(named: "moneky.jpg")!
        let images: [UIImage] = [image, image, image, image]
        handleImagesUpload(images: images)
    }
    
    func handleImagesUpload(images: [UIImage]) {
        let screenSize: CGRect = UIScreen.main.bounds
        mainView.backgroundColor = .red
        mainView.frame = CGRect(x: 0, y: 80, width: screenSize.width, height: screenSize.width);
        
        let imageWidth = mainView.frame.width / 2
        let imageHeight = mainView.frame.width / 2
        
        imageViewOne = UIImageView(image: images[0])
        imageViewOne.frame = CGRect(x: 0, y: 0, width: imageWidth, height: imageHeight)
        
        imageViewTwo = UIImageView(image: images[1])
        imageViewTwo.frame = CGRect(x: 0 + imageWidth, y: 0, width: imageWidth, height: imageHeight)
        
        imageViewThree = UIImageView(image: images[2])
        imageViewThree.frame = CGRect(x: 0, y: 0 + imageWidth, width: imageWidth, height: imageHeight)
        
        imageViewFour = UIImageView(image: images[3])
        imageViewFour.frame = CGRect(x: 0 + imageWidth, y: 0 + imageWidth, width: imageWidth, height: imageHeight)
        
        mainView.addSubview(imageViewOne)
        mainView.addSubview(imageViewTwo)
        mainView.addSubview(imageViewThree)
        mainView.addSubview(imageViewFour)
        
        mainView.bringSubview(toFront: imageViewOne)
        mainView.bringSubview(toFront: imageViewTwo)
        mainView.bringSubview(toFront: imageViewThree)
        mainView.bringSubview(toFront: imageViewFour)
    
        let view = MainView()
        let l = imageViewOne.frame.width
        view.addLabelTo(view: mainView, imageView: imageViewOne, string: "LinkedIn", x: l / 2, y: l)
        view.addLabelTo(view: mainView, imageView: imageViewTwo, string: "Facebook", x: l * 1.5, y: l)
        view.addLabelTo(view: mainView, imageView: imageViewThree, string: "Instagram", x: l * 0.5, y: l * 2)
        view.addLabelTo(view: mainView, imageView: imageViewFour, string: "Tinder", x: l * 1.5, y: l * 2)
    
        saveButton.isHidden = false
        clearButton.isHidden = false
    }

    let alert = UIAlertController(title: nil, message: "Saving to Library...", preferredStyle: .alert)
    func saveToLibrary(image: UIImage) {
        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.activityIndicatorViewStyle = UIActivityIndicatorView.Style.gray
        loadingIndicator.startAnimating();
        
        alert.view.addSubview(loadingIndicator)
        present(alert, animated: true, completion: nil)
        
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        alert.dismiss(animated: false, completion: nil)
        
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
    
    @IBAction func openGallery(_ sender: Any) {
        //        let pickerConfig = AssetsPickerConfig()
        //        pickerConfig.assetCellType = CustomAssetCell.classForCoder()
        //        picker.pickerConfig = pickerConfig
        let picker = AssetsPickerViewController()
        picker.pickerDelegate = self
        present(picker, animated: true, completion: nil)
    }
    @IBAction func savePhoto(_ sender: Any) {
        let image = mainView.asImage()
        saveToLibrary(image: image)
    }
    @IBAction func clearButtonTapped(_ sender: Any) {
        loadDefaultImages()
        saveButton.isHidden = true
        clearButton.isHidden = true
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
        if (assets.count != 4) {
            let alert = UIAlertController(title: "Try Again", message: "Please select 4 images.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
            self.present(alert, animated: true)
            return
        }
        
        var images: [UIImage] = []
        for asset in assets {
            images.append(convertImageFromAsset(asset: asset))
        }
        handleImagesUpload(images: images)
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
//        print ("should select \(indexPath.row)")
        if controller.selectedAssets.count >= 4 {
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

