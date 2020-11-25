//
//  ViewController.swift
//  MacScript
//
//  Created by VR on 26/11/20.
//  Copyright © 2020 VR. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
    
    @IBOutlet var textView:NSTextView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    
    @IBAction func runClicked(sender:NSButton) {
        let input = textView.textStorage?.string
        print(input!)
    }


}

