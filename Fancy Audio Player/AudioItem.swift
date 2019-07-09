//
//  AudioItem.swift
//  Fancy Audio Player
//
//  Created by Colin Cherot on 1/23/17.
//  Copyright © 2017 Colin Cherot. All rights reserved.
//

import Foundation

class AudioItem //do the NSCoding and  NSObject stuff for local storage?
{
    let fileName:String
    
    let albumArt: String
    
    var fileType:String? {
        
        return (fileName as NSString).pathExtension//substring(from: fileName.lastin)
    }
    
    
    var resourceName:String? {
        return (fileName as NSString).deletingPathExtension
    }
    
    init(fileName: String, albumArt: String)
    {
        self.fileName = fileName
        
        self.albumArt = albumArt
    }
    
    required init (code aDecoder: NSCoder)
    {
        self.fileName = aDecoder.decodeObject(forKey: "fileName") as? String ?? ""
        
        self.albumArt = aDecoder.decodeObject(forKey: "albumArt") as? String ?? ""
    }
    
    
    
}
