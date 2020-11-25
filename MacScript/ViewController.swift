//
//  ViewController.swift
//  MacScript
//
//  Created by VR on 26/11/20.
//  Copyright © 2020 VR. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
    @IBOutlet var textView:NSTextView!
    var fileHandle = FileHandler()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    
    @IBAction func runClicked(sender:NSButton) {
        let inputText = textView.textStorage?.string
        fileHandle.saveTextToFile(inputText)
      //  highlightLine(line: 0)
    }
    

    func highlightLine(line lineNumberToHighlight: Int) {
        let layoutManager = self.textView.layoutManager!
        var currentLine = 0
        let noOfGlyphs = layoutManager.numberOfGlyphs
        var range:NSRange = NSRange(location: 0, length: 0)
        var glyphIndex = 0
        
        for _ in stride(from: currentLine, to: noOfGlyphs, by: 1){
            layoutManager.lineFragmentRect(forGlyphAt: glyphIndex, effectiveRange: &range)
            
            if currentLine == lineNumberToHighlight {
                OperationQueue.main.addOperation {[weak self] in
                    self?.textView.setSelectedRange(range)
                    self?.textView.scrollRangeToVisible(range)
                    
                }
                break
            }
            glyphIndex = NSMaxRange(range)
            currentLine += 1
        }
    }
    
}

    


