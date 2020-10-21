//
//  ICONNetwork.swift
//  aloxide-sdk-swift
//
//  Created by quoc huynh on 10/19/20.
//

import Foundation
import ICONKit
import BigInt

class ICONNetwork: BlockchainNetwork{
    
    private var iconService: ICONService
    private var entityName: String
    private var contract: String
    private var account: BlockchainAccount
    private var nId: Int = 3
    
    var ee: AloxideExceptions?
    var rr: Bool?
    
    init(entityName: String, account: BlockchainAccount, contract: String, url: String, networkId: Int) {
        self.iconService = ICONService(provider: url, nid: "0x\(networkId)")
        self.account = account
        self.contract = contract
        self.entityName = entityName.lowercased()
        self.nId = networkId
    }
    
    func get(id: Any, completion: @escaping (AloxideResult<String, AloxideExceptions>) -> Void) {
        let methodName = "get"+self.entityName
        let isValid = self.validate()
        if !isValid {
            completion(AloxideResult(success: nil, failure: AloxideExceptions(code: -1, message:"Invalid when get record"))!)
        }
        
        let call = Call<String>(from: self.account.address!, to: self.contract, method: methodName, params: ["id": id])
        
        let request: Request<String> = iconService.call(call)
        let response: Result<String, ICError> = request.execute()
        var ee: AloxideExceptions?
        var rr: String?
        switch response {
        
        case .success(let res):
            if (res.isEmpty) {
                completion(AloxideResult(success:rr , failure:AloxideExceptions(code: -1, message: "Not found"))!)
                break
            }
            rr = res
            completion(AloxideResult(success: rr, failure: ee)!)
            break
        case .failure(let error):
            ee = AloxideExceptions(code: -1, message: error.localizedDescription)
            completion(AloxideResult(success: nil, failure: ee)!)
            break
        }
    }
    
    func get(id: Any) -> Any? {
        let methodName = "get"+self.entityName
        let isValid = self.validate()
        if !isValid {
            return nil
        }
        
        let call = Call<String>(from: self.account.address!, to: self.contract, method: methodName, params: ["id": id])
        
        let request: Request<String> = iconService.call(call)
        let response: Result<String, ICError> = request.execute()
        switch response {
        case .success(let res):
            return res
            
        case .failure(let error):
            print("[AloxideSwift::ICON::GetRecord]::ERROR: \(String(describing: error.failureReason))")
            return nil
        }
    }
    
    func add(params: Any,completion: @escaping (AloxideResult<Bool, AloxideExceptions>) -> Void)  {
        let methodName = "cre"+self.entityName
        let isValid = self.validate()
        if !isValid {
            ee = AloxideExceptions(code: -1, message: "Invalid")
            completion(AloxideResult(success:rr , failure:ee)!)
            return
        }
        self.sendTransaction(methodName: methodName, params: params as! Dictionary<String, Any>,completion: completion)
    }
    
    func update(id: String, params: Any,completion: @escaping (AloxideResult<Bool, AloxideExceptions>) -> Void)  {
        let methodName = "upd"+self.entityName
        let isValid = self.validate()
        if !isValid {
            ee = AloxideExceptions(code: -1, message: "Invalid")
            completion(AloxideResult(success:rr , failure:ee)!)
            return
        }
        self.sendTransaction(methodName: methodName, params: params as! Dictionary<String, Any>,completion: completion)
        
    }
    
    func delete(id: String,completion: @escaping (AloxideResult<Bool, AloxideExceptions>) -> Void)  {
        let methodName = "del"+self.entityName
        let isValid = self.validate()
        if !isValid {
            ee = AloxideExceptions(code: -1, message: "Invalid")
            completion(AloxideResult(success:rr , failure:ee)!)
            return
        }
        self.sendTransaction(methodName: methodName, params: ["id": id],completion: completion)
    }
    
    /**
     * Validation in ICON Network like: check the method name exist or not in SCORE,...
     *
     * @return
     */
    func validate() -> Bool {
        return true
    }
    
    func sendTransaction(methodName: String, params: Dictionary<String, Any>,completion: @escaping (AloxideResult<Bool, AloxideExceptions>) -> Void) {
        var eee: AloxideExceptions?
        var rrr: Bool?
        if self.account.privateKey == nil {
            eee = AloxideExceptions(code: -1, message: "Please provide the private key")
            completion(AloxideResult(success:rrr , failure:eee)!)
            return
        }
        
        
        // SCORE function call
        let call = CallTransaction()
            .to(self.contract)
            .from(self.account.address!)
            .stepLimit(BigUInt(1000000))
            .nid(self.iconService.nid)
            .nonce("0x1")
            .method(methodName)
            .params(params)
        do{
            let privateKey = PrivateKey(hex: Data(hexString: self.account.privateKey!)!)
            
            let signed = try SignedTransaction(
                transaction: call, privateKey:privateKey)
            let request = iconService.sendTransaction(signedTransaction: signed)
            let result = request.execute()
            
            switch result {
            case .success( _):
                completion(AloxideResult(success:true , failure:eee)!)
            case .failure( let e):
                print("[AloxideSwift::ICON::SendTransaction]::ERROR: \(String(describing: e.failureReason))")
                eee = AloxideExceptions(code: -1, message: e.localizedDescription)
                completion(AloxideResult(success:rrr , failure:eee)!)
            }
        }catch{
            print("[AloxideSwift::ICON::SendTransaction]::ERROR: \(String(describing: error.localizedDescription))")
            eee = AloxideExceptions(code: -1, message: error.localizedDescription)
            completion(AloxideResult(success:rrr , failure:eee)!)
        }
    }
}
