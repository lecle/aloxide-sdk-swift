//
//  BlockchainNetwork.swift
//  aloxide-sdk-swift
//
//  Created by quoc huynh on 10/19/20.
//

import Foundation
protocol BlockchainNetwork {
    func get(id: Any)  -> Any?
    func get(id: Any, completion: @escaping (AloxideResult<String, AloxideExceptions>) -> Void)
    func add(params: Any,completion: @escaping (AloxideResult<Bool, AloxideExceptions>) -> Void)
    func update(id: String, params: Any,completion: @escaping (AloxideResult<Bool, AloxideExceptions>) -> Void)
    func delete(id: String,completion: @escaping (AloxideResult<Bool, AloxideExceptions>) -> Void)
    func validate() -> Bool
}
