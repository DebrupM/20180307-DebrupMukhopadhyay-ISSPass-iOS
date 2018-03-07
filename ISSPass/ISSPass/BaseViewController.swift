//
//  BaseViewController.swift
//  ISSPass
//
//  Created by Debrup Mukhopadhyay on 07/03/18.
//  Copyright © 2018 debrup. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

    let loadingView: UIView = UIView.init(frame: UIScreen.main.bounds)
    let loadingIndicator: UIActivityIndicatorView = UIActivityIndicatorView.init(activityIndicatorStyle: .whiteLarge)
    let effectView = UIVisualEffectView.init(frame: UIScreen.main.bounds)
    
    
    // MARK: - Overriding point for view lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Concrete parent class methods
    
    /** Superview method to display activity indicator over the View Controller invoked from.
     - Note: The method is invoked from the delegate queue. Invoke from Main Queue in case delegate queue in otherwise.
     - Warning: Parameter cannot be `nil`
     - Parameter indicatorTitle: The `String` to be displayed below activity indicator. Cannot be `nil`. Empty string displays "Loading..."
     */
    func showActivityIndicator(withTitle indicatorTitle: String) {
        loadingView.backgroundColor = UIColor.lightGray
        loadingView.alpha = 0.75
        
        let screenCenter = loadingView.convert(loadingView.center, from: loadingView.superview)
        let vwCenter = UIView.init(frame: CGRect(x: 0, y: 0, width: 180, height: 120))
        vwCenter.center = screenCenter
        vwCenter.backgroundColor = UIColor.black
        vwCenter.layer.cornerRadius = 20
        vwCenter.layer.masksToBounds = true
        loadingView.addSubview(vwCenter)
        
        let lblStatus = UILabel.init(frame: CGRect.init(x: screenCenter.x-100, y: screenCenter.y+10, width: 200, height: 50))
        lblStatus.text = (indicatorTitle.isEmpty) ? "Loading..." : indicatorTitle
        lblStatus.textColor = UIColor.white
        lblStatus.textAlignment = NSTextAlignment.center
        lblStatus.font = UIFont.boldSystemFont(ofSize: 16)
        loadingView.addSubview(lblStatus)
        
        loadingIndicator.frame = CGRect.init(x: screenCenter.x-25, y: screenCenter.y-40, width: 50, height: 50)
        loadingIndicator.startAnimating()
        loadingView.addSubview(loadingIndicator)
        self.view.addSubview(loadingView)
    }
    
    
    /** Superview method to hide an animating activity indicator
     - Note: The method is invoked from the delegate queue. Invoke from Main Queue in case delegate queue in otherwise.
     */
    func hideActivityIndicator() {
        if loadingIndicator.isAnimating {
            self.loadingIndicator.stopAnimating()
            self.loadingView.removeFromSuperview()
        }
    }

}
