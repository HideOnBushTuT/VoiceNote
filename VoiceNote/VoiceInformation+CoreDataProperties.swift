//
//  VoiceInformation+CoreDataProperties.swift
//  VoiceNote
//
//  Created by HideOnBush on 2017/8/4.
//  Copyright © 2017年 HideOnBush. All rights reserved.
//

import Foundation
import CoreData


extension VoiceInformation {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<VoiceInformation> {
        return NSFetchRequest<VoiceInformation>(entityName: "VoiceInformation")
    }

    @NSManaged public var voiceName: String?
    @NSManaged public var voiceTime: Int16
    @NSManaged public var voiceDate: NSDate?
    @NSManaged public var voiceURL: String?

}
