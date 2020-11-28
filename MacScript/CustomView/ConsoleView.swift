//
//  ConsoleView.swift
//  MacScript
//
//  Created by VR on 29/11/20.
//  Copyright © 2020 VR. All rights reserved.
//

import Foundation
import Cocoa

class ConsoleView: NSTextView {
    
}


extension NSAttributedString {
    public class func breakLine() -> NSAttributedString {
        return NSAttributedString(string: "\n")
    }
    
}
