//
//  ConsoleOutputHandler.swift
//  MacScript
//
//  Created by VR on 26/11/20.
//  Copyright © 2020 VR. All rights reserved.
//

import Foundation
import Cocoa

public class ConsoleOutputHandler:NSObject {
    
    weak var console:NSTextView?
    var clickCompletion:((LogErrorLink)->(Void))?
    
    init(_ textView:NSTextView ) {
        self.console = textView
        super.init()
        self.console?.delegate = self
    }
    
    var textAppearance: [NSAttributedString.Key: Any] = {
            return [
                .font: NSFont(name: "Menlo", size: 12.0),
                .foregroundColor: NSColor.white
                ].compactMapValues({ $0 })
        }()
    var errorAppearance: [NSAttributedString.Key: Any] = {
        return [
            .font: NSFont(name: "Menlo", size: 13.0),
            .foregroundColor: NSColor.red
            ].compactMapValues({ $0 })
    }()
    
    private lazy var dateFormatter: DateFormatter = {
           let formatter = DateFormatter()
           formatter.dateStyle = .none
           formatter.timeStyle = .medium
           return formatter
       }()
       
       private var currentTimeStamp: String {
            return dateFormatter.string(from: Date())
        }
       
    public  func addToLogs(_ text: String,outputType: ConsoleLogType = .standardOutput, color: NSColor = .white, global: Bool = true) {
        let formattedText = NSMutableAttributedString(string: text)
        let textRange = NSRange(location: 0, length: formattedText.length)
        formattedText.addAttributes(textAppearance, range:textRange)
        
        if outputType == .standardError {
            formattedText.addAttributes(errorAppearance, range:textRange)
            formattedText.addAttribute(.foregroundColor, value: NSColor.red , range: textRange)
            if let errorTarget = getErrorLogTargetLink(from: formattedText.string) {
                formattedText.addAttribute(.link, value:errorTarget, range: textRange)
            }
            
            
        }
        else{
            formattedText.addAttributes(textAppearance, range:textRange)
            formattedText.addAttribute(.foregroundColor, value: color, range: textRange)
        }
        printLog(formattedText, global: global)
    }
    
    public func printLog(_ text: NSAttributedString, global: Bool = true) {
        
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
            
            self.console?.textStorage?.append(timeStamped)
            //self.scrollToBottom()
            
        }
    }
    
    func getErrorLogTargetLink(from error:String) -> LogErrorLink? {
        if let range = error.range(of: #":[0-9]*:[0-9]*:"#,
                                   options: .regularExpression) {
            let text = error.substring(with: range)
            print("error parsed: \(text) \(range)")
            return LogErrorLink(with: text)
            }
    
        return nil
    }
}

extension ConsoleOutputHandler : NSTextViewDelegate {
    
    public func textView(_ textView: NSTextView, clickedOnLink link: Any, at charIndex: Int) -> Bool {
        if let targetLink = link as? LogErrorLink {
           clickCompletion?(targetLink)
        }
        return true
    }
    
   
}
