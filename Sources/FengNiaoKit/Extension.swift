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
    
    var plainName: String{
        let p = Path(self.lowercased())
        var result = p.lastComponentWithoutExtension
        if result.hasSuffix("@2x") || result.hasSuffix("@3x"){
            result = String(describing: result.utf16.dropLast(3))
        }
        return result
    }
}
