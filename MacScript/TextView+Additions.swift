//
//  TextView+Additions.swift
//  MacScript
//
//  Created by VR on 29/11/20.
//  Copyright © 2020 VR. All rights reserved.
//

import Cocoa

public extension NSTextView {
     func clearText(){
        self.string = ""
    }
    
    func highlightLine(line lineNumberToHighlight: Int) {
        let layoutManager = self.layoutManager!
        var currentLine = 0
        let noOfGlyphs = layoutManager.numberOfGlyphs
        var range:NSRange = NSRange(location: 0, length: 0)
        var glyphIndex = 0
        
        for _ in stride(from: currentLine, to: noOfGlyphs, by: 1){
            layoutManager.lineFragmentRect(forGlyphAt: glyphIndex, effectiveRange: &range)
            
            if currentLine == lineNumberToHighlight {
                OperationQueue.main.addOperation {[weak self] in
                    self?.setSelectedRange(range)
                    self?.scrollRangeToVisible(range)
                }
                break
            }
            glyphIndex = NSMaxRange(range)
            currentLine += 1
        }
    }
}

