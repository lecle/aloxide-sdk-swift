//
//  Field.swift
//  aloxide-sdk-swift
//
//  Created by quoc huynh on 10/29/20.
//

import Foundation

public class Field{
    let name: String
    let fields: [FieldDetail]
    init(name: String, fields: [FieldDetail]) {
        self.name = name
        self.fields = fields
    }
}
