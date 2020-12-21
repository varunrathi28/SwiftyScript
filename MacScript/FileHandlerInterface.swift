//
//  FileHandlerInterface.swift
//  MacScript
//
//  Created by VR on 21/12/20.
//  Copyright © 2020 VR. All rights reserved.
//

import Foundation

public typealias FileHandleResult = (Bool,String?)

public  protocol FileHanderInterface {
    func saveToFile(_ input:String?) -> FileHandleResult
    static func getFilePathURL()->URL
}
