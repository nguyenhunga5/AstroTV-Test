//
//  ATVLoadingView.swift
//  AstroTV
//
//  Created by Hung Nguyen Thanh on 10/3/17.
//  Copyright © 2017 Hung Nguyen Thanh. All rights reserved.
//

import UIKit

typealias ATVLoadingTapClosure = () -> Void
class ATVLoadingView: ATVView {

    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var textLabel: UILabel!
    
    var tapCallback: ATVLoadingTapClosure?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
    }
    
    class func show(inView parentView: UIView) -> ATVLoadingView {
        
        let nib = UINib(nibName: "ATVLoadingView", bundle: nil)
        let tops = nib.instantiate(withOwner: nil, options: nil)
        var loadingView: ATVLoadingView? = nil
        for item in tops {
            
            if let view = item as? ATVLoadingView {
                
                parentView.addSubview(view)
                view.loadDefault()
                loadingView = view
                break
            }
        }
        
        if loadingView == nil {
            
            loadingView = ATVLoadingView(frame: parentView.bounds)
        }
        
        return loadingView!
    }
    
    func loadDefault() {
        
        self.isUserInteractionEnabled = true
        
        self.textLabel.text = ""
        
        guard let parentView = self.superview else {
            
            return
        }
        
        self.translatesAutoresizingMaskIntoConstraints = false

        parentView.addConstraint(NSLayoutConstraint(item: parentView, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.top, multiplier: 1.0, constant: 0))
        parentView.addConstraint(NSLayoutConstraint(item: parentView, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.bottom, multiplier: 1.0, constant: 0))
        parentView.addConstraint(NSLayoutConstraint(item: parentView, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.leading, multiplier: 1.0, constant: 0))
        parentView.addConstraint(NSLayoutConstraint(item: parentView, attribute: NSLayoutAttribute.trailing, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.trailing, multiplier: 1.0, constant: 0))
        
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    @IBAction func tapGestureHandler(_ sender: Any) {
        
        if let tapCallback = self.tapCallback {
            
            tapCallback()
        }
    }
    
}
