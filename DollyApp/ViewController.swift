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
import GoogleMobileAds

class ViewController: UIViewController {
    
    @IBOutlet weak var clearButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var mainView: UIView!
    
    var bannerView: GADBannerView!
    
    var imageViewOne: UIImageView!
    var imageViewTwo: UIImageView!
    var imageViewThree: UIImageView!
    var imageViewFour: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setNeedsStatusBarAppearanceUpdate()
    
        let view = HandleViews()
        view.styleButton(button: button)
        view.styleSaveButton(button: saveButton)
        view.styleClearButton(button: clearButton)
        
        // test adunit id = ca-app-pub-3940256099942544/2934735716
        // my adunit id = ca-app-pub-4916416515738035/5715541470
        bannerView = GADBannerView(adSize: kGADAdSizeLargeBanner)
        addBannerViewToView(bannerView)
        bannerView.adUnitID = "ca-app-pub-4916416515738035/5715541470"
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
        
    
        loadDefaultImages()
        clearButton.isHidden = true
        saveButton.isHidden = true
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    func addBannerViewToView(_ bannerView: GADBannerView) {
        // 350 x 50 or 350 x 100
        let screenSize: CGRect = UIScreen.main.bounds
        bannerView.frame = CGRect(x: 0, y: 45, width: screenSize.width, height: 100);
        bannerView.center.x = view.center.x
        view.addSubview(bannerView)
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
        let offset: CGFloat = 150
        let screenSize: CGRect = UIScreen.main.bounds
        mainView.frame = CGRect(x: 0, y: offset, width: screenSize.width, height: screenSize.width);
        
        let imageWidth = mainView.frame.width / 2
        let imageHeight = mainView.frame.width / 2
        
        imageViewOne = UIImageView(image: images[0])
        imageViewOne.frame = CGRect(x: 0, y: 0, width: imageWidth, height: imageHeight)
        imageViewOne.contentMode = .scaleAspectFill
        imageViewOne.clipsToBounds = true;
        
        imageViewTwo = UIImageView(image: images[1])
        imageViewTwo.frame = CGRect(x: 0 + imageWidth, y: 0, width: imageWidth, height: imageHeight)
        imageViewTwo.contentMode = .scaleAspectFill
        imageViewTwo.clipsToBounds = true;
        
        imageViewThree = UIImageView(image: images[2])
        imageViewThree.frame = CGRect(x: 0, y: 0 + imageWidth, width: imageWidth, height: imageHeight)
        imageViewThree.contentMode = .scaleAspectFill
        imageViewThree.clipsToBounds = true;
        
        imageViewFour = UIImageView(image: images[3])
        imageViewFour.frame = CGRect(x: 0 + imageWidth, y: 0 + imageWidth, width: imageWidth, height: imageHeight)
        imageViewFour.contentMode = .scaleAspectFill
        imageViewFour.clipsToBounds = true;
        
        mainView.addSubview(imageViewOne)
        mainView.addSubview(imageViewTwo)
        mainView.addSubview(imageViewThree)
        mainView.addSubview(imageViewFour)
        
        mainView.bringSubview(toFront: imageViewOne)
        mainView.bringSubview(toFront: imageViewTwo)
        mainView.bringSubview(toFront: imageViewThree)
        mainView.bringSubview(toFront: imageViewFour)
    
        let view = HandleViews()
        let l = imageViewOne.frame.width
        view.addLabelTo(view: mainView, imageView: imageViewOne, string: "LINKEDIN", x: l / 2, y: l)
        view.addLabelTo(view: mainView, imageView: imageViewTwo, string: "FACEBOOK", x: l * 1.5, y: l)
        view.addLabelTo(view: mainView, imageView: imageViewThree, string: "INSTAGRAM", x: l * 0.5, y: l * 2)
        view.addLabelTo(view: mainView, imageView: imageViewFour, string: "TINDER", x: l * 1.5, y: l * 2)
    
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
            let ac = UIAlertController(title: "Saved to Photos", message: "Your meme has been saved to your photos.", preferredStyle: .alert)
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
        var image = UIImage()
        let manager = PHImageManager.default()
        let options = PHImageRequestOptions()
        options.deliveryMode = PHImageRequestOptionsDeliveryMode.highQualityFormat
        options.isSynchronous = true
        options.isNetworkAccessAllowed = true
        options.progressHandler = {  (progress, error, stop, info) in
            print("progress: \(progress)")
        }
        options.normalizedCropRect = CGRect(x: 0, y: 0, width: 500, height: 500)
        manager.requestImage(for: asset, targetSize: CGSize(width: 500, height: 500), contentMode: .aspectFit, options: options, resultHandler: {(result, info)->Void in
            if let result = result {
                image = result
            }
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

