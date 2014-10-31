//
//  LoadBridge.swift
//  Objective-C work around
//
//  Created by Lee Barney on 10/31/14.
//  Copyright (c) 2014 Lee Barney. All rights reserved.
//

import Foundation
import WebKit



@objc class SwiftlyBridge {
    
    class func buildURL(indexHTMLPath:String) ->NSURL{
        return NSURL(fileURLWithPath: indexHTMLPath)!
    }
}
