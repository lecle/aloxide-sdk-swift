//
//  aloxide_sdk_swiftTests.swift
//  aloxide-sdk-swiftTests
//
//  Created by quoc huynh on 10/19/20.
//

import XCTest
@testable import aloxide_sdk_swift

class CANTest: XCTestCase {
    
    func configCAN() -> Aloxide {
        
        let env: [String: Any] = [
            "app_blockchain_name":"CAN Testnet",
            "app_blockchain_type":"can",
            "app_blockchain_host":"testnet.canfoundation.io",
            "app_blockchain_url":"https://testnet.canfoundation.io",
            "app_blockchain_chainId":"353c0a7c6744e58778a2a334d1da2303eb12a111cc636bb494e63a84c9e7ffeb",
            "app_blockchain_account":"aloxidejs123",
            "app_blockchain_account_pk":"5JHQ3GuzcQtEQgG3SGvtDU7v2b7ioKznYBizA1V5mBUUsLNcXdQ",
            "app_blockchain_contract":"aloxidejs123"
        ]
        
        let accountName = env["app_blockchain_account"] as! String
        let privateKey = env["app_blockchain_account_pk"] as! String
        let url = env["app_blockchain_url"] as! String
        let contract = env["app_blockchain_contract"] as! String
        
        let  canAccount = BlockchainAccountBuilder()
            .setName(name: accountName)
            .setPrivateKey(privateKey: privateKey)
            .build()
        
        let eosBuilder = AloxideBuilder.newBuilder()
            .setNetwork(network: Network.EOS)
            .setContract(contract: contract)
            .setUrl(url: url)
            .setEntityName(entityName: "Poll")
            .setBlockchainAccount(blockchainAccount: canAccount)
            .build()
        
        return eosBuilder
    }
    
    func testGet() throws {
        let aloxide = configCAN()
        let expectation = self.expectation(description: "wait")
        
        let id = "111" /* NEED TO CHANGE */
        
        aloxide.get(id: id) { res in
            switch res{
            case .success(let res):
                AloxideLogger.printSuccess(["Result: \(res)"])
                expectation.fulfill()
            case .failure(let e):
                AloxideLogger.printError("Get data error \(String(describing: e.message))")
                expectation.fulfill()
            }
        }
        waitForExpectations(timeout: 600, handler: nil)
    }
    
    func testWrite() throws {
        let aloxide = configCAN()
        let expectation = self.expectation(description: "wait")
        
        let data = ["id":"32302" /* NEED TO CHANGE */
                    ,"name":"2010name" /* NEED TO CHANGE */
                    ,"body":"2010body"] /* NEED TO CHANGE */
        
        aloxide.add(params: data) { res in
            switch res{
            case .success(let res):
                AloxideLogger.printSuccess(["Result: \(res)","To verify: \(AloxideLogger.getTransactionUrl(res, Network.CAN, (aloxide.aloxideData?.url)!))"])
                expectation.fulfill()
            case .failure(let e):
                AloxideLogger.printError("Get data error \(String(describing: e.message))")
                expectation.fulfill()
            }
        }
        waitForExpectations(timeout: 600, handler: nil)
    }
    
    func testDelete() throws {
        let aloxide = configCAN()
        let expectation = self.expectation(description: "wait")
        
        let id = "2020" /* NEED TO CHANGE */
        
        aloxide.delete(id: id){ res in
            switch res{
            case .success(let res):
                AloxideLogger.printSuccess(["Result: \(res)","To verify: \(AloxideLogger.getTransactionUrl(res, Network.CAN, (aloxide.aloxideData?.url)!))"])
                expectation.fulfill()
            case .failure(let e):
                AloxideLogger.printError("Get data error \(String(describing: e.message))")
                expectation.fulfill()
            }
        }
        waitForExpectations(timeout: 600, handler: nil)
    }
    
    func testUpdate() throws {
        let aloxide = configCAN()
        let expectation = self.expectation(description: "wait")
        
        let data = ["name":"2010name Updated" /* NEED TO CHANGE */
                    ,"body":"2010body Updated"] /* NEED TO CHANGE */
        let id = "2020" /* NEED TO CHANGE */
        
        aloxide.update(id: id,params: data){ res in
            switch res{
            case .success(let res):
                AloxideLogger.printSuccess(["Result: \(res)","To verify: \(AloxideLogger.getTransactionUrl(res, Network.CAN, (aloxide.aloxideData?.url)!))"])
                expectation.fulfill()
            case .failure(let e):
                AloxideLogger.printError("Get data error \(String(describing: e.message))")
                expectation.fulfill()
            }
        }
        waitForExpectations(timeout: 600, handler: nil)
    }
    
    
}
