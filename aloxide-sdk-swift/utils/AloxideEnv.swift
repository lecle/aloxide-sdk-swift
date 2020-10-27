//
//  AloxideEnv.swift
//  aloxide-sdk-swift
//
//  Created by quoc huynh on 10/27/20.
//

import Foundation
class AloxideEnv{
    static func readEnv() -> [String: Any] {
        do {
            if let file = Bundle.main.url(forResource: "env", withExtension: "json") {
                let data = try Data(contentsOf: file)
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                if let object = json as? [String: Any] {
                    // json is a dictionary
                    return object
                } else if let object = json as? [Any] {
                    // json is an array
                    print(object)
                } else {
                    print("JSON is invalid")
                }
            } else {
                print("no file")
            }
        } catch {
            print(error.localizedDescription)
        }
        
        return [:]
    }
}
