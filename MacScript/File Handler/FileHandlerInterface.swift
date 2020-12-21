//
//  FileHandlerInterface.swift
//  MacScript
//
//  Created by VR on 21/12/20.
//  Copyright © 2020 VR. All rights reserved.
//

import Foundation

/// Bool = Status of file Operation, String? = Path of the file stored
public typealias FileHandleResult = (Bool,String?)

/**
   Abstract representation for File Handlers
 */
public  protocol FileHanderInterface {
    func saveToFile(_ input:String?) -> FileHandleResult
    static func getFilePathURL()->URL
}
