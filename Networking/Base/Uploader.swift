//
//  Uploader.swift
//  Networking
//
//  Created by Enter on 2020/6/30.
//  Copyright © 2020 Enter. All rights reserved.
//


import Foundation
import Alamofire

public typealias  EmptyBlock = () -> ()

public class Uploader {
    static let queue = DispatchQueue(label: "com.entertech.uploader")
    public static func upload(_ fileURL: URL, to url: URL, dic: [String: String], successed: EmptyBlock?, failure: EmptyBlock?) {
        queue.asyncAfter(deadline: DispatchTime.now()+1, execute: {
            if let data = try? Data(contentsOf: fileURL) {
                AF.upload(data, to: url, method: .put).response { (data) in
                    switch data.result{
                    case .success(_):
                        successed?()
                    case .failure(_):
                        failure?()
                    }
                }
            }
        })
            
            
        
//            let end = AF.upload(multipartFormData: { (multipleData) in
//                for (key, value) in dic {
//                    let data = value.data(using: .utf8)!
//                    multipleData.append(data, withName: key)
//                }
//                multipleData.append(fileURL, withName: "File", fileName: fileURL.lastPathComponent, mimeType: "")
//            }, to: url, method: .put).response { (data) in
//                switch data.result{
//                case .success(_):
//                    successed?()
//                case .failure(_):
//                    failure?()
//                }
//            }
            
            
//            { result in
//                switch result {
//                case .success(let request, _ , _):
//                    request.uploadProgress(closure: { (progress) in
//                        DLog("upload progress \(progress)")
//                    })
//
//                    request.responseJSON(completionHandler: { response in
//                        DLog("upload response is \(response)")
//                        if let response = response.response, response.statusCode == 204 {
//                            successed?()
//                        } else {
//                            failure?()
//                        }
//                    })
//
//                case .failure(let error):
//                    DLog("upload failed error: \(error)")
//                    failure?()
//                }
//            }
        

    }
}
