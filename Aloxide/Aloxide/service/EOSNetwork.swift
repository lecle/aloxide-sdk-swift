//
//  EOSNetwork.swift
//  Aloxide
//
//  Created by quoc huynh on 10/19/20.
//

import Foundation

class EOSNetwork: BlockchainNetwork{
    /**
     * Validation in EOS Network with the condition below:
     * - check the method name exist or not in ABI,...
     * - check non-null input: private key, account name, method is lower case
     * @return
     */
    func validate() -> Bool {
        return true
    }
    
    func add(params: Any) -> Bool {
        return true
    }
    func update(id: String, params: Any) -> Bool {
        return true
    }
    func get(id: Any) -> Any {
        return id
    }
    
    func delete(id: String) -> Bool {
        return true
    }
}
