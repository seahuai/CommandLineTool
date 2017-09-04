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
                let s4 = "/usr/local/bin/find.png"
                let s5 = "image.host"
                let s6 = "image.host.png"
                
                let exts = ["png"]
                
                try expect(s1.plainName(exts)) == "image"
                try expect(s2.plainName(exts)) == "image"
                try expect(s3.plainName(exts)) == "find"
                try expect(s4.plainName(exts)) == "find"
                try expect(s5.plainName(exts)) == "image.host"
                try expect(s6.plainName(exts)) == "image.host"
            }
        }
        
        $0.describe("String Searcher") {
            $0.it("Swift Searcher works") {
                let s1 = "UIImage(named: \"my_image\")"
                let s2 = "fasd asdhjdgf kjasd \"asd s\""
                let s3 = "let name = \"abc@2x.png\"/nlet image = UIImage(named: name)"
                
                let searcher = SwiftSearcher(extensions: ["png"])
                let result = [s1,s2,s3].map{ searcher.search(in: $0) }
                
                try expect(result[0]) == Set(["my_image"])
                try expect(result[1]) == Set(["asd s"])
                try expect(result[2]) == Set(["abc"])
                
            }}
        
        
        
    }
    
    
    
}
