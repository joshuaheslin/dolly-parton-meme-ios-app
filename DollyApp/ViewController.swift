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
    
    func imageWith(text: String) -> UIImage? {
        let frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        let nameLabel = UILabel(frame: frame)
        nameLabel.textAlignment = .center
        nameLabel.backgroundColor = .lightGray
        nameLabel.textColor = .white
        nameLabel.font = UIFont.boldSystemFont(ofSize: 40)
        nameLabel.text = text
        UIGraphicsBeginImageContext(frame.size)
        if let currentContext = UIGraphicsGetCurrentContext() {
            nameLabel.layer.render(in: currentContext)
            let nameImage = UIGraphicsGetImageFromCurrentImageContext()
            return nameImage
        }
        return nil
    }
    
    func loadDefaultImages() {
//        let image = UIImage(named: "moneky.jpg")!
        let img1 = imageWith(text: "1")
        let img2 = imageWith(text: "2")
        let img3 = imageWith(text: "3")
        let img4 = imageWith(text: "4")
        if let img1 = img1, let img2 = img2, let img3 = img3, let img4 = img4 {
            let images: [UIImage] = [img1, img2, img3, img4]
            handleImagesUpload(images: images)
        }
        
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
            let ac = UIAlertController(title: "Saved!", message: "The meme has been saved to your photos.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
    }
    
    @IBAction func openGallery(_ sender: Any) {
//        let pickerConfig = AssetsPickerConfig()
//        pickerConfig.assetCellType = CustomAssetCell.classForCoder()
        
        let picker = AssetsPickerViewController()
//        picker.pickerConfig = pickerConfig
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

