//
//  FileHandler.swift
//  MacScript
//
//  Created by VR on 26/11/20.
//  Copyright © 2020 VR. All rights reserved.
//

import Foundation

final public class ScriptFileHandler: FileHanderInterface {

    static let fileName = "Script.swift"
    static let folderName = "MacScript"

   /**
       @output : retuns the tuple of status and file path
     */
   
    public static func getFilePathURL() -> URL {
           return getFolderPath().appendingPathComponent(fileName)
    }
    
    public func saveToFile(_ input:String?)-> (Bool,String?) {
        guard let input = input else { return (false, nil) }
        let folderPath = ScriptFileHandler.getFolderPath()
        checkAndCreateFileIfNotExists(at: folderPath, filename:ScriptFileHandler.fileName ,input)
        do {
            let filePath = ScriptFileHandler.getFilePathURL().absoluteString
            try input.write(toFile: filePath , atomically: true, encoding: .utf8)
            return (true, filePath)
        }
        catch{
            print("Error occured \(error.localizedDescription)")
            return (false, nil)
        }
    }
    
   private func checkAndCreateFileIfNotExists(at path:URL, filename:String,_ input:String){
        let filePathStr = path.absoluteString
        let fileManager = FileManager.default
                
        if !fileManager.fileExists(atPath: filePathStr) {
            do {
                _ = try fileManager.createDirectory(atPath: filePathStr, withIntermediateDirectories: true, attributes: nil)
                let fileFullPath = path.appendingPathComponent(ScriptFileHandler.fileName).absoluteString
                let status = fileManager.createFile(atPath: fileFullPath, contents: nil, attributes: nil)
                print("File Created: \(status)")
            }
            catch{
                print(error.localizedDescription)
            }
            
            
        }
    }
    
    //MARK:- Utility methods for  path URLs
    
    private static func getFolderPath() -> URL {
        return ScriptFileHandler.getDocumentsDirectory().appendingPathComponent(folderName)
    }
    
    private static func getDocumentsDirectory() -> URL {
       let paths =  NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        return URL(string: paths)!
    }
}
