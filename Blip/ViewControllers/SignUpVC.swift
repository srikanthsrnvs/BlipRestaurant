//
//  SignUpVC.swift
//  Blip
//
//  Created by Gbenga Ayobami on 2018-03-07.
//  Copyright © 2018 Blip Groceries. All rights reserved.
//

import UIKit
import Firebase

class SignUpVC: UIViewController {

    @IBOutlet weak var firstNameTF: UITextField!
    @IBOutlet weak var lastNameTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var confirmPasswordTF: UITextField!
    @IBOutlet weak var phoneNumberTF: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    //Singleton Service call instance
    let service = ServiceCalls.instance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        signUpButton.addTarget(self, action: #selector(signUpPressed), for: .touchUpInside)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @objc func signUpPressed(){
        //Checking if the text fields are empty
        let empty = (firstNameTF.text?.isEmpty)! || (lastNameTF.text?.isEmpty)! || (emailTF.text?.isEmpty)! || (passwordTF.text?.isEmpty)! || (confirmPasswordTF.text?.isEmpty)! || (phoneNumberTF.text?.isEmpty)!
        
        if !(empty){
            //All textfields are filled
            service.createUser(email: emailTF.text!, password: passwordTF.text!, completion: { (errMsg, user) in
                if errMsg != nil{
                    //Some type of error occured while creating user
                    print(errMsg!)
                }else{
                    //Created User successfully
                    //Add to Firebase Database
                    self.service.addUserToDB(firstName: self.firstNameTF.text!, lastName: self.lastNameTF.text!, email: self.emailTF.text!, phoneNumber: self.phoneNumberTF.text!)
                }
            })
        }else{
            // One or more of the textfields are empty
            // Let User know they have to empty fields to fill up
            return
        }
    }
    
    
    

}
