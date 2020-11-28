//
//  InputProcessor.swift
//  MacScript
//
//  Created by VR on 28/11/20.
//  Copyright © 2020 VR. All rights reserved.
//

import Foundation
typealias FileOperationResult = (Bool, String?)

class InputProcessor {
    // dependencies
    private let fileHandler = FileHandler()
    private let scriptRunner = ScriptRunner()
    

    public func processInput(input:String?){
        let operationResult = fileHandler.saveTextToFile(input)
        if operationResult.0 == true , let fileDirectoryPath = operationResult.1 {
          let scriptResult = scriptRunner.shell("swift \(fileDirectoryPath)")
           print(scriptResult)
        }
    }
}
