#!/usr/bin/swift

import Foundation

let filePath = " /Users/vr/Documents/Workspace/POC/JetBrains/Test.swift"

func shell(_ args: String...) -> Int32 {
    let task = Process()
    task.launchPath = "/bin/bash"
    task.arguments = ["-c"]
    task.arguments = task.arguments! + args
    task.launch()
    task.waitUntilExit()
    return task.terminationStatus
}

let output = shell("swift \(filePath)")
