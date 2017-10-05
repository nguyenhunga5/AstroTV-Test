//
//  ATVFavoritesUtils.swift
//  AstroTV
//
//  Created by Hung Nguyen Thanh on 10/5/17.
//  Copyright © 2017 Hung Nguyen Thanh. All rights reserved.
//

import UIKit

class ATVFavoritesUtils: NSObject {

    private var channelIds: [Int]!
    var identifier: String
    
    
    init(identifier: String) {
        
        self.identifier = identifier
        let filePath = ATVFavoritesUtils.filePath(identifier: identifier)
        
        super.init()
        self.loadFavorites(filePath: filePath)
        
        ATVNetworkUtils.sharedInstance.s3DownloadFile(filePath.lastPathComponent, filePath: filePath) { (resultObj) in
            
            if let _ = resultObj {
                
                self.loadFavorites(filePath: filePath)
            }
            
        }
        
    }
    
    private func loadFavorites(filePath: String) {
        
        if let channelIds = NSArray(contentsOfFile: filePath) as? [Int] {
            
            self.channelIds = channelIds
            
        } else {
            
            self.channelIds = [Int]()
        }
    }
    
    class func filePath(identifier: String) -> String {
        
        let filePath = NSHomeDirectory() + "/Documents/\(identifier).plist"
        return filePath
    }
    func clear() {
        
        do {
            
            try FileManager.default.removeItem(atPath: ATVFavoritesUtils.filePath(identifier: self.identifier))
        } catch {
            
        }
        
    }
    
    private func save() {
        
        let filePath = ATVFavoritesUtils.filePath(identifier: identifier)
        (self.channelIds as NSArray).write(toFile: filePath, atomically: true)
        ATVNetworkUtils.sharedInstance.s3UploadFile(filePath.lastPathComponent, filePath: filePath) { (_) in
            
        }
    }
    
    func check(with channelId: Int) -> Bool {
        
        return self.channelIds.contains(channelId)
    }
    
    func addOrRemove(with channelId: Int) {
        
        if self.check(with: channelId) {
            
            let index = self.channelIds.index(of: channelId)!
            self.channelIds.remove(at: index)
        } else {
            
            self.channelIds.append(channelId)
        }
        
        self.save()
    }
    
    func getChannels(with channels: [ATVChannel]) -> [ATVChannel] {
        
        let result = channels.filter {
            
            self.channelIds.contains($0.channelId!)
            
        }
        
        return result
    }
}
