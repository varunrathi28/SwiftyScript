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
    @IBOutlet var consoleView:ConsoleView!
    var inputProcessor = InputProcessor()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
         self.textView.lnv_setUpLineNumberView()
        //addTestView()
        
        // Do any additional setup after loading the view.
    }
    
    func addTestView(){
        
       
        let container = NSTextContainer()
        let frame = NSRect(x: 500, y: 300, width: 30, height: 30)
        let textview = ConsoleView(frame: frame, textContainer: container)
        textView.backgroundColor = .red
        consoleView.addSubview(textView)
    }
    
    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    
    @IBAction func runClicked(sender:NSButton) {
        let inputText = textView.textStorage?.string
        consoleView.addToLogs(inputText!)
        
     //   inputProcessor.processInput(input: inputText)
     //   highlightLine(line: 3)
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

    


