//
//  GoogleService.swift
//  SimpleRequestTests
//
//  Created by 阿部慎太郎 on 8/8/15.
//  Copyright © 2015 阿部慎太郎. All rights reserved.
//

import SimpleRequest

private let base = "http://www.google.co.jp"


struct GoogleService {
    private init(){}
    
    static var Top: SimpleRequest<String> {
        let req = NSURLRequest(URL: NSURL(string: base)!)
        return SimpleRequest(URLRequest: req, statuses:[.OK])
    }
    
    static func Search(query: String) -> SimpleRequest<String> {
        let url = NSURL(string: base + "/search?q=" + query)!
        let req = NSURLRequest(URL: url)
        return SimpleRequest(URLRequest: req, statuses:[.OK])
    }
}