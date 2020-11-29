//
//  FileHandler.swift
//  MacScript
//
//  Created by VR on 26/11/20.
//  Copyright © 2020 VR. All rights reserved.
//

import Foundation

final public class FileHandler: NSObject {
    let fileName = "Script.swift"
    let folderName = "MacScript"

   
   /**
       @output : retuns the tuple of status and file path
     */
   public func saveTextToFile(_ input:String?)-> (Bool,String?) {
        guard let input = input else { return (false, nil) }
        let folderPath = getFolderPath()
        checkAndCreateFileIfNotExists(at: folderPath, filename: fileName ,input)
        do {
           let filePath = getFilePathURL().absoluteString
           try input.write(toFile: filePath , atomically: true, encoding: .utf8)
            return (true, filePath)
        }
        catch{
            print("Error occured \(error.localizedDescription)")
            return (false, nil)
        }
    }
    
    func checkAndCreateFileIfNotExists(at path:URL, filename:String,_ input:String){
        let filePathStr = path.absoluteString
        let fileManager = FileManager.default
                
        if !fileManager.fileExists(atPath: filePathStr) {
            do {
                _ = try fileManager.createDirectory(atPath: filePathStr, withIntermediateDirectories: true, attributes: nil)
                let fileFullPath = path.appendingPathComponent(fileName).absoluteString
                let status = fileManager.createFile(atPath: fileFullPath, contents: nil, attributes: nil)
                print("File Created: \(status)")
            }
            catch{
                print(error.localizedDescription)
            }
            
            
        }
    }
    
    //MARK:- Utility methods for  path URLs
    
    private func getFolderPath() -> URL {
        return getDocumentsDirectory().appendingPathComponent(folderName)
    }
    
    private func getDocumentsDirectory() -> URL {
       let paths =  NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
      //  let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return URL(string: paths)!
    }
    
    private func getFilePathURL() -> URL {
        return getFolderPath().appendingPathComponent(fileName)
    }
}
