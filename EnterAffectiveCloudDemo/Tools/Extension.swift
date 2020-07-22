//
//  Extension.swift
//  EnterAffectiveCloudDemo
//
//  Created by Enter on 2019/12/18.
//  Copyright © 2019 Enter. All rights reserved.
//

import UIKit
import FluentDarkModeKit

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


/// ble notification user info key
public enum NotificationKey: String {
    case bleStateKey
    case bleBrainwaveKey
    case bleBatteryKey
    case bleHeartRateKey
    case dfuStateKey
    case websocketStateKey
    case kResponseAuthTokenKey
    case kResponseAuthUserIDKey
    case kResponseAuthUserNameKey
    case KResponseAuthSocialType
}

struct NotificationName {
    static let kFinishWithCloudServieDB = Notification.Name("kFinishWithCloudServieKey")
    static let bleStateChanged = Notification.Name("bleStateChangedKey")
    static let bleBrainwaveData = Notification.Name("bleBrainwaveData")
    static let bleBatteryChanged = Notification.Name("bleBatteryChangedKey")
    static let bleHeartRateData = Notification.Name("bleHeartRateDataKey")
    static let dfuStateChanged = Notification.Name("dfuStateChanged")
    static let kAuthorizationTokenResponse = Notification.Name("kAuthorizationTokenResponse")
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
    
