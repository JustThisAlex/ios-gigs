//
//  Bearer.swift
//  Gigs
//
//  Created by Alexander Supe on 1/15/20.
//  Copyright © 2020 Alexander Supe. All rights reserved.
//

import Foundation

struct Bearer: Codable {
    let id: Int?
    let token: String
    let userId: Int?
}
