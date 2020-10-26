//
//  aloxide_sdk_swiftTests.swift
//  aloxide-sdk-swiftTests
//
//  Created by quoc huynh on 10/19/20.
//

import XCTest
@testable import aloxide_sdk_swift

class EOSTest: XCTestCase {
    
    func configEOS() -> Aloxide {
        let  eosAccount = BlockchainAccountBuilder()
            .setName(name: "aloxidejs123")
            .setPrivateKey(privateKey: "5JHQ3GuzcQtEQgG3SGvtDU7v2b7ioKznYBizA1V5mBUUsLNcXdQ")
            .build()
        
        let eosBuilder = AloxideBuilder.newBuilder()
            .setNetwork(network: Network.EOS)
            .setContract(contract: "aloxidejs123")
            .setUrl(url: "https://testnet.canfoundation.io")
            .setEntityName(entityName: "Poll")
            .setBlockchainAccount(blockchainAccount: eosAccount)
            .build()
        return eosBuilder
    }
    
    func testGet() throws {
        let aloxide = configEOS()
        let expectation = self.expectation(description: "wait")

        aloxide.get(id: "111") { res in
            switch res{
            case .success(let res):
                self.printSuccess(res)
                expectation.fulfill()
            case .failure(let e):
                self.printError("Get data error \(String(describing: e.message))")
                expectation.fulfill()
            }
        }
        waitForExpectations(timeout: 600, handler: nil)
    }
    
    func testWrite() throws {
        let aloxide = configEOS()
        let expectation = self.expectation(description: "wait")

        aloxide.add(params: ["id":"203330","name":"2010name","body":"2010body"]) { res in
            switch res{
            case .success(let res):
                self.printSuccess("Result: \(res)")
                expectation.fulfill()
            case .failure(let e):
                self.printError("Get data error \(String(describing: e.message))")
                expectation.fulfill()
            }
        }
        waitForExpectations(timeout: 600, handler: nil)

    }
    func printError(_ error: String)  {
        print("\n\n\n\n========================= ERROR HAPPEN =========================\n\n")
        print(error)
        print("\n\n====================================================================\n\n")
    }
    
    func printSuccess(_ res: String)  {
        print("\n\n\n\n========================= YOUR RESULT HERE =========================\n\n")
        print(res)
        print("\n\n====================================================================\n\n")
    }
    
    func testDelete() throws {
        let aloxide = configEOS()
        let expectation = self.expectation(description: "wait")

        aloxide.delete(id: "2020"){ res in
            switch res{
            case .success(let res):
                self.printSuccess("Result: \(res)")
                expectation.fulfill()
            case .failure(let e):
                self.printError("Get data error \(String(describing: e.message))")
                expectation.fulfill()
            }
        }
        waitForExpectations(timeout: 600, handler: nil)
    }
    
    func testUpdate() throws {
        let aloxide = configEOS()
        let expectation = self.expectation(description: "wait")

        aloxide.update(id: "2020",params: ["id":"2020","name":"2010name updated","body":"2010body updated"]){ res in
            switch res{
            case .success(let res):
                self.printSuccess("Result: \(res)")
                expectation.fulfill()
            case .failure(let e):
                self.printError("Get data error \(String(describing: e.message))")
                expectation.fulfill()
            }
        }
        waitForExpectations(timeout: 600, handler: nil)
    }
    
}
