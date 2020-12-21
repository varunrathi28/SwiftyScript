//
//  ConsoleOutputHandler.swift
//  MacScript
//
//  Created by VR on 26/11/20.
//  Copyright © 2020 VR. All rights reserved.
//

import Foundation
import Cocoa


struct ErrorLocation {
    let fullText:String
    let linkRange:NSRange
}

public class ConsoleOutputHandler:NSObject {
    
    weak var console:NSTextView?
    var clickCompletion:((LogErrorLink)->(Void))?
    
    init(_ textView:NSTextView ) {
        self.console = textView
        super.init()
        self.console?.delegate = self
    }
    
    /// Normal Output text appearance
    var textAppearance: [NSAttributedString.Key: Any] = {
            return [
                .font: NSFont(name: "Menlo", size: 12.0),
                .foregroundColor: NSColor.white
                ].compactMapValues({ $0 })
        }()
    
    /// Error formatting on Console
    var errorAppearance: [NSAttributedString.Key: Any] = {
        return [
            .font: NSFont(name: "Menlo", size: 13.0),
            .foregroundColor: NSColor.red
            ].compactMapValues({ $0 })
    }()
    
    /// Date formatter for adding timestamp handles on error logs.
    private lazy var dateFormatter: DateFormatter = {
           let formatter = DateFormatter()
           formatter.dateStyle = .none
           formatter.timeStyle = .medium
           return formatter
       }()
       
       private var currentTimeStamp: String {
            return dateFormatter.string(from: Date())
        }
   
    
    /**
     Process the text and adds formatting/ attibutes according to the type of log (Error/Standard Output)
     Adds attributed strings according to the log type with the appearance maps defined in the file.
     - Parameters:
     - text: actual text
     - Output type : Error/ Output
     - Color: Default color
     - Global: if log should be printed
     */
    
    public  func addToLogs(_ text: String,outputType: ConsoleLogType = .standardOutput, color: NSColor = .white, global: Bool = true) {
        
        guard text.count > 0  else { return }
        
        print("Log = : \(text)")
        let formattedText = NSMutableAttributedString(string: text)
        let textRange = NSRange(location: 0, length: formattedText.length)
        formattedText.addAttributes(textAppearance, range:textRange)
        
        if outputType == .standardError {
            formattedText.addAttributes(errorAppearance, range:textRange)
            formattedText.addAttribute(.foregroundColor, value: NSColor.red , range: textRange)
            
            /// Add error links for every error in the text. The multiple errors should be received in a single string separated by ''\n".
            if let errorLocations = getErrorLogTargetLink(from: formattedText.string) {
                for location in errorLocations {
                    formattedText.addAttribute(.link, value:location.fullText, range: location.linkRange)
                }
            }
        }
        else{
            formattedText.addAttributes(textAppearance, range:textRange)
            formattedText.addAttribute(.foregroundColor, value: color, range: textRange)
        }
        printLog(formattedText,global)
    }
    
    /**
     Formats the error logs with timestamp handles and adds them to the console.
     Also prints on the actual (Xcode) console, if log is generated globally.
     - Parameters:
     - text: the error text
     - isGlobal: If log should be printed on the Xcode Console.
        
     */
    
    public func printLog(_ text: NSAttributedString,_ isGlobal: Bool = true) {
       
        defer {
            if isGlobal {
                Swift.print(text.string)
            }
        }
        
        DispatchQueue.main.async {
            print("timestamping: \(text)")
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
    
    /**
     Takes the standard error from the pipe and returns the array of error info in the text.
     There could be multiple error combined in a single string, thus [ErrorLocation] is needed.
     The Error locations are only used for showing attributed string.
     - Parameter Error: The error Text from STD Error
     - Returns: The array of error locations containing the range of the string to be attributed as link
     */
    
    func getErrorLogTargetLink(from error:String) -> [ErrorLocation]? {
        let fileName = ScriptFileHandler.getFilePathURL().absoluteString
        let pattern = "\(fileName):[1-9]+:[1-9]+:"
        let regex = try! NSRegularExpression(pattern: pattern, options: .caseInsensitive)
        let range = NSRange(location: 0, length: error.utf16.count)
        let matches = regex.matches(in: error, options: [], range: range)
        return matches.compactMap { result  -> ErrorLocation? in
            if let matchString = (error.substring(with: result.range)) {
                return ErrorLocation(fullText:String(matchString) , linkRange: result.range)
            }
            return nil
        }
    }
    
    
}

extension ConsoleOutputHandler : NSTextViewDelegate {
    
    public func textView(_ textView: NSTextView, clickedOnLink link: Any, at charIndex: Int) -> Bool {
        if let targetLink = link as? String {
            if let range = targetLink.range(of: #"[0-9]+:[0-9]+"#, options: .regularExpression) {
                if let linkTargetInfo = LogErrorLink(with: targetLink.substring(with: range)) {
                    clickCompletion?(linkTargetInfo)
                }
            }

        }
        return true
    }
    
   
}
