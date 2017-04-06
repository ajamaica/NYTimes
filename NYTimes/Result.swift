//
//  Result.swift
//  NYTimes
//
//  Created by Arturo Jamaica Garcia on 06/04/17.
//  Copyright © 2017 Arturo Jamaica. All rights reserved.
//

import Foundation
import Mapper

struct Doc: Mappable {
    
    var lead_paragraph: String?
    let url: String
    let id: String
    var title : String?
    var byline : String?
    var abstract: String?
    
    init(map: Mapper) throws {
        
        lead_paragraph = map.optionalFrom("lead_paragraph")
        try url = map.from("web_url")
        try id = map.from("_id")
        title = map.optionalFrom("headline.main")
        abstract = map.optionalFrom("abstract")
        byline = map.optionalFrom("byline.contributor")        
    }
    
}
