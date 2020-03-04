//
//  ShareEntity+CoreDataProperties.swift
//  timeLinesTest3
//
//  Created by Andrea Maria Lupi on 04/03/2020.
//  Copyright © 2020 Andrea Maria Lupi. All rights reserved.
//
//

import Foundation
import CoreData


extension ShareEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ShareEntity> {
        return NSFetchRequest<ShareEntity>(entityName: "ShareEntity")
    }

    @NSManaged public var shareLabel: String?

}
