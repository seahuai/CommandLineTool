import Foundation
import Spectre
@testable import FengNiaoKit

public func specFengNiaoKit() {
    
    // 创建测试上下文
    describe("FengNiaoKit") {
        
        $0.before {
            // 初始化测试之前的工作
        }
        
        
        $0.after {
            // 测试结束后的工作
        }
        
        $0.describe("String Extension") {
            $0.it("should return plain name") {
                let s1 = "image@2x.png"
                let s2 = "image@3X.png"
                let s3 = "/usr/local/bin/find"
                let s4 = "/usr/local/bin/find.jpg"
                
                try expect(s1.plainName) == "image"
                try expect(s2.plainName) == "image"
                try expect(s3.plainName) == "find"
                try expect(s4.plainName) == "find"
            }
        }
    }
    
    
}
