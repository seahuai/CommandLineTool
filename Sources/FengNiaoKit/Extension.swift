//
//  Extension.swift
//  CommandLineTool
//
//  Created by 张思槐 on 2017/9/4.
//
//

import Foundation
import PathKit

extension String{
    var fullRange: NSRange{
        let length = utf16.count
        return NSMakeRange(0, length)
    }
    
    func plainName(_ extensions: [String]) -> String{
        let p = Path(self.lowercased())
        let result: String
        if let ext = p.extension, extensions.contains(ext){
            result = p.lastComponentWithoutExtension
        }else{
            result = p.lastComponent
        }
        
        var r = result
        if r.hasSuffix("@2x") || r.hasSuffix("@3x"){
            r = String(describing: r.utf16.dropLast(3))
        }
        return r
    }
    
}
