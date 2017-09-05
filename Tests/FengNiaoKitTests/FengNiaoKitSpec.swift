import Foundation
import Spectre
@testable import FengNiaoKit
import PathKit

public func specFengNiaoKit() {
    
    let fixturePath = Path(#file).parent().parent() + "Fixtures"
    
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
    
    
    describe("FilePathProcess") {
        $0.it("should get correct files' path") {
            let projectPath = fixturePath + "FindProcess"
            let process = FilePathProcess(path: projectPath.string, extensions: ["swift"], excluded: [])
            let result = process?.excute()
            let expected = Set(["Folder1/ignore_ext.swift"].map { (projectPath + $0).string })
            try expect(result) == expected
        }
        
        $0.it("should get correct files' path with excluded path") {
            let projectPath = fixturePath + "FindProcess"
            let process = FilePathProcess(path: projectPath.string, extensions: ["png", "jpg"], excluded: ["Folder1/Ignore"])
            let result = process?.excute()
            let expected = Set(["file1.png", "Folder1/file2.png", "Folder1/SubFolder/file3.jpg", "Folder2/file4.jpg", "Folder2/ignore_file.jpg"].map { (projectPath + $0).string })
            try expect(result) == expected
        }
    }
    
    describe("FengNiaoKit"){
        
        $0.describe("FengNiao Resource Searcher") {
            $0.it("should search resources in a simeple project") {
                let project = fixturePath + "SimpleResource"
                let fengniao = FengNiao(projectPath: project.string,
                                        excludePaths: [],
                                        resourceExtensions: ["png", "jpg", "imageset"],
                                        fileExtensions: [])
                let result = fengniao.resourcesInUse()
                let expected: [String: Set<String>] = [
                    "file1": [(project + "file1.png").string],
                    "file2": [(project + "file2.jpg").string],
                    "images": [(project + "images.imageset").string]
                ]
                try expect(result) == expected
            }
            
            $0.it("should properly skip resource in bundle") {
                let project = fixturePath + "ResourcesInBundle"
                let fengniao = FengNiao(projectPath: project.string,
                                        excludePaths: ["Ignore"],
                                        resourceExtensions: ["png", "jpg", "imageset"],
                                        fileExtensions: [])
                let result = fengniao.resourcesInUse()
                let expected: [String: Set<String>] = [
                    "normal": [(project + "normal.png").string],
                    "image": [(project + "Assets.xcassets/image.imageset").string]
                ]
                try expect(result) == expected
            }
            
            $0.it("should not skip same files with difference scale suffix") {
                let project = fixturePath + "ResourcesSuffix"
                let fengniao = FengNiao(projectPath: project.string,
                                        excludePaths: [],
                                        resourceExtensions: ["png"],
                                        fileExtensions: [])
                let result = fengniao.resourcesInUse()
                let expected: [String: Set<String>] = [
                    "image": [(project + "image@2x.png").string, (project + "image@3x.png").string],
                    "cloud": [(project + "cloud.png").string]
                ]
                try expect(result) == expected
            }
        }
        
    }
    
    
}
