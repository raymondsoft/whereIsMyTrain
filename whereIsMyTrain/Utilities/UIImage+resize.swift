//
//  UIImage+resize.swift
//  whereIsMyTrain
//
//  Created by etudiant-09 on 11/04/2017.
//  Copyright © 2017 etudiant-09. All rights reserved.
//


import UIKit

extension UIImage {
    
    func resizeImage(newWidth: CGFloat) -> UIImage {
        
        let scale = newWidth / self.size.width
        let newHeight = self.size.height * scale
        
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        
        
        self.draw(in: CGRect(x: 0, y: 0,width: newWidth, height: newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
}
