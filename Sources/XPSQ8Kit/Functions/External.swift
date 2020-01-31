//
//  File.swift
//  
//
//  Created by Dr. Owen Hildreth (Admin) on 1/31/20.
//

import Foundation

public extension GatheringController {
    struct ExternalController {
        var controller: XPSQ8Controller
    }
}


// MARK: Access Gathering Namespace
public extension GatheringController {
    /// The set of gathering commands for external configurations
    var external: ExternalController {
        return ExternalController(controller: self)
    }
}

