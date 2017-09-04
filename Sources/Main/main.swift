import Foundation
import CommandLineKit
import Rainbow

let cli = CommandLineKit.CommandLine()

let projectOption = StringOption(
    shortFlag: "p", longFlag: "project",
    helpMessage: "Path to the the project.")

let excludeOption = MultiStringOption(
    shortFlag: "e", longFlag: "exclude",
    helpMessage: "Excluded paths which should not search in")

let resourceExtensionsOption = MultiStringOption(
    shortFlag: "r", longFlag: "resource-extensions",
    helpMessage: "Extensions to search")

let fileExtensionsOption = MultiStringOption(
    shortFlag: "f", longFlag: "file-extensions",
    helpMessage: "File Extensions to search with")

let help = BoolOption(shortFlag: "h", longFlag: "help",
                      helpMessage: "Prints a help message.")

cli.addOptions(projectOption, excludeOption, resourceExtensionsOption, fileExtensionsOption, help)

cli.formatOutput = { s, type in
    var str: String
    switch(type) {
    case .error:
        str = s.red.bold
    case .optionFlag:
        str = s.green.underline
    case .optionHelp:
        str = s.blue
    default:
        str = s
    }
    
    return cli.defaultFormat(s: str, type: type)
}

do {
    try cli.parse()
} catch {
    cli.printUsage(error)
    exit(EX_USAGE)
}

//输出help
if help.value {
    cli.printUsage()
    exit(EX_OK)
}

//project路径，值为空的话为当前路径
let project = projectOption.value ?? "."

//不希望搜索的路径
let exclude = excludeOption.value ?? []

//图片资源文件扩展名
let resourceExtension = resourceExtensionsOption.value ?? ["png", "jpg", "imageset"]

//需要搜索的文件扩展名
let fileExtension = fileExtensionsOption.value ?? ["swift", "m", "mm", "xib", "storyboard"]







