//
//  MainView.swift
//  DollyApp
//
//  Created by Joshua Heslin on 25/1/20.
//  Copyright © 2020 Joshua Heslin. All rights reserved.
//
import UIKit
import Foundation

class HandleViews {
    func styleButton(button: UIButton) {
        button.backgroundColor = UIColor(rgbHex: 0x00A699)
        button.layer.cornerRadius = button.frame.height / 2
        button.setTitleColor(.white, for: .normal)
    }
    
    func styleSaveButton(button: UIButton) {
        button.backgroundColor = UIColor(rgbHex: 0xFF5A5F)
        button.layer.cornerRadius = button.frame.height / 2
        button.setTitleColor(.white, for: .normal)
    }
    
    func styleClearButton(button: UIButton) {
        button.backgroundColor = UIColor(rgbHex: 0xFF5A5F)
        button.layer.cornerRadius = button.frame.height / 2
        button.setTitleColor(.white, for: .normal)
    }

    func addLabelTo(view: UIView, imageView: UIImageView, string: String, x: CGFloat, y: CGFloat) {
        let length = imageView.frame.width
        let offset: CGFloat = 30
        let label = UILabel(frame: CGRect(x: x, y: y - offset, width: length, height: offset))
        label.center.x = imageView.center.x
        label.textColor = UIColor.white

        let attributes: [NSAttributedString.Key : Any] = [
            .strokeColor : UIColor.black,
            .foregroundColor : UIColor.white,
            .strokeWidth : -2,
            .font : UIFont.systemFont(ofSize: 25, weight: .heavy),
        ]

        let attributedText = NSMutableAttributedString(string: string, attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 20)])
        attributedText.addAttributes(attributes, range: NSRange(location: 0, length: string.count))

        label.attributedText = attributedText
        label.textAlignment = .center

        view.addSubview(label)
        view.bringSubview(toFront: label)
    }
    
}
