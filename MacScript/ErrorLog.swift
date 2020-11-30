//
//  ErrorLog.swift
//  MacScript
//
//  Created by VR on 30/11/20.
//  Copyright © 2020 VR. All rights reserved.
//

import Foundation

struct LogErrorLink {
    let line:Int
    let offset:Int
    let SEPARATOR:Character = ":"

    init?(with str:String) {
        let tuples = str.split(separator: SEPARATOR)
        if  tuples.count == 2, let line = Int(tuples[0]) , let offset = Int(tuples[1]) {
            self.line = line
            self.offset = offset
        }
        else{
            return nil
        }
    }

    var logTargetLocationStr:String {
        return "\(line).\(offset)"
    }
}
