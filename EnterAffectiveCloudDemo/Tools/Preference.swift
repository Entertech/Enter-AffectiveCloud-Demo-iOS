//
//  Preference.swift
//  EnterAffectiveCloudDemo
//
//  Created by Enter on 2019/11/15.
//  Copyright © 2019 Enter. All rights reserved.
//

import UIKit

typealias  EmptyBlock = () -> ()
typealias ActionBlock<T> = (T) -> ()

class Preference {
    static var FLOWTIME_WS = ""
    static var kCloudServiceAppKey = ""
    static var kCloudServiceAppSecret = ""
    
    static let help = "https://www.notion.so/Flowtime-Help-Center-b151d8677e5c41d8af6364f44fb93369"
    static let privacy = "https://www.meetinnerpeace.com/privacy-policy"
    static let terms = "https://www.meetinnerpeace.com/terms-of-service"
}

extension Preference {
    static let userID = 1
    static let meditationTime = 60
}

extension Preference {
    private static let shortVersion = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
    private static let buildVersion = Bundle.main.infoDictionary!["CFBundleVersion"] as! String
    static let appVersion = shortVersion + "(\(buildVersion))"
}



extension Date {

    /// get string with specific formate
    ///
    /// - Parameter dateFormatter: date formate like "yyyy-MM-dd HH:mm"
    /// - Returns: string date :
    func string(custom dateFormatter: String, local: Locale = .current)-> String {
        let format = DateFormatter()
        format.dateFormat = dateFormatter
        format.locale = local
        return format.string(from: self)
    }

    static func date(dateString: String, custom: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = custom
        formatter.timeZone = TimeZone.current
        return formatter.date(from: dateString)
    }
}


struct NotificationName {
    static let kFinishWithCloudServieDB = Notification.Name("kFinishWithCloudServieKey")
}


//MARK: notification handler
extension Notification.Name {
    func emit(_ userInfo: [String: Any]? = nil) {
        NotificationCenter.default.post(name: self, object: nil, userInfo: userInfo)
    }

    func observe(sender: Any, selector: Selector) {
        NotificationCenter.default.addObserver(sender,
                                               selector: selector,
                                               name: self,
                                               object: nil)
    }
    
    func remove(sender: Any) {
        NotificationCenter.default.removeObserver(sender, name: self, object: nil)
    }
}

extension UIViewController {
    class func currentViewController(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return currentViewController(base: nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            return currentViewController(base: tab.selectedViewController)
        }
        if let presented = base?.presentedViewController {
            return currentViewController(base: presented)
        }
        return base
    }
}

extension UIView {
    func setLayerColors(_ colors: [CGColor]) {
        let layer = CAGradientLayer()
        layer.frame = bounds
        layer.colors = colors
        layer.startPoint = CGPoint(x: 0.0, y: 0.0)
        layer.endPoint = CGPoint(x: 1.0, y: 0.0)
        self.layer.addSublayer(layer)
    }
    
    func snapshotImage() -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, UIScreen.main.scale)
        drawHierarchy(in: bounds, afterScreenUpdates: true)
        let snapshotImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return snapshotImage
    }
    
    func snapshotImageByLayer() -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, UIScreen.main.scale)
        self.layer.render(in: UIGraphicsGetCurrentContext()!)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        return image
    }
}


extension UIView {
    
    var capture: UIImage? {
        
        var image: UIImage? = nil
        UIGraphicsBeginImageContextWithOptions(self.frame.size, false, UIScreen.main.scale)
        do {

            self.layer.render(in: UIGraphicsGetCurrentContext()!)
            image = UIGraphicsGetImageFromCurrentImageContext()

        }
        UIGraphicsEndImageContext()
        if let img = image {
            return img
        }
        return nil
    }
    
    func removeAllConstrains()  {
        if let sView = self.superview {
            for e in sView.constraints {
                if e.firstItem as! UIView == self || e.secondItem as! UIView == self  {
                    sView.removeConstraint(e)
                }
            }
        }
        
    }
    
}

extension UIImage {
    //上下合并
    func mergeImage(other: UIImage) -> UIImage {
        let scale = UIScreen.main.scale
        let width = self.size.width * scale
        let height = self.size.height * scale
        let otherHeight = other.size.height * scale
        let resultSize = CGSize(width: width, height: height + otherHeight)
        UIGraphicsBeginImageContext(resultSize)
        
        let oneRect = CGRect(x: 0, y: 0, width: width, height: otherHeight)
        other.draw(in: oneRect)
        
        let twoRect = CGRect(x: 0, y: otherHeight, width: width, height: height)
        self.draw(in: twoRect)
        
        let rtImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return rtImage
        
    }
    
    
    func saveImage(imageName: String) -> String {
        let directory = NSHomeDirectory().appending("/Documents/")
        if !FileManager.default.fileExists(atPath: directory) {
            do {
                try FileManager.default.createDirectory(at: NSURL.fileURL(withPath: directory), withIntermediateDirectories: true, attributes: nil)
            } catch {
                print(error)
            }
        }
        let filePath = directory.appending(imageName)
        let url = NSURL.fileURL(withPath: filePath.appending(".jpeg"))
        do {
            //try self.jpegData(compressionQuality: 1.0)?.write(to: url, options: .atomic)
            let jpegFile = self.jpegData(compressionQuality: 1.0)
            try jpegFile?.write(to: url)
            return url.absoluteString
        } catch {
            print(error)
            return ""
        }
    }
    
    class func loadImage(imageName: String) -> UIImage {
        let directory = NSHomeDirectory().appending("/Documents/")
        let filePath = directory.appending(imageName)
        let url = NSURL.fileURL(withPath: filePath.appending(".jpeg"))
        let urlStr = url.path
        
        if FileManager.default.fileExists(atPath: urlStr) {
            return UIImage(contentsOfFile: urlStr)!
        }
        return #imageLiteral(resourceName: "img_yoga")
    }
}


extension UIColor {
    static func randomColor() -> UIColor {
        let randomR = CGFloat(arc4random() % 255) / 255.0
        let randomG = CGFloat(arc4random() % 255) / 255.0
        let randomB = CGFloat(arc4random() % 255) / 255.0

        return UIColor(displayP3Red: randomR, green: randomG, blue: randomB, alpha: 1.0)
    }

    static func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }

        if ((cString.count) != 6) {
            return UIColor.gray
        }

        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)

        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}