    func paretViewController() -> UIViewController? {

         var n = self.next
         
         while n != nil {
             
             if (n is UIViewController) {
                 
                 return n as? UIViewController
             }
             
             n = n?.next
         }
         
         return nil
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
    
    class func resolveGifImage(gif: String, any: AnyClass) -> [UIImage]{
        var images:[UIImage] = []
        //let gifPath = Bundle.init(identifier: "cn.entertech.EnterAffectiveCloudUI")?.path(forResource: gif, ofType: "gif")
        let gifPath = Bundle(for: any).path(forResource: gif, ofType: "gif")
        if gifPath != nil{
            if let gifData = try? Data(contentsOf: URL.init(fileURLWithPath: gifPath!)){
                let gifDataSource = CGImageSourceCreateWithData(gifData as CFData, nil)
                let gifcount = CGImageSourceGetCount(gifDataSource!)
                for i in 0...gifcount - 1{
                    let imageRef = CGImageSourceCreateImageAtIndex(gifDataSource!, i, nil)
                    let image = UIImage(cgImage: imageRef!)
                    images.append(image)
                }
            }
        }
        return images
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

extension DispatchQueue {
    private static var _onceTracker = [String]()
    public class func once(token: String, block: () -> ()) {
        objc_sync_enter(self)
        defer {
            objc_sync_exit(self)
        }
        if _onceTracker.contains(token) {
            return
        }
        _onceTracker.append(token)
        block()
    }
    
    func async(block: @escaping ()->()) {
        self.async(execute: block)
    }
    
    func after(time: DispatchTime, block: @escaping ()->()) {
        self.asyncAfter(deadline: time, execute: block)
    }
}


extension UIColor {
    
    /// 根据背景色创建图片
    func image() -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, UIScreen.main.scale)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(self.cgColor)
        context?.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
}

extension String {
    public func HexToColor() -> UIColor {
        return UIColor.colorWithHexString(hexColor: self)
    }
}

extension UIAlertController {
    func present(in viewController: UIViewController? = nil, _ completion: (() -> Void)? = nil) {

        if UIDevice.current.userInterfaceIdiom == .pad && self.preferredStyle == .actionSheet {
            let popPresenter = self.popoverPresentationController;
            popPresenter?.permittedArrowDirections = .down
            popPresenter?.sourceView = self.view;
            popPresenter?.sourceRect = CGRect(x: self.view.bounds.width/2, y: self.view.bounds.height, width: 0, height: 0)
        }
        let mainWindow = UIApplication.shared.delegate!.window!
        (viewController ??
            mainWindow?.rootViewController)?.present(self, animated: true, completion: completion)
    }
}


extension UILabel {
    func setLine(space: CGFloat) {
        guard let txt = self.text else { return }
        let attributeString = NSMutableAttributedString(string: txt)
        let attributeStyle = NSMutableParagraphStyle()
        attributeStyle.lineSpacing = space
        attributeString.addAttribute(NSAttributedString.Key.paragraphStyle, value: attributeStyle, range:NSMakeRange(0, attributeString.length))
        self.attributedText = attributeString
        self.sizeToFit()
    }

    func setWord(space: CGFloat) {
        guard let txt = self.text else { return }
        let attributeString = NSMutableAttributedString(string: txt, attributes: [NSAttributedString.Key.kern: space])
        let attributeStyle = NSMutableParagraphStyle()
        attributeString.addAttribute(NSAttributedString.Key.paragraphStyle, value: attributeStyle, range: NSRange(location: 0, length: attributeString.length))
        self.attributedText = attributeString
        self.sizeToFit()
    }

    func setSapce(_ lineSpace: CGFloat, wordSpace: CGFloat) {
        self.setLine(space: lineSpace)
        self.setWord(space: wordSpace)
    }
}

extension Double {
    func toTime()-> (hour: Int, mins: Int, seconds: Int) {
        return (Int(self) / 3600, (Int(self) % 3600) / 60, ((Int(self) % 3600) / 60) % 60 )
    }

    func timeString() -> String {
        let hour = Int(self) / 3600
        let mins = (Int(self) % 3600) / 60
        if hour != 0 {
            var hourStr = String(format: "%02d hour ", hour)
            if hour > 1  {
                hourStr = String(format: "%02d hours ", hour)
            }
            let minStr = String(format: "%02d min", mins)
            return hourStr + minStr
        }
        return String(format: "%02d min", mins)
    }
}

extension String {
    static func timeString(with duration: Double) -> String {
        let hours = Int(duration) / (60*60)
        let mins = (Int(duration) % (60*60)) / 60
        let seconds = (Int(duration) % (60*60)) % 60
        if duration < 60*60 {
            return String(format: "%02d:%02d", mins, seconds)
        }

        return String(format: "%02d:%02d:%02d", hours, mins,seconds)
    }
}


extension Date {

    static func year() -> Int {
        let calendar = Calendar.current
        let com = calendar.dateComponents([.year,.month,.day], from: Date())
        return com.year!
    }
    
    static func month() -> Int {
        let calendar = Calendar.current
        let com = calendar.dateComponents([.year,.month,.day], from: Date())
        return com.month!
        
    }
    
    //MARK: 当月天数
    static func countOfDaysInMonth() ->Int {
        let calendar = Calendar.current
        let range = calendar.range(of: .day, in: .month, for: Date())
        return (range?.count)!
        
    }
    
    //MARK: 当月第一天是星期几
    static func firstWeekDay() ->Int {
        //1.Sun. 2.Mon. 3.Thes. 4.Wed. 5.Thur. 6.Fri. 7.Sat.
        let calendar = Calendar.current
        let components = calendar.dateComponents(Set<Calendar.Component>([.year, .month]), from: Date())
        let startOfMonth = calendar.date(from: components)
        let firstWeekDay = calendar.ordinality(of: .day, in: .weekOfMonth, for: startOfMonth!)
        return firstWeekDay! - 1
    }
    
    //是否是今天
    func isToday()->Bool {
        let calendar = NSCalendar.current
        let com = calendar.dateComponents([.year,.month,.day], from: self)
        let comNow = calendar.dateComponents([.year,.month,.day], from: Date())
        return com.year == comNow.year && com.month == comNow.month && com.day == comNow.day
    }
    //是否是这个月
    func isThisMonth()->Bool {
        let calendar = NSCalendar.current
        let com = calendar.dateComponents([.year,.month,.day], from: self)
        let comNow = calendar.dateComponents([.year,.month,.day], from: Date())
        return com.year == comNow.year && com.month == comNow.month
    }
    
    //是这个月的第几天
    func whichDayInMonth() -> Int {
        let calendar = NSCalendar.current
        let com = calendar.dateComponents([.year,.month,.day], from: self)
        return com.day! - 1
    }

}


extension UIView {
    public func setShadow() {
        self.layer.cornerRadius = 8
        self.layer.shadowColor = UIColor.lightGray.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.layer.shadowOpacity = 0.3
        self.layer.shadowRadius = 6
    }
    
    ///保存截图并分享
    func saveScreenAndShare(timeString:String) {
        
        let scales = UIScreen.main.scale
        let shotImage: UIImage?
        
        
        var headImage = #imageLiteral(resourceName: "img_share_bg")
        let headImageView = UIImageView(image: headImage)
        if #available(iOS 13.0, *) {
            
            if DMTraitCollection.current.userInterfaceStyle == .dark {
                let color = #colorLiteral(red: 0.02352941176, green: 0.02745098039, blue: 0.03921568627, alpha: 1)
                self.backgroundColor = color
                headImageView.backgroundColor = color
            } else {
                self.backgroundColor = #colorLiteral(red: 0.9921568627, green: 0.9450980392, blue: 0.9176470588, alpha: 1)
                headImageView.backgroundColor = #colorLiteral(red: 0.9921568627, green: 0.9450980392, blue: 0.9176470588, alpha: 1)
            }
        } else {
            self.backgroundColor = #colorLiteral(red: 0.9921568627, green: 0.9450980392, blue: 0.9176470588, alpha: 1)
            headImageView.backgroundColor = #colorLiteral(red: 0.9921568627, green: 0.9450980392, blue: 0.9176470588, alpha: 1)
        }
        shotImage = self.capture
        
        let nameLabel = UILabel(frame: CGRect(x: 0, y: 58, width: headImageView.frame.width, height: 20))
        nameLabel.textAlignment = .center
        nameLabel.text = "\(User.default.name) 的"
        nameLabel.font = UIFont.systemFont(ofSize: 16)
        let titleLabel1 = UILabel(frame: CGRect(x: 30, y: 85, width: headImageView.frame.width-60, height: 24))
        let text1 = "冥想生物数据"
        titleLabel1.textAlignment = .center
        titleLabel1.text = text1
        titleLabel1.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        let titleLabel2 = UILabel(frame: CGRect(x: 30, y: 110, width: headImageView.frame.width-60, height: 24))
        let text2 = "报告"
        titleLabel2.textAlignment = .center
        titleLabel2.text = text2
        titleLabel2.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        let time = UILabel(frame: CGRect(x: 0, y: 150, width: headImageView.frame.width, height: 16))
        time.textAlignment = .center
        time.text = timeString
        time.font = UIFont.systemFont(ofSize: 14)
        headImageView.addSubview(nameLabel)
        headImageView.addSubview(titleLabel1)
        headImageView.addSubview(titleLabel2)
        headImageView.addSubview(time)
        headImage = headImageView.snapshotImageByLayer()!

        let beforeResizeImage = shotImage?.mergeImage(other: headImage) //上下合并图, 不同分辨率屏幕 截出来x2,x3
        let resizeImage = beforeResizeImage!.resizableImage(withCapInsets: UIEdgeInsets(top: (beforeResizeImage?.size.height)! - 2, left: 0, bottom: (beforeResizeImage?.size.height)! - 1, right: 0), resizingMode: .stretch)
        let tempImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: resizeImage.size.width, height: resizeImage.size.height+100*scales))
        tempImageView.image = resizeImage

