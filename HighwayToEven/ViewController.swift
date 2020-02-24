//
//  ViewController.swift
//  HighwayToEven
//
//  Created by Philippe Mercier on 23/02/2020.
//  Copyright © 2020 Philippe Mercier. All rights reserved.
//

import UIKit
import web3

class ViewController: UIViewController {

    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var balanceLabel: UILabel!
    @IBOutlet weak var accountLabel: UILabel!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var contractLabel: UILabel!
    @IBOutlet weak var contractBalanceLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.resultLabel.text = ""
        self.scoreLabel.text = "?"
        self.accountLabel.text = Session.instance.account?.address
        self.contractLabel.text = Config.contractAddress
        self.refreshBalances()
    }
    
    func refreshBalances()
    {
        // contract balance
        let smartContract = SmartContract()
                
        smartContract.getBalance() { error, balance in
            DispatchQueue.main.async {
                let balanceInEther : Double = Double(balance ?? 0) / 1_000_000_000 / 1_000_000_000 // wei -> gwei -> ether
                self.contractBalanceLabel.text = String(balanceInEther)
            }
        }
        
        // alternative way to retrieve the balance of the smart contract
//        Session.instance.client?.eth_getBalance(address: Config.contractAddress, block: .Latest){ error, balance in
//            DispatchQueue.main.async {
//                let balanceInEther : Double = Double(balance ?? 0) / 1_000_000_000 / 1_000_000_000 // wei -> gwei -> ether
//                self.contractBalanceLabel.text = String(balanceInEther)
//            }
//        }
        
        // account balance
        guard let account = Session.instance.account else {
            return
        }
        
        Session.instance.client?.eth_getBalance(address: account.address, block: .Latest){ error, balance in
            DispatchQueue.main.async {
                let balanceInEther : Double = Double(balance ?? 0) / 1_000_000_000 / 1_000_000_000 // wei -> gwei -> ether
                self.balanceLabel.text = String(balanceInEther)
            }
        }
    }
    
    @IBAction func play(_ sender: Any) {
        self.playButton.isHidden = true
        self.activityIndicator.startAnimating()
        self.activityIndicator.isHidden = false
        
        let smartContract = SmartContract()

        smartContract.playGame(){ (error, hash) in
            
            self.retry(20, task: { success, failure in smartContract.getEvents(hash, success: success, failure: failure) },
                success: { event in
                    if let e = event as? SmartContractEvents.Result {
                        DispatchQueue.main.async {
                            self.resultLabel.text = e.outcome.uppercased()
                            self.scoreLabel.text = String(e.numberGenerated)
                            self.activityIndicator.stopAnimating()
                            self.playButton.isHidden = false
                            self.refreshBalances()
                        }
                    }
                },
                failure: { error in
                    DispatchQueue.main.async {
                        self.resultLabel.text = "Error"
                        self.scoreLabel.text = "?"
                        self.activityIndicator.stopAnimating()
                        self.playButton.isHidden = false
                        self.refreshBalances()
                    }
                }
            )
        }
    }
    
}

extension ViewController {
    
    private func retry(_ attempts: Int, task: @escaping (_ success: @escaping (ABIEvent?) -> Void, _ failure: @escaping (Error?) -> Void) -> Void, success: @escaping (ABIEvent?) -> Void, failure: @escaping (Error?) -> Void) {
        
        sleep(3)
        
        task(
            { (event) in
                success(event)
            }
        )
        { (error) in
            print("Error retry left \(attempts)")
            
            if attempts > 1 {
                self.retry(attempts - 1, task: task, success: success, failure: failure)
            } else {
                failure(error)
            }
        }
    }
}
