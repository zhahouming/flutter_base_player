import Cocoa
import FlutterMacOS

public class InodePlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "inode", binaryMessenger: registrar.messenger)
    let instance = InodePlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {

    if call.method == "getInode" {
      guard let filePath = call.arguments as? String else {
        result(FlutterError(code: "INVALID_ARGUMENTS", message: "Invalid arguments received", details: nil))
        return
      }
      
      do {
        let inode = try getFileInode(for: filePath)
        result(inode)
      } catch {
        result(FlutterError(code: "UNABLE_TO_GET_INODE", message: "Unable to retrieve inode", details: nil))
      }
    } else {
      result(FlutterMethodNotImplemented)
    }


    // switch call.method {
    // case "getInode":
    //   result(11111111111)
    // default:
    //   result(FlutterMethodNotImplemented)
    // }
  }

  private func getFileInode(for path: String) throws -> UInt64 {
    let fileAttributes = try FileManager.default.attributesOfItem(atPath: path)
    if let inodeNumber = fileAttributes[FileAttributeKey.systemFileNumber] as? NSNumber {
        return inodeNumber.uint64Value
    } else {
        throw NSError(domain: "", code: 0, userInfo: nil)
    }
  }
}
