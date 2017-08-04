//
//  VoiceInformationManager.swift
//  VoiceNote
//
//  Created by HideOnBush on 2017/8/4.
//  Copyright © 2017年 HideOnBush. All rights reserved.
//

import UIKit
import CoreData

class VoiceInformationManager: NSObject {
    
    
    /// 插入数据
    ///
    /// - Parameters:
    ///   - voiceName: 名称
    ///   - voiceTime: 录音时长
    ///   - voiceDate: 录音时间
    ///   - voiceURL: 录音地址
    class func insertData(voiceName: String?, voiceTime: Int16, voiceDate: Date?, voiceURL: String?) {
      
        let app = UIApplication.shared.delegate as! AppDelegate
        let context = app.persistentContainer.viewContext
        
      
        let entityName = "VoiceInformation"
        let voiceInfo = NSEntityDescription.insertNewObject(forEntityName: entityName, into: context) as! VoiceInformation
        
        guard voiceName != nil && voiceTime != 0 && voiceDate != nil && voiceURL != nil else {
            return
        }
        
        voiceInfo.voiceDate = voiceDate! as NSDate
        voiceInfo.voiceName = voiceName
        voiceInfo.voiceTime = voiceTime
        voiceInfo.voiceURL = voiceURL
        
        
        app.saveContext()
        
    }
    
    
    /// 查询数据
    ///
    /// - Returns: VoiceInformation
    class func queryData() -> [VoiceInformation] {
        let app = UIApplication.shared.delegate as! AppDelegate
        let context = app.persistentContainer.viewContext
        
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest()
        
        
        let entityName = "VoiceInformation"
        let entity = NSEntityDescription.entity(forEntityName: entityName, in: context)
        fetchRequest.entity = entity
        
        let predicate = NSPredicate.init(format: "voiceURL != nil", "")
        fetchRequest.predicate = predicate
        
        do {
            return try context.fetch(fetchRequest) as! [VoiceInformation]
        } catch {
            let errors = error as Error
            fatalError("查询错误: \(errors)")
        }
    }
}

