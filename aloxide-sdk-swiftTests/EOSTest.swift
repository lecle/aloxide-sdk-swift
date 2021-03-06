//
//  EOSTest.swift
//  aloxide-sdk-swift
//
//  Created by quoc huynh on 10/30/20.
//

import XCTest
@testable import aloxide_sdk_swift

class EOSTest: XCTestCase {
    
    func configEOS() -> Aloxide {
        
        let env: [String: Any] = [
            "app_blockchain_name":"jungle3",
            "app_blockchain_type":"eos",
            "app_blockchain_host":"jungle3.cryptolions.io",
            "app_blockchain_url":"https://jungle3.cryptolions.io",
            "app_blockchain_chainId":"e70aaab8997e1dfce58fbfac80cbbb8fecec7b99cf982a9444273cbc64c41473",
            "app_blockchain_account":"aloxidejs123",
            "app_blockchain_account_pk":"5JHQ3GuzcQtEQgG3SGvtDU7v2b7ioKznYBizA1V5mBUUsLNcXdQ",
            "app_blockchain_contract":"aloxidejs123"
        ]
        
        let accountName = env["app_blockchain_account"] as! String
        let privateKey = env["app_blockchain_account_pk"] as! String
        let url = env["app_blockchain_url"] as! String
        let contract = env["app_blockchain_contract"] as! String
        
        let  eosAccount = BlockchainAccountBuilder()
            .setName(name: accountName)
            .setPrivateKey(privateKey: privateKey)
            .build()
        
        let eosBuilder = AloxideBuilder.newBuilder()
            .setNetwork(network: Network.EOS)
            .setContract(contract: contract)
            .setUrl(url: url)
            .setEntityName(entityName: "Poll")
            .setBlockchainAccount(blockchainAccount: eosAccount)
            .build()
        
        return eosBuilder
    }
    
    func testGet() throws {
        let aloxide = configEOS()
        let expectation = self.expectation(description: "wait")
        
        let id = "111" /* NEED TO CHANGE */
        
        aloxide.get(id: id) { res in
            switch res{
            case .success(let res):
                AloxideLogger.printSuccess(["Result: \(res)"])
                expectation.fulfill()
            case .failure(let e):
                AloxideLogger.printError("Get data error \(String(describing: e.message!))")
                expectation.fulfill()
            }
        }
        waitForExpectations(timeout: 600, handler: nil)
    }
    
    func testWrite() throws {
        let aloxide = configEOS()
        let expectation = self.expectation(description: "wait")
        
        let data = ["id":"32302" /* NEED TO CHANGE */
                    ,"name":"2010name" /* NEED TO CHANGE */
                    ,"body":"2010body"] /* NEED TO CHANGE */
        
        aloxide.add(params: data) { res in
            switch res{
            case .success(let res):
                AloxideLogger.printSuccess(["Result: \(res)","To verify: \(AloxideLogger.getTransactionUrl(res, Network.EOS, (aloxide.aloxideData?.url)!))"])
                expectation.fulfill()
            case .failure(let e):
                AloxideLogger.printError("Get data error \(String(describing: e.message!))")
                expectation.fulfill()
            }
        }
        waitForExpectations(timeout: 600, handler: nil)
    }
    
    func testDelete() throws {
        let aloxide = configEOS()
        let expectation = self.expectation(description: "wait")
        
        let id = "2020" /* NEED TO CHANGE */
        
        aloxide.delete(id: id){ res in
            switch res{
            case .success(let res):
                AloxideLogger.printSuccess(["Result: \(res)","To verify: \(AloxideLogger.getTransactionUrl(res, Network.EOS, (aloxide.aloxideData?.url)!))"])
                expectation.fulfill()
            case .failure(let e):
                AloxideLogger.printError("Get data error \(String(describing: e.message!))")
                expectation.fulfill()
            }
        }
        waitForExpectations(timeout: 600, handler: nil)
    }
    
    func testUpdate() throws {
        let aloxide = configEOS()
        let expectation = self.expectation(description: "wait")
        
        let data = ["name":"2010name Updated" /* NEED TO CHANGE */
                    ,"body":"2010body Updated"] /* NEED TO CHANGE */
        let id = "2020" /* NEED TO CHANGE */
        
        aloxide.update(id: id,params: data){ res in
            switch res{
            case .success(let res):
                AloxideLogger.printSuccess(["Result: \(res)","To verify: \(AloxideLogger.getTransactionUrl(res, Network.EOS, (aloxide.aloxideData?.url)!))"])
                expectation.fulfill()
            case .failure(let e):
                AloxideLogger.printError("Get data error \(String(describing: e.message!))")
                expectation.fulfill()
            }
        }
        waitForExpectations(timeout: 600, handler: nil)
    }
    
    
}
