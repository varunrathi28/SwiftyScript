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
    private let fileHandler = FileHandler()
    private let scriptRunner = ScriptRunner()
    

    // Returns the .swift file path if file operation is successfull.
    public func processInput(input:String?) ->String{
        let operationResult = fileHandler.saveTextToFile(input)
        if operationResult.0 == true , let fileDirectoryPath = operationResult.1 {
            return fileDirectoryPath
         // let scriptResult = scriptRunner.shell("swift \(fileDirectoryPath)")
        //   print(scriptResult)
        }
        return ""
    }
}
