//
//  LoginVC.swift
//  Blip
//
//  Created by Gbenga Ayobami on 2018-03-07.
//  Copyright © 2018 Blip Groceries. All rights reserved.
//

import UIKit
import Material
import FBSDKLoginKit
import Firebase

class LoginVC: UIViewController {

    @IBOutlet weak var emailTF: TextField!
    @IBOutlet weak var passwordTF: TextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var fbLoginButton: FBSDKLoginButton!
    
    //Singleton Service call instance
    let service = ServiceCalls.instance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareTextFields()
        prepareFBLoginButton()
        self.loginButton.addTarget(self, action: #selector(loginPressed), for: .touchUpInside)
        // Do any additional setup after loading the view.
    }
    
    /// prepares the facebook button
    func prepareFBLoginButton(){
        self.fbLoginButton.delegate = self
        fbLoginButton.readPermissions = ["email","public_profile"]
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
                    //present a viewcontroller
                    let onboardvc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "OnboardingVC")
                    self.present(onboardvc, animated: true, completion: nil)
                    
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


extension LoginVC: FBSDKLoginButtonDelegate{
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if error != nil{
            print(error.localizedDescription)
            return
        }
        //Successfully logged in with FB
        showFBInfo()
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("Did log out of fb")
    }
    /**
     show facebook information
 */
    func showFBInfo(){
        guard let accessTokenString = FBSDKAccessToken.current().tokenString else{return}
        let credential = FacebookAuthProvider.credential(withAccessToken: accessTokenString)
        Auth.auth().signIn(with: credential) { (user, error) in
            if error != nil{
                print(error!.localizedDescription)
            }
        }
        FBSDKGraphRequest(graphPath: "/me", parameters: ["fields": "id, name, first_name, last_name, email, picture.type(large)"]).start { (connection, result, error) in
            if error != nil{
                print(error!.localizedDescription)
                return
            }
            guard let fbUserInfo = result as? [String:Any] else{return}
            let name = "\(fbUserInfo["first_name"] as! String) \(fbUserInfo["last_name"] as! String)"
            let email = fbUserInfo["email"] as! String
            self.service.addFBUserToDB(name: name, email: email)
            let onboardvc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "OnboardingVC")
            self.present(onboardvc, animated: true, completion: nil)
            
            //picture below
//            if let imageURL = ((fbUserInfo["picture"] as? [String: Any])?["data"] as? [String: Any])?["url"] as? String {
//                //Download image from imageURL
//                print(imageURL)
//            }
        }
    }
}
