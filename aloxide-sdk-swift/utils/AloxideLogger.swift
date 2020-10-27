//
//  AloxideLogger.swift
//  aloxide-sdk-swift
//
//  Created by quoc huynh on 10/27/20.
//

import Foundation


class AloxideLogger{
    static  func printError(_ error: String)  {
        print("\n\n\n\n========================= ERROR HAPPEN =========================\n\n")
        print(error)
        print("\n\n====================================================================\n\n")
    }
    
    static  func getTransactionUrl(_ transactionId: String, _ network: Network, _ host: String)-> String{
        var output = ""
        var newHost = host
       
        if network == Network.EOS {
            if host.contains("https://"){
                newHost = host.replacingOccurrences(of: "https://", with: "")
            }
            output = "https://local.bloks.io/transaction/" + transactionId + "?nodeUrl=history." + newHost;
        } else {
            if host.contains(".net"){
                newHost = host.replacingOccurrences(of: ".net", with: ".tracker")
                newHost = newHost.replacingOccurrences(of: "/api/v3", with: "")
            }
            output = newHost + "/transaction/" + transactionId;
        }
        return output
    }
    
    static func printSuccess(_ res: [String])  {
        print("\n\n\n\n========================= YOUR RESULT HERE =========================\n\n")
        res.forEach { (res) in
            print(res)
            print("\n")
        }
        
        print("====================================================================\n\n")
    }
    
}
