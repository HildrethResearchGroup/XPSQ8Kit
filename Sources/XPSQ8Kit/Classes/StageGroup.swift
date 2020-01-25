//
//  File.swift
//  
//
//  Created by Owen Hildreth on 1/24/20.
//

import Foundation

class StageGroup {
    var stages:[StageGroup] = []
    let stageGroupName: String
    
    public init(stageGroupName:String) {
        self.stageGroupName = stageGroupName
    }
}
