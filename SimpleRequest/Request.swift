//
//  Request.swift
//  SimpleRequest
//
//  Created by 阿部慎太郎 on 8/8/15.
//  Copyright © 2015 阿部慎太郎. All rights reserved.
//

import Foundation

public struct SimpleRequest<T: Serializable>: Request {
    public typealias Model = T
    public var session = NSURLSession.sharedSession()
    public var URLRequest: NSURLRequest
    public var allowStatuses: [HTTPStatus]
    
    public init(URLRequest: NSURLRequest, statuses: [HTTPStatus]) {
        self.URLRequest = URLRequest
        self.allowStatuses = statuses
    }
    
    public func validStatus(status: HTTPStatus) -> Bool {
        return allowStatuses.contains(status)
    }
}

public protocol Request {
    typealias Model: Serializable
    var session: NSURLSession {get}
    var URLRequest: NSURLRequest {get}
    func validStatus(status: HTTPStatus) -> Bool
}

extension Request {
    public func call() -> Response<Model> {
        let sema = dispatch_semaphore_create(0);
        var response: Response<Model>?
        let task = session.dataTaskWithRequest(URLRequest) { (data, res, err) -> Void in
            response = self.makeResponse(data, res: res, err: err)
            
            dispatch_semaphore_signal(sema)
        }
        task.resume()
        let t = Int64(session.configuration.timeoutIntervalForRequest)
        let timeout = dispatch_time(DISPATCH_TIME_NOW, t * 1000_000_000)
        dispatch_semaphore_wait(sema, timeout)
        
        if let r = response {
            return r
        } else {
            return Response.Failure(Error.TimeoutError)
        }
    }
    
    public func call(f:(Response<Model> -> Void)) -> NSURLSessionTask {
        let task = session.dataTaskWithRequest(URLRequest) { (data, res, err) -> Void in
            f(self.makeResponse(data, res: res, err: err))
        }
        task.resume()
        
        return task
    }
}

extension Request {
    private func makeResponse<T>(data: NSData?, res: NSURLResponse?, err: NSError?) -> Response<T> {
        if let e  = err {
            return Response.Failure(Error.SystemError(e))
        }
        
        let r = res as! NSHTTPURLResponse
        let a = HTTPStatus(code: r.statusCode)
        if validStatus(a) {
            if let d = data {
                do {
                    return Response.Success(try T(data: d))
                } catch let err {
                    return Response.Failure(err)
                }
            } else {
                return Response.Failure(Error.SerializationError("Data is nil"))
            }
        } else {
            return Response.Failure(Error.HTTPStatusError(a))
        }
    }
}