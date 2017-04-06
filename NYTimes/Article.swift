//
//  Article.swift
//  NYTimes
//
//  Created by Arturo Jamaica Garcia on 06/04/17.
//  Copyright © 2017 Arturo Jamaica. All rights reserved.
//

import Foundation
import Mapper

struct Article: Mappable {
    
    let id: Int
    let url: String
    let title: String
    let abstract: String
    let byline : String
    
    init(map: Mapper) throws {
        
        try id = map.from("id")
        try url = map.from("url")
        try title = map.from("title")
        try abstract = map.from("abstract")
        try byline = map.from("byline")

        
    }
    
}
