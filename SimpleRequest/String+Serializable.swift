//
//  String+Serializable.swift
//  SimpleRequest
//
//  Created by 阿部慎太郎 on 8/8/15.
//  Copyright © 2015 阿部慎太郎. All rights reserved.
//

extension String : Serializable {
    public init(data: NSData) throws {
        let chars = UnsafePointer<CChar>(data.bytes)
        if let str = String.fromCString(chars) ?? String.fromCStringRepairingIllFormedUTF8(chars).0 {
            self = str
        } else {
            throw Error.SerializationError("Cannot convert to string")
        }
    }
}