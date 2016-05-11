//
//  APUTNavigationSubViewBase.swift
//  aputNavigationVIew
//
//  Created by miura on 2016/04/12.
//  Copyright © 2016年 miura. All rights reserved.
//

import Foundation
import UIKit

public class APUTNavigationSubViewBase : APUTNotificationReceiverView {
    public weak var _nav:APUTNavigationCtrl?;
    
    required public init(coder: NSCoder) {
        super.init(coder: coder);
    }
    override init(frame: CGRect) {
        super.init(frame: frame);
    }
    
    public func updateUILayout(io:UIInterfaceOrientation) {
        //here do nothing
    }
    
    public func popAnimationDidEnd() {
        //here do nothing
    }
    
    public func pushAnimationDidEnd() {
        //here do nothing
    }
    
}
