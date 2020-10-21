//
//  AloxideMethodDelegate.swift
//  Aloxide
//
//  Created by quoc huynh on 10/19/20.
//

import Foundation


protocol AloxideMethodDelegate {
    func get(id: Any) throws -> Any
    func add(params: Any) throws -> Bool
    func update(id: String, params: Any) throws -> Bool
    func delete(id: String) throws -> Bool
}
