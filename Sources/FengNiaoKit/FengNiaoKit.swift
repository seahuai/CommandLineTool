//
// public struct 不会自己创建init方法
//

import Foundation
import PathKit

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
    
    func stringsInUse() -> [String]{
        fatalError()
    }
    
    func resourcesInUse() -> [String: String]{
        fatalError()
    }
    
    public func delete(){
        
    }
    
}
