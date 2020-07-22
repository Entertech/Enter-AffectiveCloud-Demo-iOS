//
//  ActivityItem.swift
//  EnterAffectiveCloudDemo
//
//  Created by Enter on 2020/7/3.
//  Copyright © 2020 Enter. All rights reserved.
//

import UIKit

class ActivityItem: NSObject, UIActivityItemSource {
    
    public var image: UIImage?
    public var path: URL?
    
    func activityViewControllerPlaceholderItem(_ activityViewController: UIActivityViewController) -> Any {
        
        return image as Any
    }
    
    func activityViewController(_ activityViewController: UIActivityViewController, itemForActivityType activityType: UIActivity.ActivityType?) -> Any? {
        return path
    }
    
    init(image: UIImage, path: URL) {
        super.init()
        self.image = image
        self.path = path
    }
}
