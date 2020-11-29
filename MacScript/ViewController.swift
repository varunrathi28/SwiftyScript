//
//  ViewController.swift
//  MacScript
//
//  Created by VR on 26/11/20.
//  Copyright © 2020 VR. All rights reserved.
//

import Cocoa

//States of represent Editor config
enum EditorCurrentState {
    case running, stopped
}

class ViewController: NSViewController {
    @IBOutlet var textView:NSTextView!
    @IBOutlet var progressIndicator:NSProgressIndicator!
    @IBOutlet var clearButton:NSButton!
    @IBOutlet var btnRun:NSButton!
    @IBOutlet var btnStop:NSButton!
    @IBOutlet var consoleTextView:NSTextView!
    var consoleErrorHandler:ConsoleOutputHandler! // For handling log data and formatting
    var inputProcessor = InputProcessor() // For file Process and hanlding
    
    var isRunning = false {
        didSet {
            if self.isRunning {
                changeUIState(for: .running)
            }
            else{
                changeUIState(for: .stopped)
            }
        }
    }
    
    // Var for launching script
    var outputPipe:Pipe!
    var errorPipe:Pipe!
    var buildTask:Process!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTextViewComponents()
        // Do any additional setup after loading the view.
    }
    
    
    func setupTextViewComponents() {
        self.consoleTextView.isEditable = false
        self.textView.lnv_setUpLineNumberView()
        changeUIState(for: .stopped)
        self.consoleErrorHandler = ConsoleOutputHandler(consoleTextView)
        self.consoleErrorHandler.clickCompletion = { [weak self] targetLink in
            guard let self = self else { return }
            self.textView.highlightLine(line: targetLink.line - 1)
        }
        
    }
    
    //MARK:- Actions
    
    @IBAction func runClicked(sender:NSButton) {
        
        guard isRunning == false else {
            return
        }
        
        isRunning = true
        consoleTextView.clearText()
        let inputText = textView.textStorage?.string
        //consoleView.addToLogs(inputText!)
        let path = inputProcessor.processInput(input: inputText)
        var arguments = [String]()
        arguments.append(path)
        runScript(arguments)
    }
    
    @IBAction func stopClicked(sender:NSButton){
        guard isRunning else{ return }
        isRunning = false
        stopBuildProcess()
    }
    
    @IBAction func clearClicked(sender: NSButton){
        consoleTextView.clearText()
    }
    
    
    //MARK:- UI Utility methods
    
    private func animateSpinner(_ shouldAnimate:Bool){
        DispatchQueue.main.async {
            if shouldAnimate {
                self.progressIndicator.isHidden = false
                self.progressIndicator.startAnimation(self)
            }
            else{
                self.progressIndicator.isHidden = true
                self.progressIndicator.stopAnimation(self)
            }
        }
    }
    
    private func changeUIState(for state:EditorCurrentState){
        switch state {
        case .running:
            btnRun.isEnabled = false
            btnStop.isEnabled = true
            animateSpinner(true)
        case .stopped:
            animateSpinner(false)
            btnRun.isEnabled = true
            btnStop.isEnabled = false
        }
    }
    
    // Methods for Child process management
    //1. The script is run as a child process and standard output, error are captured using Pipe
    
    func stopBuildProcess() {
        self.buildTask.terminate()
    }

    func runScript(_ arguments:[String]) {

        isRunning = true
        // 1. Background queue for performing long running tasks
        let taskQueue = DispatchQueue.global(qos: DispatchQoS.QoSClass.background)
        
        taskQueue.async {
            // Find the path of the Shell Script from the bundle
            guard let path = Bundle.main.path(forResource: "SwiftScript",ofType:"command") else {
                print("Unable to locate SwiftScript.command")
                return
            }
            
            // 2. Configure the process with arguments and script launch path
            self.buildTask = Process()
            self.buildTask.launchPath = path
            //self.buildTask.launchPath = "/usr/bin/env"
            self.buildTask.arguments = arguments
            self.buildTask.terminationHandler = {
                
                task in
                DispatchQueue.main.async(execute: {
                   // self.buildButton.isEnabled = true
                    self.isRunning = false
                   print("Process returned : \(self.buildTask.terminationStatus)")
                })
                
            }
            
            // Pipe the Std Error and Output : for displaying on textview
            self.captureStandardOutputAndRouteToTextView(self.buildTask)
            self.buildTask.launch()
            self.buildTask.waitUntilExit()
            
        }
        
    }


    func captureStandardOutputAndRouteToTextView(_ task:Process) {
        
        // Initialize the pipe
        outputPipe = Pipe()
        errorPipe = Pipe()
        task.standardOutput = outputPipe
        task.standardError = errorPipe
        
        // Open stream for reading changes
        outputPipe.fileHandleForReading.waitForDataInBackgroundAndNotify()
        errorPipe.fileHandleForReading.waitForDataInBackgroundAndNotify()
        
        // Observer for STD ERRor
        NotificationCenter.default.addObserver(forName: NSNotification.Name.NSFileHandleDataAvailable, object: errorPipe.fileHandleForReading, queue: nil) {
            notification in
            
            let error = self.errorPipe.fileHandleForReading.availableData
            let errorString = String(data: error, encoding: String.Encoding.utf8) ?? ""
            
            self.consoleErrorHandler.addToLogs(errorString, outputType: .standardError, color: .red, global: true)
            self.errorPipe.fileHandleForReading.waitForDataInBackgroundAndNotify()
        }
        
        //Observer for STD Output
        NotificationCenter.default.addObserver(forName: NSNotification.Name.NSFileHandleDataAvailable, object: outputPipe.fileHandleForReading , queue: nil) {
            notification in
            // Parse and add to console logs
            let output = self.outputPipe.fileHandleForReading.availableData
            let outputString = String(data: output, encoding: String.Encoding.utf8) ?? ""
            self.consoleErrorHandler.addToLogs(outputString, outputType: .standardOutput, color: .green, global: true)
            self.outputPipe.fileHandleForReading.waitForDataInBackgroundAndNotify()
        }
    }
    
}

    


