//
//  ViewController.swift
//  iOSChatHead
//
//  Created by iMac on 10/23/18.
//  Copyright © 2018 jriosdev. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var chat1:iOSChatHead!
    var chat2:iOSChatHead!
    var chat3:iOSChatHead!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.chat1 = iOSChatHead.init(view: self.view, frame: CGRect(x: 0, y: 150, width: 50, height: 50))
        self.chat1.badgeEdgeInsets = UIEdgeInsets(top: 10, left: 15, bottom: 0, right: 15)
        chat1.setImage(#imageLiteral(resourceName: "cha1.png"), for: .normal)
        chat1.draggable = false
        self.chat2 = iOSChatHead.init(view: self.view, frame: CGRect(x: 0, y: 350, width: 50, height: 50))
        self.chat2.badgeEdgeInsets = UIEdgeInsets(top: 10, left: 15, bottom: 0, right: 15)
        chat2.setImage(#imageLiteral(resourceName: "chat2.png"), for: .normal)
        self.chat3 = iOSChatHead.init( frame: CGRect(x: 0, y: 600, width: 50, height: 50))
        self.chat3.badgeEdgeInsets = UIEdgeInsets(top: 10, left: 15, bottom: 0, right: 15)
        chat3.setImage(#imageLiteral(resourceName: "chat3.png"), for: .normal)
        UIApplication.shared.keyWindow?.bringSubviewToFront(self.chat3)
        chat3.badgeString = "789"
        chat1.badgeString = "New"
        
        
        
        
        
        self.chat1.tapBlock = {
            self.showTopBarAlert("chat 1 Single tap")
        }
        
        self.chat1.doubleTapBlock = {
           self.showTopBarAlert("chat 1 Double tap")
        }
        
        self.chat1.longPressBlock = {
            self.showTopBarAlert("chat 1 Long Press")
        }
        
        self.chat2.tapBlock = {
            self.showTopBarAlert("chat 2 Single tap")
        }
        
        self.chat2.doubleTapBlock = {
            self.showTopBarAlert("chat 2 Double tap")
        }
        
        self.chat2.longPressBlock = {
            self.showTopBarAlert("chat 2 Long Press")
        }
        self.chat3.tapBlock = {
            self.showTopBarAlert("chat 3 Single tap")
        }
        
        self.chat3.doubleTapBlock = {
            self.showTopBarAlert("chat 3 Double tap")
        }
        
        self.chat3.longPressBlock = {
            self.showTopBarAlert("chat 3 Long Press")
        }
        
    }

    
    
    
    
    
    
    func showTopBarAlert(_ msgText:String?){
        self.navigationController?.navigationBar.isTranslucent = false
        let alert = UIView(frame: CGRect(origin: self.view.bounds.origin, size: CGSize(width: self.view.frame.size.width, height: 60)))
        alert.backgroundColor = #colorLiteral(red: 0, green: 0.7503070831, blue: 0.5240698457, alpha: 1)
        let msg = UILabel(frame:  CGRect(x: alert.frame.origin.x + 8, y: alert.frame.origin.y + 8, width: alert.frame.size.width, height: 50))
        
        msg.text = msgText
        msg.numberOfLines = 0
        msg.adjustsFontSizeToFitWidth = true
        msg.textColor = .white
        alert.addSubview(msg)
        self.view.addSubview(alert)
        alert.transform = CGAffineTransform(translationX: 0, y: -60)
        UIView.animate(withDuration: 0.3, delay: 0, options: UIView.AnimationOptions.curveEaseOut, animations: {
            alert.transform = CGAffineTransform.identity
        }) { (_) in
            UIView.animate(withDuration: 0.2, delay: 1, options: UIView.AnimationOptions.curveEaseIn, animations: {
                alert.transform = CGAffineTransform(translationX: 0, y: -60)
            }) { (_) in
                alert.removeFromSuperview()
            }
        }
    }
    

}

