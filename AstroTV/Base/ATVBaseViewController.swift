//
//  ATVBaseViewController.swift
//  AstroTV
//
//  Created by Hung Nguyen Thanh on 10/2/17.
//  Copyright © 2017 Hung Nguyen Thanh. All rights reserved.
//

import UIKit

private var loadingViewKey: Int = 0
class ATVBaseViewController: UIViewController {

    var loadingView: ATVLoadingView? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func showLoading(with text: String? ) {
        
        if self.loadingView == nil {
            
            self.loadingView = ATVLoadingView.show(inView: self.view)
        }
        
        self.loadingView?.textLabel.text = text
        self.loadingView?.alpha = 0
        UIView.animate(withDuration: 0.15, animations: {
            
            self.loadingView?.alpha = 1
        }, completion: { (success) in
            
            self.loadingView?.isHidden = false
        })
    }
    
    func hideLoading() {
        
        if let loadingView = self.loadingView {
            
            UIView.animate(withDuration: 0.5, animations: {
                
                loadingView.alpha = 0
            }, completion: { (success) in
                
                loadingView.isHidden = true
            })
        }
    }
    
    func showAlert(title: String?, message: String, buttonTitles: String..., completeHandler: ATVAlertHandlerClosue?) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        var alertAction: UIAlertAction
        alertAction = UIAlertAction(title: buttonTitles[0], style: .cancel, handler: { (action) in
            
            if let completeHandler = completeHandler {
                
                completeHandler(0)
                
            }
            
        })
        
        alertController.addAction(alertAction)
        
        if buttonTitles.count > 1 {
            
            for index in 1..<buttonTitles.count {
                
                alertAction = UIAlertAction(title: buttonTitles[index], style: .cancel, handler: { (action) in
                    
                    if let completeHandler = completeHandler {
                        
                        completeHandler(index)
                        
                    }
                    
                })
                
                alertController.addAction(alertAction)
                
            }
            
        }
        
        self.present(alertController, animated: true, completion: nil)
        
    }

}
