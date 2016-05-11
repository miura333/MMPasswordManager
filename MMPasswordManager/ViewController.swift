//
//  ViewController.swift
//  MMPasswordManager
//
//  Created by miura on 2016/04/22.
//  Copyright © 2016年 miura. All rights reserved.
//

import UIKit
import LocalAuthentication

class ViewController: UIViewController {
    var _nav:APUTNavigationCtrl!;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let dim = AppUtil.getViewDimension();
        let view1:MMPMMainView = MMPMMainView(frame: CGRectMake(0, 0, dim.width, dim.height));
        
        _nav = APUTNavigationCtrl(frame: CGRectMake(0, 0, dim.width, dim.height));
        _nav.initializeView(view1, io: UIInterfaceOrientation.Portrait);
        
        self.view.addSubview(_nav);
        
        let defaults:NSUserDefaults = NSUserDefaults.standardUserDefaults();
        defaults.addObserver(self, forKeyPath: MMPMKvoNotification.applicationWillEnterForeground, options: NSKeyValueObservingOptions.New, context: nil);
        
        self.checkWithTouchID();
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        let defaults:NSUserDefaults = NSUserDefaults.standardUserDefaults();
        defaults.removeObserver(self, forKeyPath: MMPMKvoNotification.applicationWillEnterForeground, context: nil);
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        
//        print(keyPath) // Optional("prop")
//        print(object) // Optional(<MyApp.MyClass: 0x7fdad1c013d0>)
//        print(change) // Optional(["old": 0, "new": 10, "kind": 1])
        
        let defaults:NSUserDefaults = NSUserDefaults.standardUserDefaults();
        
        if(keyPath == MMPMKvoNotification.applicationWillEnterForeground) {
            let value:String = defaults.objectForKey(MMPMKvoNotification.applicationWillEnterForeground) as! String;
            if(value != "1") {
                return;
            }
            defaults.setObject("0", forKey: MMPMKvoNotification.applicationWillEnterForeground);
            
            self.checkWithTouchID();
        }
    }
    
    func checkWithTouchID() {
        //_nav.hidden = true;
        
        let context:LAContext = LAContext();
        var error:NSError?;
        
        if(context.canEvaluatePolicy(LAPolicy.DeviceOwnerAuthenticationWithBiometrics, error: &error)) {
            context.evaluatePolicy(
                LAPolicy.DeviceOwnerAuthenticationWithBiometrics,
                localizedReason:"Authentication",
                reply: {
                    success, error in
                    if (success) {
                        // 指紋認証成功
                        NSLog("Success");
                        
                        dispatch_async(dispatch_get_main_queue(), {
                            // Main Thread
                            self._nav.hidden = false;
                        });
                    } else {
                        // 指紋認証失敗
                        NSLog("Error");
                        
                        dispatch_async(dispatch_get_main_queue(), {
                            // Main Thread
                            self._nav.hidden = true;
                            });
                    }
            });
        }else{
            _nav.hidden = false;
        }
    }
}

