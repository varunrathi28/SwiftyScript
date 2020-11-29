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
    @IBOutlet var progressIndicator:NSProgressIndicator!
   // @IBOutlet var consoleView:ConsoleView!
    @IBOutlet var consoleTextView:NSTextView!
    var inputProcessor = InputProcessor()
    
    dynamic var isRunning = false
    var outputPipe:Pipe!
    var errorPipe:Pipe!
    var buildTask:Process!
    
    override func viewDidLoad() {
        super.viewDidLoad()
         self.textView.lnv_setUpLineNumberView()

        // Do any additional setup after loading the view.
    }

    
    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    func animateSpinner(_ shouldAnimate:Bool){
        DispatchQueue.main.async {
            if shouldAnimate {
                self.progressIndicator.startAnimation(self)
            }
            else{
                self.progressIndicator.stopAnimation(self)
            }
        }
    }
    
    @IBAction func runClicked(sender:NSButton) {
        let inputText = textView.textStorage?.string
        //consoleView.addToLogs(inputText!)
        
        let path = inputProcessor.processInput(input: inputText)
        animateSpinner(true)
        
        var arguments = [String]()
        arguments.append("swift")
        arguments.append(path)
        runScript(arguments)
        
     //   highlightLine(line: 3)
    }
    
    @IBAction func stopClicked(sender:NSButton){
        animateSpinner(false)
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
    

    func runScript(_ arguments:[String]) {
        
        //1.
        isRunning = true
        
        let taskQueue = DispatchQueue.global(qos: DispatchQoS.QoSClass.background)
        
        //2.
        taskQueue.async {
            
            //1.
            guard let path = Bundle.main.path(forResource: "SwiftScript",ofType:"command") else {
                print("Unable to locate SwiftScript.command")
                return
            }
            
            //2.
            self.buildTask = Process()
            self.buildTask.launchPath = path
            //self.buildTask.launchPath = "/usr/bin/env"
            self.buildTask.arguments = arguments
            
            //3.
            self.buildTask.terminationHandler = {
                
                task in
                DispatchQueue.main.async(execute: {
                   // self.buildButton.isEnabled = true
                    self.animateSpinner(false)
                    self.isRunning = false
                })
                
            }
            
            self.captureStandardOutputAndRouteToTextView(self.buildTask)
            
            //4.
            self.buildTask.launch()
            
            //5.
            self.buildTask.waitUntilExit()
            
        }
        
    }
    

    func captureStandardOutputAndRouteToTextView(_ task:Process) {
      
      //1.
      outputPipe = Pipe()
      errorPipe = Pipe()
      task.standardOutput = outputPipe
      task.standardError = errorPipe
      
      //2.
      outputPipe.fileHandleForReading.waitForDataInBackgroundAndNotify()
      errorPipe.fileHandleForReading.waitForDataInBackgroundAndNotify()
      
        NotificationCenter.default.addObserver(forName: NSNotification.Name.NSFileHandleDataAvailable, object: errorPipe.fileHandleForReading, queue: nil) {
            notification in
            
            let error = self.errorPipe.fileHandleForReading.availableData
            let errorString = String(data: error, encoding: String.Encoding.utf8) ?? ""
            
            DispatchQueue.main.async {
                let previousOutput = self.consoleTextView.string
                let nextOutput = previousOutput + "\n Error:" + errorString
                self.consoleTextView.string = nextOutput
                let range = NSRange(location:nextOutput.count,length:0)
                self.consoleTextView.scrollRangeToVisible(range)
            }
            
            self.errorPipe.fileHandleForReading.waitForDataInBackgroundAndNotify()
        }
        
      //3.
      NotificationCenter.default.addObserver(forName: NSNotification.Name.NSFileHandleDataAvailable, object: outputPipe.fileHandleForReading , queue: nil) {
        notification in
        
        //4.
        let output = self.outputPipe.fileHandleForReading.availableData
        let outputString = String(data: output, encoding: String.Encoding.utf8) ?? ""
        
        //5.
        DispatchQueue.main.async(execute: {
          let previousOutput = self.consoleTextView.string
          let nextOutput = previousOutput + "\n" + outputString
          self.consoleTextView.string = nextOutput
          
          let range = NSRange(location:nextOutput.count,length:0)
          self.consoleTextView.scrollRangeToVisible(range)
          
        })
        
        //6.
        self.outputPipe.fileHandleForReading.waitForDataInBackgroundAndNotify()
      }
    }
    
}

    


