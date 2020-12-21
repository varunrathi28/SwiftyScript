//
//  String+NSRange.swift
//  MacScript
//
//  Created by VR on 30/11/20.
//  Copyright © 2020 VR. All rights reserved.
//

import Foundation
extension String {
    func substring(with nsrange: NSRange) -> Substring? {
        guard let range = Range(nsrange, in: self) else { return nil }
        return self[range]
    }
}
