//
//  MMPM_ACCOUNTS+CoreDataProperties.swift
//  MMPasswordManager
//
//  Created by miura on 2016/04/27.
//  Copyright © 2016年 miura. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension MMPM_ACCOUNTS {

    @NSManaged var account_title: String?
    @NSManaged var password: String?
    @NSManaged var url: String?
    @NSManaged var username: String?

}
