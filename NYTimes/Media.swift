//
//  Media.swift
//  NYTimes
//
//  Created by Arturo Jamaica Garcia on 06/04/17.
//  Copyright © 2017 Arturo Jamaica. All rights reserved.
//

import Foundation
import Mapper

struct Media: Mappable {
    
   
    let url: String
    let width:Int
    let height:Int

    
    init(map: Mapper) throws {
        
        try url = map.from("url")
        try width = map.from("width")
        try height = map.from("height")

    }
    
}
