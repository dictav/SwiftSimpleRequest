//
//  Response.swift
//  SimpleRequest
//
//  Created by 阿部慎太郎 on 8/8/15.
//  Copyright © 2015 阿部慎太郎. All rights reserved.
//

import Foundation

public protocol Serializable {
    init (data: NSData) throws
}

public enum Response<T: Serializable> {
    case Success(T)
    case Failure(ErrorType)
    
    public var value: T? {
        if case .Success(let v) = self {
            return v
        }
        
        return nil
    }
    
    public var error: ErrorType? {
        if case .Failure(let e) = self {
            return e
        }
        
        return nil
    }
    
    public func success(f:(T) -> Void) -> Response {
        if case .Success(let v) = self {
            f(v)
        }
        
        return self
    }
    
    public func failure(f:(ErrorType) -> Void) -> Response {
        if case .Failure(let e) = self {
            f(e)
        }
        
        return self
    }
}