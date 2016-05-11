//
//  APUTNotificationReceiverView.swift
//  aputNavigationVIew
//
//  Created by miura on 2016/04/12.
//  Copyright © 2016年 miura. All rights reserved.
//

import Foundation
import UIKit

public class APUTNotificationReceiverView : UIView {
    public var _observing:Bool = false;
    public var _observing_inactive_active:Bool = false;
    
    required public init(coder: NSCoder) {
        super.init(coder: coder)!
    }
    override init(frame: CGRect) {
        super.init(frame: frame);
    }
    
    public func startKeyboardObserving() {
        if(!_observing) {
            let notificationCenter:NSNotificationCenter = NSNotificationCenter.defaultCenter();
            notificationCenter.addObserver(self, selector:#selector(keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil);
            notificationCenter.addObserver(self, selector:#selector(keybaordWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil);
            
            _observing = true;
        }
    }
    
    public func stopKeyboardObserving() {
        if(_observing) {
            let notificationCenter:NSNotificationCenter = NSNotificationCenter.defaultCenter();
            notificationCenter.removeObserver(self, name: UIKeyboardWillShowNotification, object: nil);
            notificationCenter.removeObserver(self, name: UIKeyboardWillHideNotification, object: nil);
            
            _observing = false;
        }
    }
    
    public func startAppActiveObserving() {
        if(!_observing_inactive_active) {
            let notificationCenter:NSNotificationCenter = NSNotificationCenter.defaultCenter();
            notificationCenter.addObserver(self, selector:#selector(applicationBecomeInactive(_:)), name: UIApplicationDidEnterBackgroundNotification, object: nil);
            notificationCenter.addObserver(self, selector:#selector(applicationBecomeActive(_:)), name: UIApplicationDidBecomeActiveNotification, object: nil);
            
            _observing_inactive_active = true;
        }
    }
    
    public func stopAppActiveObserving() {
        if(_observing_inactive_active) {
            let notificationCenter:NSNotificationCenter = NSNotificationCenter.defaultCenter();
            notificationCenter.removeObserver(self, name: UIApplicationDidEnterBackgroundNotification, object: nil);
            notificationCenter.removeObserver(self, name: UIApplicationDidBecomeActiveNotification, object: nil);
            
            _observing_inactive_active = false;
        }
    }
    
    deinit {
        stopKeyboardObserving();
        stopAppActiveObserving();
    }
    
    //MARK: keyboard norification
    func keyboardWillShow(notification: NSNotification?) {
            //here, do nothing
    }
    
    func keybaordWillHide(notification: NSNotification?) {
        //here, do nothing
    }
    
    func applicationBecomeInactive(notification: NSNotification?) {
        //here, do nothing
    }
    
    func applicationBecomeActive(notification: NSNotification?) {
        //here, do nothing
    }
}
