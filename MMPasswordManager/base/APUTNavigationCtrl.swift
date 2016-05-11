//
//  APUTNavigationCtrl.swift
//  aputNavigationVIew
//
//  Created by miura on 2016/04/12.
//  Copyright © 2016年 miura. All rights reserved.
//

import Foundation
import UIKit

public enum APUTNavAnimationType {
    case kAnimationTypeSlideInOut;
    case kAnimationTypeDissolve;
    case kAnimationTypeSlideUpDown;
}

public class APUTNavigationCtrl : UIView {
    private var _animating:Bool = false;
    public var _viewControllers:NSMutableArray!;
    public weak var _parent:UIViewController?;
    
    
    required public init(coder: NSCoder) {
        super.init(coder: coder)!;
    }
    override init(frame: CGRect) {
        super.init(frame: frame);
    }
    
    deinit {
        for i in 0 ..< _viewControllers.count {
            let subView:UIView = _viewControllers.objectAtIndex(i) as! UIView;
            subView.removeFromSuperview();
        }
    }
    
    public func initializeView(vc:APUTNavigationSubViewBase, io:UIInterfaceOrientation) {
        _viewControllers = NSMutableArray.init(capacity: 1);
        
        vc._nav = self;
        _viewControllers.addObject(vc);
        self.addSubview(vc);
    }
    
    public func updateUILayout(io: UIInterfaceOrientation) {
        let dim = AppUtil.getViewDimension();
        self.frame = CGRectMake(0, 0, dim.width, dim.height);
        
        for i in 0 ..< _viewControllers.count {
            let subView:APUTNavigationSubViewBase = _viewControllers.objectAtIndex(i) as! APUTNavigationSubViewBase;
            subView.updateUILayout(io);
        }
    }
    
    public func getCurrentPageIndex() -> Int {
        return _viewControllers.count - 1;
    }
    
    public func pushView(vc:APUTNavigationSubViewBase, animationType:APUTNavAnimationType) {
        vc._nav = self;
        _viewControllers.addObject(vc);
        self.addSubview(vc);
        
        let cnt:Int = _viewControllers.count;
        if(cnt == 1) {return;}    //error
        
        let dim = AppUtil.getViewDimension();
        
        _animating = true;
        
        let vc1:UIView = _viewControllers.objectAtIndex(cnt - 2) as! UIView;        //現在表示中のvc
        let vc2:UIView = _viewControllers.objectAtIndex(cnt - 1) as! UIView;        //今追加したvc
        
        if(animationType == APUTNavAnimationType.kAnimationTypeSlideInOut){
            vc1.hidden = false;
            vc2.hidden = false;
            
            vc1.frame = CGRectMake(0, 0, dim.width, dim.height);
            vc2.frame = CGRectMake(dim.width, 0, dim.width, dim.height);
            
            UIView.animateWithDuration(
                0.3,
                animations: {() -> Void in
                    
                    vc1.frame = CGRectMake(-dim.width, 0, dim.width, dim.height);
                    vc2.frame = CGRectMake(0, 0, dim.width, dim.height);
                },
                completion: { (Bool) -> Void in
                    self.pushAnimationDidEnd();
                }
            );
        }else if(animationType == APUTNavAnimationType.kAnimationTypeDissolve){
            vc1.alpha = 1.0;
            vc2.alpha = 0.0;
            
            UIView.animateWithDuration(
                0.3,
                animations: {() -> Void in
                    vc1.alpha = 0.0;
                },
                completion: { (Bool) -> Void in
                    UIView.animateWithDuration(
                        0.3,
                        animations: {() -> Void in
                            vc2.alpha = 1.0;
                        },
                        completion: { (Bool) -> Void in
                            self.pushAnimationDidEnd();
                        }
                    );
                }
            );
        }else if(animationType == APUTNavAnimationType.kAnimationTypeSlideUpDown){
            vc1.hidden = false;
            vc2.hidden = false;
            
            vc1.frame = CGRectMake(0, 0, dim.width, dim.height);
            vc2.frame = CGRectMake(0, dim.height, dim.width, dim.height);
            
            UIView.animateWithDuration(
                0.3,
                animations: {() -> Void in
                    vc2.frame = CGRectMake(0, 0, dim.width, dim.height);
                },
                completion: { (Bool) -> Void in
                    self.pushAnimationDidEnd();
                }
            );
        }
    }
    
