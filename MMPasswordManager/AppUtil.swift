//
//  AppUtil.swift
//  aputNavigationVIew
//
//  Created by miura on 2016/04/12.
//  Copyright © 2016年 miura. All rights reserved.
//

import Foundation
import UIKit

struct AppUtil {
    static func getViewDimension() -> (width:CGFloat, height:CGFloat) {
        let size:CGSize = UIScreen.mainScreen().bounds.size;
        return (size.width, size.height);
    }
    
    static func RGB(r:CGFloat, g:CGFloat, b:CGFloat) -> (UIColor) {
        return UIColor(red: r/255, green: g/255, blue: b/255, alpha: 1.0);
    }
    
    static func getMMPMHeaderGrayColor() -> (UIColor) {
        return self.RGB(247, g: 247, b: 247);
    }
    
    static func getMMPMHeaderBorderColor() -> (UIColor) {
        return self.RGB(96, g: 96, b: 96);
    }
}
