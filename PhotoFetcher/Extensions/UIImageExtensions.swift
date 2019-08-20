//
//  UIImageExtensions.swift
//  PhotoFetcher
//
//  Created by Mohammad on 8/20/19.
//  Copyright © 2019 Mohammadrf. All rights reserved.
//

import UIKit

extension UIImage {

  class func colorImage(_ color: UIColor, size: CGSize) -> UIImage? {
    UIGraphicsBeginImageContext(size)
    
    let context = UIGraphicsGetCurrentContext()
    let frame = CGRect(origin: CGPoint.zero, size: size)
    context?.setFillColor(color.cgColor)
    context?.fill(frame)
    
    let result = UIGraphicsGetImageFromCurrentImageContext()
    
    UIGraphicsEndImageContext()
    
    return result
  }
}
