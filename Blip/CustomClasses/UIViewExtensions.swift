//
//  UIViewExtensions.swift
//  Blip
//
//  Created by Srikanth Srinivas on 3/1/18.
//  Copyright © 2018 Blip Groceries. All rights reserved.
//

import Foundation
import UIKit

extension UIView{
    
    func ApplyOuterShadowToView(){
        self.layer.shadowOpacity = 0.5
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 2.5)
        self.layer.masksToBounds = false
        self.layer.shadowRadius = 3
    }
    
    func ApplyCornerRadiusToView(){
        self.layer.cornerRadius = 7
        self.clipsToBounds = true
    }
}

extension UINavigationController{
    
    func setColorToNavBar(color: UIColor){
        
        let image = UIImage.imageFromColor(color: color)
        self.navigationBar.setBackgroundImage(image, for: .default)
        self.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.barStyle = .default
    }
}

extension UIImage{
    
    static func imageFromColor(color: UIColor) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        
        // create a 1 by 1 pixel context
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0)
        color.setFill()
        UIRectFill(rect)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
        
    }
}

extension UIViewController{
    
    
    func blend(from: UIColor, to: UIColor, percent: Double) -> UIColor? {
        var fR : CGFloat = 0.0
        var fG : CGFloat = 0.0
        var fB : CGFloat = 0.0
        var tR : CGFloat = 0.0
        var tG : CGFloat = 0.0
        var tB : CGFloat = 0.0
        
        from.getRed(&fR, green: &fG, blue: &fB, alpha: nil)
        to.getRed(&tR, green: &tG, blue: &tB, alpha: nil)
        
        let dR = tR - fR
        let dG = tG - fG
        let dB = tB - fB
        if percent == 0{
            return UIColor.clear
        }
        else if percent < 1.0{

            let rR = fR + dR * CGFloat(percent)
            let rG = fG + dG * CGFloat(percent)
            let rB = fB + dB * CGFloat(percent)
            
            return UIColor(red: rR, green: rG, blue: rB, alpha: 1.0)
        }
        return nil

    }
    
//    // Pass in the scroll percentage to get the appropriate color
//    func scrollColor(percent: Double) -> UIColor {
//        var start = UIColor.clear
//        var end = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
//        var perc = percent
//        if percent < 0.5 {
//            // If the scroll percentage is 0.0..<0.5 blend between yellow and green
//            start = UIColor.yellow
//            end = UIColor.green
//        } else {
//            // If the scroll percentage is 0.5..1.0 blend between green and blue
//            start = UIColor.green
//            end = UIColor.blue
//            perc -= 0.5
//        }
//
//        return blend(from: start, to: end, percent: perc * 2.0)!
//    }
    
    func setTitleForNavBar(title:String, subtitle:String, gesture: UIGestureRecognizer?) {
        let titleLabel = UILabel(frame: CGRect(x: 0, y: -2, width: 0, height: 0))
        
        titleLabel.backgroundColor = UIColor.clear
        titleLabel.textColor = UIColor.white
        titleLabel.font = UIFont.boldSystemFont(ofSize: 15)
        titleLabel.text = title
        titleLabel.sizeToFit()
        
        let subtitleLabel = UILabel(frame: CGRect(x: 0, y: 18, width: 0, height: 0))
        subtitleLabel.backgroundColor = UIColor.clear
        subtitleLabel.textColor = UIColor.white
        subtitleLabel.font = UIFont.systemFont(ofSize: 10)
        subtitleLabel.text = subtitle
        subtitleLabel.sizeToFit()
        
        let titleView = UIView(frame: CGRect(x: 0, y: 0, width: max(titleLabel.frame.size.width, subtitleLabel.frame.size.width), height: 30))
        titleView.addSubview(titleLabel)
        titleView.addSubview(subtitleLabel)
        
        let widthDiff = subtitleLabel.frame.size.width - titleLabel.frame.size.width
        
        if widthDiff < 0 {
            let newX = widthDiff / 2
            subtitleLabel.frame.origin.x = abs(newX)
        } else {
            let newX = widthDiff / 2
            titleLabel.frame.origin.x = newX
        }
        
        if let tap = gesture{
            titleView.addGestureRecognizer(tap)
        }
        
        self.navigationItem.titleView = titleView
    }
}

final class ParallaxHeaderView: UIView {
    
    fileprivate var heightLayoutConstraint = NSLayoutConstraint()
    fileprivate var bottomLayoutConstraint = NSLayoutConstraint()
    fileprivate var containerView = UIView()
    fileprivate var containerLayoutConstraint = NSLayoutConstraint()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.backgroundColor = UIColor.red
        
        self.addSubview(containerView)
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[containerView]|",
                                                           options: NSLayoutFormatOptions(rawValue: 0),
                                                           metrics: nil,
                                                           views: ["containerView" : containerView]))
        
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[containerView]|",
                                                           options: NSLayoutFormatOptions(rawValue: 0),
                                                           metrics: nil,
                                                           views: ["containerView" : containerView]))
        
        containerLayoutConstraint = NSLayoutConstraint(item: containerView,
                                                       attribute: .height,
                                                       relatedBy: .equal,
                                                       toItem: self,
                                                       attribute: .height,
                                                       multiplier: 1.0,
                                                       constant: 0.0)
        self.addConstraint(containerLayoutConstraint)
        
        let imageView: UIImageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .white
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(named: "YourImage")
        
        containerView.addSubview(imageView)
        containerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[imageView]|",
                                                                    options: NSLayoutFormatOptions(rawValue: 0),
                                                                    metrics: nil,
                                                                    views: ["imageView" : imageView]))
        
        bottomLayoutConstraint = NSLayoutConstraint(item: imageView,
                                                    attribute: .bottom,
                                                    relatedBy: .equal,
                                                    toItem: containerView,
                                                    attribute: .bottom,
                                                    multiplier: 1.0,
                                                    constant: 0.0)
        
        containerView.addConstraint(bottomLayoutConstraint)
        
        heightLayoutConstraint = NSLayoutConstraint(item: imageView,
                                                    attribute: .height,
                                                    relatedBy: .equal,
                                                    toItem: containerView,
                                                    attribute: .height,
                                                    multiplier: 1.0,
                                                    constant: 0.0)
        
        containerView.addConstraint(heightLayoutConstraint)
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        containerLayoutConstraint.constant = scrollView.contentInset.top;
        let offsetY = -(scrollView.contentOffset.y + scrollView.contentInset.top);
        containerView.clipsToBounds = offsetY <= 0
        bottomLayoutConstraint.constant = offsetY >= 0 ? 0 : -offsetY / 2
        heightLayoutConstraint.constant = max(offsetY + scrollView.contentInset.top, scrollView.contentInset.top)
    }
}

