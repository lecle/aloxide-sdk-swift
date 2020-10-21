//
//  AloxideExceptions.swift
//  Aloxide
//
//  Created by quoc huynh on 10/19/20.
//

import Foundation
class  AloxideExceptions: Error{
    var code: Int
    var message: String
    init(code: Int, message: String) {
        self.code = code
        self.message = message
    }
}