        let logoImage = #imageLiteral(resourceName: "icon_screen_shot_logo")
        let iconImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: logoImage.size.width*scales, height: logoImage.size.height*scales))
        iconImageView.image = logoImage
        tempImageView.addSubview(iconImageView)
        iconImageView.center = CGPoint(x: tempImageView.frame.width / 2, y: tempImageView.frame.height - 150 - 20*scales)
        let shareImage = tempImageView.snapshotImageByLayer()!
        let cachePath = FTFileManager.shared.cacheDirectory
        let imagePath = cachePath + "/shareImage.jpg"
        try? shareImage.jpegData(compressionQuality: 1)?.write(to: URL(fileURLWithPath: imagePath))
        let item = ActivityItem(image: shareImage, path: URL(fileURLWithPath: imagePath))
        let activitiyViewcontroller = UIActivityViewController(activityItems: [item],
                                                               applicationActivities: nil)
        activitiyViewcontroller.popoverPresentationController?.sourceView = self
        if #available(iOS 13.0, *) {
            activitiyViewcontroller.isModalInPresentation = true
        } else {
            // Fallback on earlier versions
        }
        self.paretViewController()?.present(activitiyViewcontroller, animated: true, completion: nil)

        activitiyViewcontroller.completionWithItemsHandler = { (type, completed, item, error) in
            if completed {
                let alter = UIAlertController(title: "Completed", message: "", preferredStyle: .alert)
                let alterBtn = UIAlertAction(title: "OK", style: .default, handler: nil)
                alter.addAction(alterBtn)
                self.paretViewController()?.present(alter, animated: true, completion: nil)
            }
            if let error = error {
                let alter = UIAlertController(title: "Failed", message: "\(error.localizedDescription)", preferredStyle: .alert)
                let alterBtn = UIAlertAction(title: "OK", style: .default, handler: nil)
                alter.addAction(alterBtn)
                self.paretViewController()?.present(alter, animated: true, completion: nil)
            }
        }
        self.backgroundColor = Colors.bg2
    }
}


extension UIView {
    func addRounderCorner(corners: UIRectCorner, radius: CGSize) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: radius)
        let shape = CAShapeLayer()
        shape.path = path.cgPath
        self.layer.mask = shape
    }
}


extension UIColor {
    static func random() -> UIColor {
        let randomR = CGFloat(arc4random() % 255) / 255.0
        let randomG = CGFloat(arc4random() % 255) / 255.0
        let randomB = CGFloat(arc4random() % 255) / 255.0

        return UIColor(displayP3Red: randomR, green: randomG, blue: randomB, alpha: 1.0)
    }
    
}
