//
//  ScriptRunner.swift
//  MacScript
//
//  Created by VR on 28/11/20.
//  Copyright © 2020 VR. All rights reserved.
//

import Foundation

final class ScriptRunner{
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




