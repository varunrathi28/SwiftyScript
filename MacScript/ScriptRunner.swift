//
//  ScriptRunner.swift
//  MacScript
//
//  Created by VR on 28/11/20.
//  Copyright © 2020 VR. All rights reserved.
//

import Foundation

final class ScriptRunner{
    
    var buildTask:Process!
    var outputPipe:Pipe!
    static let scriptName = ""
    static let scriptExtension = ""
    
    
    func runScript(_ arguments:[String]) {
        
        let taskQueue = DispatchQueue.global(qos: DispatchQoS.QoSClass.background)
        taskQueue.async {
            
            guard let path = Bundle.main.path(forResource: ScriptRunner.scriptName,ofType:ScriptRunner.scriptExtension) else {
              print("Unable to locate Script command")
              return
            }
           
            self.buildTask = Process()
            self.buildTask.launchPath = path
            self.buildTask.arguments = arguments
            
            
        }
    }
    
    func captureStandardOutputAndRouteToTextView(_ task:Process) {
        outputPipe = Pipe()
        task.standardOutput = outputPipe
        outputPipe.fileHandleForReading.waitForDataInBackgroundAndNotify()
    }
    
    
    
    
    func shell(_ args: String...) -> (Int32, String?) {
        let task = Process() 
        task.launchPath = "/bin/bash"
        task.arguments = ["-c"]
        task.arguments = task.arguments! + args
        let pipe = Pipe()
        task.standardError = pipe
        task.launch()
        task.waitUntilExit()
        let handle = pipe.fileHandleForReading
        let data = handle.readDataToEndOfFile()
        let outputStr:String? = String(data: data, encoding: .utf8)
        return (task.terminationStatus,outputStr)
    }
    
   
    
}




