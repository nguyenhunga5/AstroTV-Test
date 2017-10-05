//
//  UIImageViewExt.swift
//  AstroTV
//
//  Created by Hung Nguyen Thanh on 10/3/17.
//  Copyright © 2017 Hung Nguyen Thanh. All rights reserved.
//

import UIKit

private let cache = NSCache<NSString, UIImage>()
private var currentURLKey: Int = 0
extension UIImageView {
    
    private var currentURL: URL? {
        
        set {
            
            objc_setAssociatedObject(self, &currentURLKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        }
        
        get {
            
            if let url = objc_getAssociatedObject(self, &currentURLKey) as? URL {
                
                return url
            } else {
                
                return nil
            }
        }
    }
    
    func setImage(with url: URL?, placeholderImage: UIImage?, showActivityIndicator: Bool = true) {
        
        self.currentURL = url
        if let url = url {
            
            if let image = cache.object(forKey: url.relativeString as NSString) {
                
                self.image = image
            } else {
                
                ATVNetworkUtils.sharedInstance.downloadImage(with: url, completeHandler: { (image) in
                    
                    if self.currentURL == url {
                        
                        self.image = image
                    }
                })
            }
        }
        
    }
}
