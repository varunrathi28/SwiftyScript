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
     var textAppearance: [NSAttributedString.Key: Any] = {
        return [
            .font: NSFont(name: "Menlo", size: 12.0),
            .foregroundColor: NSColor.white
            ].compactMapValues({ $0 })
    }()
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        self.backgroundColor = .white
    }
    
    override init(frame frameRect: NSRect, textContainer container: NSTextContainer?) {
        super.init(frame: frameRect, textContainer: container)
    }
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .medium
        return formatter
    }()
    
    private var currentTimeStamp: String {
         return dateFormatter.string(from: Date())
     }
    
    let console: NSTextView = {
           let textView = NSTextView()
           textView.backgroundColor = .black
           textView.isEditable = false
         
            return textView
       }()
    
    
}


extension NSAttributedString {
    public class func breakLine() -> NSAttributedString {
        return NSAttributedString(string: "\n")
    }
    
}
