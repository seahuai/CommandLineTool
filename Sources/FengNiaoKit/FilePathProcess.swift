//
//  FilePathProcess.swift
//  CommandLineTool
//
//  Created by 张思槐 on 2017/9/5.
//
//

import Foundation
import PathKit

class FilePathProcess{
    
    let process: Process
    
    init?(path: Path, extensions: [String], excluded: [Path]){
        self.process = Process()
        self.process.launchPath = "/usr/bin/find"
        
        guard !extensions.isEmpty else {
            return nil
        }
        
        var args = [String]()
        args.append(path.string)
        
        for (i, ext) in extensions.enumerated(){
            if i == 0{
                args.append("(")
            }else{
                args.append("-or")
            }
            args.append("-name")
            args.append("*.\(ext)")
            
            if i == extensions.count - 1{
                args.append(")")
            }
        }
        
        for excludedPath in excluded{
            args.append("-not")
            args.append("-path")
            
            let filePath = path + excludedPath
            guard filePath.exists else { continue }
            
            if filePath.isDirectory{
                args.append("\(filePath.string)/*")
            }else{
                args.append(filePath.string)
            }
        }
        
        process.arguments = args
        
    }
    
    
    convenience init?(path: String, extensions: [String], excluded: [String]){
        self.init(path: Path(path), extensions: extensions, excluded: excluded.map{ Path($0) })
    }
    
    func excute() -> Set<String>{
        let pipe = Pipe()
        process.standardOutput = pipe
        
        let fileHandler = pipe.fileHandleForReading
        process.launch()
        
        let data = fileHandler.readDataToEndOfFile()
        if let string = String(data: data, encoding: .utf8) {
            return Set(string.components(separatedBy: "\n").dropLast())
        }else {
            return []
        }
    }
    
    
    
}
