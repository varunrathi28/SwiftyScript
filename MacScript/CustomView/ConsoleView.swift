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
    
    public  func addToLogs(_ text: String, color: NSColor = .white, global: Bool = true) {
        let formattedText = NSMutableAttributedString(string: text)
        let textRange = NSRange(location: 0, length: formattedText.length)
        formattedText.addAttributes(textAppearance, range:textRange)
        formattedText.addAttribute(.foregroundColor, value: color, range: textRange)
        print(formattedText, global: global)
    }
    
    public func print(_ text: NSAttributedString, global: Bool = true) {
        
        defer {
            if global {
                Swift.print(text.string)
            }
        }
        
        DispatchQueue.main.async {
            let timeStamped = NSMutableAttributedString(string: "\(self.currentTimeStamp) ")
            let range = NSRange(location: 0, length: timeStamped.length)
            timeStamped.addAttributes(self.textAppearance, range: range)
            timeStamped.append(text)
            timeStamped.append(NSAttributedString.breakLine())
            
            // Add new log to the existing logs
            self.textStorage?.append(timeStamped)
            self.scrollToBottom()
            
        }
    }
    
    public  func clear() {
           DispatchQueue.main.async {
            //FIXME:- find way to clear text
               self.scrollToBottom()
           }
       }
    
    public  func scrollToBottom() {
        guard let container = self.textContainer else { return }
        self.layoutManager?.ensureLayout(for: container)
        let offset = CGPoint(x: 0, y: (container.containerSize.height - self.frame.size.height))
        self.scroll(offset)
       }
}


extension NSAttributedString {
    public class func breakLine() -> NSAttributedString {
        return NSAttributedString(string: "\n")
    }
    
}
