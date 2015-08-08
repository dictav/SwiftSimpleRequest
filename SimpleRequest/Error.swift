//
//  Error.swift
//  SimpleRequest
//
//  Created by 阿部慎太郎 on 8/8/15.
//  Copyright © 2015 阿部慎太郎. All rights reserved.
//

import Foundation

public enum Error: ErrorType {
    case SystemError(NSError)
    case TimeoutError
    case HTTPStatusError(HTTPStatus)
    case SerializationError(String)
    
    public var description: String {
        switch self {
        case .SystemError(let e):
            return e.description
        case .TimeoutError:
            return "Timeout Error"
        case .HTTPStatusError(let e):
            return "HTTPStatusError: \(e.rawValue)"
        case .SerializationError(let s):
            return s
        }
    }
}