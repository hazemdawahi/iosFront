//
//  PaymentViewController.swift
//  ELearningProjectAbderrahmen&hazem
//
//  Created by Mac-Mini-2021 on 3/12/2021.
//


import UIKit
import Braintree

class PaymentViewController: UIViewController {
    
    
    
    var braintreeClient: BTAPIClient!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        braintreeClient = BTAPIClient(authorization: "sandbox_5rd684br_jv9yj4zkfzwvcvhd")
        
    }
    
    @IBAction func pay1000(_ sender: Any) {
        let alertController = UIAlertController(title: "payment", message: "You are going to pay 300 USD", preferredStyle: .alert)
        
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
            
            self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
            
            
            
        }
        alertController.addAction(OKAction)
        
        self.present(alertController, animated: true, completion:nil)
        
        
        let payPalDriver = BTPayPalDriver(apiClient: braintreeClient)
        payPalDriver.viewControllerPresentingDelegate = self
        payPalDriver.appSwitchDelegate = self // Optional
        
        let request = BTPayPalRequest(amount: "300")
        request.currencyCode = "USD" // Optional; see BTPayPalRequest.h for more options
        
        payPalDriver.requestOneTimePayment(request) { (tokenizedPayPalAccount, error) in
            if let tokenizedPayPalAccount = tokenizedPayPalAccount {
                print("Got a nonce: \(tokenizedPayPalAccount.nonce)")
                
                // Access additional information
                debugPrint("Payment successfull")
                UserService.shareinstance.updateStats(isLevelingUp: false, resetProgress: false, score: 0, starsGained: 0, forLevel: 0, vieAddition: 1000) { success, user in
                    
                }
                
                self.navigationController?.popToRootViewController(animated: true)
                
                
                
                
                
                let email = tokenizedPayPalAccount.email
                //debugPrint(email)
                let firstName = tokenizedPayPalAccount.firstName
                //debugPrint(firstName)
                
                let lastName = tokenizedPayPalAccount.lastName
                //debugPrint(lastName)
                
                let phone = tokenizedPayPalAccount.phone
                //debugPrint(phone)
                
                
                // See BTPostalAddress.h for details
                let billingAddress = tokenizedPayPalAccount.billingAddress
                //debugPrint(billingAddress)
                
                let shippingAddress = tokenizedPayPalAccount.shippingAddress
                //debugPrint(shippingAddress)
                
            } else if let error = error {
                // Handle error here...
            } else {
                // Buyer canceled payment approval
            }
        }
    }
    
    @IBAction func pay100(_ sender: Any) {
        let alertController = UIAlertController(title: "payment", message: "You are going to pay 30 USD", preferredStyle: .alert)
        
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
            
            self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
            
            
            
        }
        alertController.addAction(OKAction)
        
        self.present(alertController, animated: true, completion:nil)
        
        
        let payPalDriver = BTPayPalDriver(apiClient: braintreeClient)
        payPalDriver.viewControllerPresentingDelegate = self
        payPalDriver.appSwitchDelegate = self // Optional
        
        let request = BTPayPalRequest(amount: "30")
        request.currencyCode = "USD" // Optional; see BTPayPalRequest.h for more options
        
        payPalDriver.requestOneTimePayment(request) { (tokenizedPayPalAccount, error) in
            if let tokenizedPayPalAccount = tokenizedPayPalAccount {
                print("Got a nonce: \(tokenizedPayPalAccount.nonce)")
                
                // Access additional information
                debugPrint("Payment successfull")
                UserService.shareinstance.updateStats(isLevelingUp: false, resetProgress: false, score: 0, starsGained: 0, forLevel: 0, vieAddition: 100) { success, user in
                    
                }
                
                self.navigationController?.popToRootViewController(animated: true)
                
                
                let email = tokenizedPayPalAccount.email
                //debugPrint(email)
                let firstName = tokenizedPayPalAccount.firstName
                //debugPrint(firstName)
                
                let lastName = tokenizedPayPalAccount.lastName
                //debugPrint(lastName)
                
                let phone = tokenizedPayPalAccount.phone
                //debugPrint(phone)
                
                
                // See BTPostalAddress.h for details
                let billingAddress = tokenizedPayPalAccount.billingAddress
                //debugPrint(billingAddress)
                
                let shippingAddress = tokenizedPayPalAccount.shippingAddress
                //debugPrint(shippingAddress)
                
            } else if let error = error {
                // Handle error here...
            } else {
                // Buyer canceled payment approval
            }
        }
    }
    
    @IBAction func PayAction(_ sender: Any) {
        let alertController = UIAlertController(title: "payment", message: "You are going to pay 3 USD", preferredStyle: .alert)
        
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
            
            self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
            
            
            
        }
        alertController.addAction(OKAction)
        
        self.present(alertController, animated: true, completion:nil)
        
        
        let payPalDriver = BTPayPalDriver(apiClient: braintreeClient)
        payPalDriver.viewControllerPresentingDelegate = self
        payPalDriver.appSwitchDelegate = self // Optional
        
        let request = BTPayPalRequest(amount: "3")
        request.currencyCode = "USD" // Optional; see BTPayPalRequest.h for more options
        
        payPalDriver.requestOneTimePayment(request) { (tokenizedPayPalAccount, error) in
            if let tokenizedPayPalAccount = tokenizedPayPalAccount {
                print("Got a nonce: \(tokenizedPayPalAccount.nonce)")
                
                // Access additional information
                debugPrint("Payment successfull")
                UserService.shareinstance.updateStats(isLevelingUp: false, resetProgress: false, score: 0, starsGained: 0, forLevel: 0, vieAddition: 10) { success, user in
                    
                }
                
                self.navigationController?.popToRootViewController(animated: true)
                
                
                
                
                let email = tokenizedPayPalAccount.email
                //debugPrint(email)
                let firstName = tokenizedPayPalAccount.firstName
                //debugPrint(firstName)
                
                let lastName = tokenizedPayPalAccount.lastName
                //debugPrint(lastName)
                
                let phone = tokenizedPayPalAccount.phone
                //debugPrint(phone)
                
                
                // See BTPostalAddress.h for details
                let billingAddress = tokenizedPayPalAccount.billingAddress
                //debugPrint(billingAddress)
                
                let shippingAddress = tokenizedPayPalAccount.shippingAddress
                //debugPrint(shippingAddress)
                
            } else if let error = error {
                // Handle error here...
            } else {
                // Buyer canceled payment approval
            }
        }
    }
}



extension PaymentViewController : BTViewControllerPresentingDelegate{
    func paymentDriver(_ driver: Any, requestsPresentationOf viewController: UIViewController) {
        
    }
    
    func paymentDriver(_ driver: Any, requestsDismissalOf viewController: UIViewController) {
        
    }
    
    
}

extension PaymentViewController : BTAppSwitchDelegate {
    func appSwitcherWillPerformAppSwitch(_ appSwitcher: Any) {
        
    }
    
    func appSwitcher(_ appSwitcher: Any, didPerformSwitchTo target: BTAppSwitchTarget) {
        
    }
    
    func appSwitcherWillProcessPaymentInfo(_ appSwitcher: Any) {
        
    }
    
}
