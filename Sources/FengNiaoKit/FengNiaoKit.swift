//
// public struct 不会自己创建init方法
//

import Foundation
import PathKit
import Rainbow

enum FileType {
    case swift
    case objc
    case xib
    
    init?(ext: String){
        switch ext {
        case "swift": self = .swift
        case "m", "mm": self = .objc
        case "xib": self = .xib
        default: return nil
        }
    }
    
    func searcher(extensions: [String]) -> StringsSearcher{
        switch self {
        case .swift: return SwiftSearcher(extensions: extensions)
        case .objc: return ObjcSearcher(extensions: extensions)
        case .xib: return XibSearcher(extensions: extensions)
        }
    }
}


public struct FileInfo{
    let path: String
}

public struct FengNiao{
    
    let projectPath: Path
    let excludePaths: [Path]
    let resourceExtensions: [String]
    let fileExtensions: [String]
    
    public init(projectPath: String, excludePaths: [String],
                resourceExtensions: [String], fileExtensions: [String]) {
        let path = Path(projectPath).absolute()
        self.projectPath = path
        self.excludePaths = excludePaths.map { path + Path($0) }
        self.resourceExtensions = resourceExtensions
        self.fileExtensions = fileExtensions
    }
    
    
    public func unusedResource() -> [FileInfo]{
        fatalError()
    }
    
    func stringsInUse() -> Set<String>{
        return stringsInUse(at: projectPath)
    }
    
    func stringsInUse(at path: Path) -> Set<String>{
        guard let subPaths = try? path.children() else {
            print("Failed to get contents in path: \(path)".red)
            return []
        }
        
        var result = [String]()
        for subPath in subPaths{
            if subPath.lastComponent.hasPrefix(".") {
                continue
            }
            
            if excludePaths.contains(subPath) {
                continue
            }
            
            if subPath.isDirectory{
                result.append(contentsOf: stringsInUse(at: subPath))
            }else{
                let fileExt = subPath.extension ?? ""
                guard fileExtensions.contains(fileExt), let searcher = FileType(ext: fileExt)?.searcher(extensions: resourceExtensions) else{
                    continue
                }
                
                let content = (try? subPath.read()) ?? ""
                result.append(contentsOf: searcher.search(in: content))
            }
        }
        
        return Set(result)
        
    }
    
    func resourcesInUse() -> [String: Set<String>]{
        let find = FilePathProcess(path: projectPath, extensions: resourceExtensions, excluded: excludePaths)
        guard let result = find?.excute() else {
            print("Resource finding failed".red)
            return [:]
        }
        
        var files = [String: Set<String>]()
        
        let regularDirExtensions = ["imageset", "launchimage", "appiconset", "bundle"]
        var nonDirExtensions: [String] {
            return resourceExtensions.filter { !regularDirExtensions.contains($0) }
        }
        
        loop: for file in result{
            //跳过资源文件夹中文件 因为资源文件夹的名字就是资源文件的名字
            let dirPaths = regularDirExtensions.map { ".\($0)/" }
            for dir in dirPaths where file.contains(dir){
                continue loop
            }
            
            //跳过后缀名不正常的文件夹 eg: folder.png
            let filePath = Path(file)
            if let ext = filePath.extension, filePath.isDirectory && nonDirExtensions.contains(ext){
                continue
            }
            
            let key = file.plainName(resourceExtensions)
            if let existing = files[key]{
                files[key] = existing.union([file])
            }else{
                files[key] = [file]
            }
        }
        
        return files
        
    }
    
    public func delete(){
        
    }
    
}
