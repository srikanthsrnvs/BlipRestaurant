//
//  ServiceCalls.swift
//  Blip
//
//  Created by Gbenga Ayobami on 2018-03-08.
//  Copyright © 2018 Blip Groceries. All rights reserved.
//

import Foundation
import Firebase

typealias CreateUserCompletion = (_ errorMsg: String?, _ data: AnyObject?) ->Void

/*
    Singleton Class that interacts with Firebase Services
 */

class ServiceCalls{
    
    private static let _instance = ServiceCalls()
    private let NORMAL_USER_REFERENCE_STRING = "BlipUsers"
    //makes it only a get value so that no hacker could set its value to something else lol
    static var instance: ServiceCalls{
        return _instance
    }
    
/*
     Create User in Firebase Authentication
*/
    func createUser(email: String, password:String, completion: CreateUserCompletion?){
        Auth.auth().createUser(withEmail: email, password: password, completion: { (user, error) in
            if error != nil{
                //Handling Firebase Errors
                self.handleFirebaseError(error: (error as NSError?)!, completion: completion)
            }else{
                //No errors
                //Do whatever is needed
                completion?(nil, user)
            }
        })
    }
    
/*
    Adds the user's infomation to Firebase Database
*/
    func addUserToDB(firstName: String, lastName: String, email: String, phoneNumber: String){
        let dbRef: DatabaseReference = Database.database().reference()
        let emailHash = MD5(string: email)
        let userValueDict = ["name":"\(firstName) \(lastName)", "email":email, "phoneNumber":phoneNumber]
        dbRef.child(NORMAL_USER_REFERENCE_STRING).child(emailHash).updateChildValues(userValueDict)
    }
    
/*
     Sign in the user with specified email and password
*/
    func loginUser(email:String, password:String, completion:CreateUserCompletion?){
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if error != nil{
                //Some error occurred while trying to sign in user
                //handle error
                self.handleFirebaseError(error: (error as NSError?)!, completion: completion)
            }else{
                //No errors
                //Do whatever is needed
                completion?(nil, user)
            }
        }
    }
    
/*
    Handles all Firebase Errors
*/
    func handleFirebaseError(error: NSError, completion: CreateUserCompletion?){
        print(error.localizedDescription)
        if let errorCode = AuthErrorCode(rawValue: error.code){
            switch (errorCode){
            case .invalidEmail:
                completion?("Invalid Email", nil)
                break
            case .emailAlreadyInUse:
                completion?("Email Already In Use", nil)
                break
            case .operationNotAllowed:
                completion?("Accounts Are Not Enabled: Enable In Console", nil)
                break
            case .userDisabled:
                completion?("Account Has Been Disabled", nil)
                break
            case .wrongPassword:
                completion?("Incorrect Password", nil)
                break
            case .weakPassword:
                completion?("Password is weak", nil)
                break
            default:
                completion?("There Was An Issue Authenticating, Try Again", nil)
            }
        }
    }


/*
    Hash function
*/
    func MD5(string: String) -> String {
        let messageData = string.data(using:.utf8)!
        var digestData = Data(count: Int(CC_MD5_DIGEST_LENGTH))
        _ = digestData.withUnsafeMutableBytes {digestBytes in
            messageData.withUnsafeBytes {messageBytes in
                CC_MD5(messageBytes, CC_LONG(messageData.count), digestBytes)
            }
        }
        return digestData.map { String(format: "%02hhx", $0) }.joined()
    }
}
