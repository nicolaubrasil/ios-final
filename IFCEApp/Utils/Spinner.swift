//
//  Spinner.swift
//  IFCEApp
//
//  Created by Nicolau Brasil on 27/04/19.
//  Copyright © 2019 William Nicolau Brasil Araújo. All rights reserved.
//

import UIKit

public class Spinner {
    
    internal static var spinner: UIActivityIndicatorView?
    public static var style: UIActivityIndicatorView.Style = .whiteLarge
    public static var baseBackColor = UIColor.black.withAlphaComponent(0.5)
    
    public static func start(style: UIActivityIndicatorView.Style = style, backColor: UIColor = baseBackColor) {
        if spinner == nil, let window = UIApplication.shared.keyWindow {
            let frame = UIScreen.main.bounds
            spinner = UIActivityIndicatorView(frame: frame)
            spinner!.backgroundColor = backColor
            spinner!.style = style
            window.addSubview(spinner!)
            spinner!.startAnimating()
        }
    }
    
    public static func stop() {
        if spinner != nil {
            spinner!.stopAnimating()
            spinner!.removeFromSuperview()
            spinner = nil
        }
    }
}
