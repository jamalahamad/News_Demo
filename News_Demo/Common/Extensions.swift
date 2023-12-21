//
//  Extensions.swift
//  News_Demo
//
//  Created by Jamal Ahamad on 05/02/20.
//  Copyright © 2020 Jamal Ahamad. All rights reserved.
//

import Foundation
import UIKit


extension UIViewController {

func showAlert (title:String, message:String, completion:@escaping (_ result:Bool) -> Void) {
    let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
    self.present(alert, animated: true, completion: nil)

    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
        completion(true)
    }))

    alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
        completion(false)
    }))
  }
}

extension UILabel {

    var isTruncated: Bool {
        guard let labelText = text else { return false }

        let labelTextSize = (labelText as NSString).boundingRect(
            with: CGSize(width: frame.size.width, height: .greatestFiniteMagnitude),
            options: .usesLineFragmentOrigin,
            attributes: [.font: font!],
            context: nil).size
        if (labelTextSize.height - bounds.size.height) > 5 {
            return true
        } else {
            return false
        }
    }
    
    var lblHeight: CGFloat {
        guard let labelText = text else { return 0 }
       let labelTextSize = (labelText as NSString).boundingRect(
       with: CGSize(width: frame.size.width, height: .greatestFiniteMagnitude),
       options: .usesLineFragmentOrigin,
       attributes: [.font: font!],
       context: nil).size
       return labelTextSize.height
    }
}

public class LoadingOverlay{

var overlayView = UIView()
var activityIndicator = UIActivityIndicatorView()

class var shared: LoadingOverlay {
    struct Static {
        static let instance: LoadingOverlay = LoadingOverlay()
    }
    return Static.instance
}

    public func showOverlay(view: UIView) {

        overlayView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        overlayView.center = view.center
        overlayView.backgroundColor = .lightGray
        overlayView.alpha = 0.4
        overlayView.clipsToBounds = true
        overlayView.layer.cornerRadius = 10
        activityIndicator.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        activityIndicator.style = UIActivityIndicatorView.Style.large
        activityIndicator.center = CGPoint(x: overlayView.bounds.width / 2, y:  overlayView.bounds.height / 2)
        activityIndicator.color = UIColor.red
        overlayView.addSubview(activityIndicator)
        view.addSubview(overlayView)
        activityIndicator.startAnimating()
    }

    public func hideOverlayView() {
        activityIndicator.stopAnimating()
        overlayView.removeFromSuperview()
    }
}
