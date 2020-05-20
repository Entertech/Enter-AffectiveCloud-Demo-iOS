//
//  Downloader.swift
//  Networking
//
//  Created by Enter on 2020/5/20.
//  Copyright © 2020 Enter. All rights reserved.
//

import Foundation
import Alamofire

public typealias ActionBlock<T> = (T) -> ()

public class Downloader {
    static let queue = DispatchQueue(label: "cn.enter.file.downloader")

    public private(set) var downloadState: DownloadState = .none
    var isFinish: Bool {
        return self.downloadState == .finished
    }
    
    public required init() {
        
    }

    private var downloadRequest: DownloadRequest?
    private var fileURL: URL?

    public func download(_ url: URL, to destination: URL, progressBlock: ActionBlock<Double>? = nil, completion: ActionBlock<Result<Data, AFError>>? = nil) {
        self.fileURL = url
        let toFilePath: DownloadRequest.Destination = { _, _ in
            return (destination, [.removePreviousFile, .createIntermediateDirectories])
        }
        self.downloadRequest = AF.download(url, to: toFilePath).downloadProgress(queue: Downloader.queue) { (progess) in
            self.downloadState = .downloading
            print("download progress \(progess.fractionCompleted)")
            progressBlock?(progess.fractionCompleted)
            }.responseData { (response) in
                completion?(response.result)
                self.downloadState = .finished
        }
    }

    func closeDownloader() {
        self.downloadRequest?.cancel()
        if self.downloadState == .downloading, let url = self.fileURL {
            if FileManager.default.fileExists(atPath: url.path) {
                try? FileManager.default.removeItem(atPath: url.path)
            }
        }
    }
}

public enum DownloadState {
    case none
    case downloading
    case finished
}
