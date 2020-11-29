# SwiftyScript

A MacOS app for running Swift scripts.
Enter your swift code in the editor window and click run. You will see the output of the script on the right output pane.


## Flow

These are the main classes in communication:
 1. Input processor
 2. File Handler
 3. ConsoleErrorHandler
 4. View Controller
 
 
 ### Input Processor:
 Response for taking the input from the editor pane and passing it to the File handler dependency. When file process is completed it returns the path of the created swift file.
 
 ### File Handler:
  This classe is response for creating a directory in the documents folder with a empty script.swift file. Every time we run a script, the text of the file is replaced.
  The directory creation runs only first time, after that the text is written to the file path. If sucess, this returns the absolute path. (Return type is needed in case, the swift file changes or we create a new swift file for every execution).
  
  ### View Controller:
   After the path is returned, the View Controller creates a child process with launching path of a shell script. The entire operation is dispatched onto a background queue(for long running scripts). To re-direct the output/error from the swift compilation process, Pipe is used to bridge the communication and observer is added for reading new stream data changes. 
   
   ### ConsoleOutputHandler
   
  The output and error pipe re-direct the logs to consoleoutput handler which adds formatting, Timestamp, Link for identification between Error / Standard outputs.
  The Errors are added a link attribute, which on clicking the links calls the completion handler. The call site (view Controller) gives a closure to handle the ErrorLocation path. Currently, it highlights the error line number.
  
