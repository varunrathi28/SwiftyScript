//
//  InputProcessor.swift
//  MacScript
//
//  Created by VR on 28/11/20.
//  Copyright © 2020 VR. All rights reserved.
//

import Foundation

class InputProcessor {
    // dependencies
    private let fileHandler:FileHanderInterface
   // private let scriptRunner = ScriptRunner()
    
    init(_ fileHandller: FileHanderInterface) {
        self.fileHandler = fileHandller
    }
    
    // Returns the .swift file path if file operation is successfull.
    public func processInput(input:String?) ->String{
        let operationResult = fileHandler.saveToFile(input)
        if operationResult.0 == true , let fileDirectoryPath = operationResult.1 {
            return fileDirectoryPath
         // let scriptResult = scriptRunner.shell("swift \(fileDirectoryPath)")
        //   print(scriptResult)
        }
        return ""
    }
}
