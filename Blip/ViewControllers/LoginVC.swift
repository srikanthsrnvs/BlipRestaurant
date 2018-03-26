//
//  LoginVC.swift
//  Blip
//
//  Created by Gbenga Ayobami on 2018-03-07.
//  Copyright © 2018 Blip Groceries. All rights reserved.
//

import UIKit
import Material

class LoginVC: UIViewController {

    @IBOutlet weak var emailTF: TextField!
    @IBOutlet weak var passwordTF: TextField!
    @IBOutlet weak var loginButton: UIButton!
    
    //Singleton Service call instance
    let service = ServiceCalls.instance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareTextFields()
        self.loginButton.addTarget(self, action: #selector(loginPressed), for: .touchUpInside)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func loginPressed(){
        //Checking if there are empty fields
        let empty = (self.emailTF.text?.isEmpty)! || (self.passwordTF.text?.isEmpty)!
        if !(empty){
            //Both email and password textfields are filled
            //Try to Sign them in
            service.loginUser(email: emailTF.text!, password: passwordTF.text!, completion: { (errMsg, user) in
                if errMsg != nil{
                    print(errMsg!)
                }else{
                    //Signed in successfully
                }
            })
        }else{
            //One or more fields are empty
            return
        }
    }
    
    func prepareTextFields(){
        
        self.emailTF.placeholderLabel.font = UIFont(name: "CenturyGothic", size: 17)
        self.emailTF.font = UIFont(name: "Century Gothic", size: 17)
        self.emailTF.textColor = Color.white
        self.emailTF.placeholder = "Email"
        self.emailTF.placeholderActiveColor = Color.white
        self.emailTF.placeholderNormalColor = Color.white
        self.passwordTF.placeholderLabel.font = UIFont(name: "CenturyGothic", size: 17)
        self.passwordTF.font = UIFont(name: "Century Gothic", size: 17)
        self.passwordTF.textColor = Color.white
        self.passwordTF.placeholder = "Password"
        self.passwordTF.placeholderActiveColor = Color.white
        self.passwordTF.placeholderNormalColor = Color.white
    }

}
