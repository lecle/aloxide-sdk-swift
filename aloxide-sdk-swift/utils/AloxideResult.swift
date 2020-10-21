//
//  AloxideResult.swift
//  aloxide-sdk-swift
//
//  Created by quoc huynh on 10/20/20.
//

import Foundation
public enum AloxideResult<Success, Failure: Error> {
    /// The success return state.
    case success(Success)
    /// The failure return state.
    case failure(Failure)

    init?(success: Success?, failure: Failure?) {
        if let success = success {
            self = .success(success)
        } else if let failure = failure {
            self = .failure(failure)
        } else {
            return nil
        }
    }
}
