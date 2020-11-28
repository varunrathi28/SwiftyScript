//
//  AttributedString.swift
//  MacScript
//
//  Created by VR on 29/11/20.
//  Copyright © 2020 VR. All rights reserved.
//

import Foundation
public  extension NSAttributedString {
    public class func breakLine() -> NSAttributedString {
        return NSAttributedString(string: "\n")
    }
    
    var range: NSRange {
        return NSRange(location: 0, length: length)
    }
}