    public func pushAnimationDidEnd() {
        _animating = false;
        let cnt:Int = _viewControllers.count;
        let vc1:UIView = _viewControllers.objectAtIndex(cnt - 2) as! UIView;
        vc1.hidden = true;
        
        let vc2:APUTNavigationSubViewBase = _viewControllers.objectAtIndex(cnt - 1) as! APUTNavigationSubViewBase;
        vc2.pushAnimationDidEnd();
    }
    
    public func popCurrentView(animationType:APUTNavAnimationType) {
        let cnt:Int = _viewControllers.count;
        if(cnt <= 1) {return;}  //error
        
        let dim = AppUtil.getViewDimension();
        
        _animating = true;
        
        let vc1:UIView = _viewControllers.objectAtIndex(cnt - 1) as! UIView;        //現在表示中のvc
        let vc2:UIView = _viewControllers.objectAtIndex(cnt - 2) as! UIView;        //1個前のvc
        
        if(animationType == APUTNavAnimationType.kAnimationTypeSlideInOut){
            vc1.hidden = false;
            vc2.hidden = false;
            
            vc1.frame = CGRectMake(0, 0, dim.width, dim.height);
            vc2.frame = CGRectMake(-dim.width, 0, dim.width, dim.height);
            
            UIView.animateWithDuration(
                0.3,
                animations: {() -> Void in
                    
                    vc1.frame = CGRectMake(dim.width, 0, dim.width, dim.height);
                    vc2.frame = CGRectMake(0, 0, dim.width, dim.height);
                },
                completion: { (Bool) -> Void in
                    self.popAnimationDidEnd();
                }
            );
        }else if(animationType == APUTNavAnimationType.kAnimationTypeDissolve){
            vc1.alpha = 1.0;
            vc2.alpha = 0.0;
            
            UIView.animateWithDuration(
                0.3,
                animations: {() -> Void in
                    vc1.alpha = 0.0;
                },
                completion: { (Bool) -> Void in
                    UIView.animateWithDuration(
                        0.3,
                        animations: {() -> Void in
                            vc2.alpha = 1.0;
                        },
                        completion: { (Bool) -> Void in
                            self.popAnimationDidEnd();
                        }
                    );
                }
            );
        }else if(animationType == APUTNavAnimationType.kAnimationTypeSlideUpDown){
            vc1.hidden = false;
            vc2.hidden = false;
            
            vc1.frame = CGRectMake(0, 0, dim.width, dim.height);
            vc2.frame = CGRectMake(0, 0, dim.width, dim.height);
            
            UIView.animateWithDuration(
                0.3,
                animations: {() -> Void in
                    vc1.frame = CGRectMake(0, dim.height, dim.width, dim.height);
                },
                completion: { (Bool) -> Void in
                    self.popAnimationDidEnd();
                }
            );
        }
    }
    
    public func popAnimationDidEnd() {
        _animating = false;
        let cnt:Int = _viewControllers.count;
        let vc1:UIView = _viewControllers.objectAtIndex(cnt - 1) as! UIView;
        let vc2:APUTNavigationSubViewBase = _viewControllers.objectAtIndex(cnt - 2) as! APUTNavigationSubViewBase;
        
        vc2.hidden = false;
        vc2.popAnimationDidEnd();
        
        vc1.removeFromSuperview();
        _viewControllers.removeObjectAtIndex(cnt - 1);
    }
    
    
}
