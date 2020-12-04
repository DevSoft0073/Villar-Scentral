//
//  Constant.swift
//  racinewalker
//
//  Created by Vivek Dharmani on 7/1/20.
//  Copyright © 2020 Vivek Dharmani. All rights reserved.
//

import Foundation

class Constant: NSObject {
    
    static let shared = Constant()
    let appTitle  = "Radar"
    
    let baseUrl = "https://www.dharmani.com/MasterGreatThoughts/WebServices/"
    
    
    let signIn = "Login.php"
    let forgotPassword = "ForgetPassword.php"
    let resetPassword = "ResetPassword.php"
    let contactUs = "ContactUs.php"
    let userData = "GetUserProfile.php"
    let addUserDetails = "AddEditUserProfile.php"
    let quotesData = "GetAllQuotes.php"
    let logout = "Logout.php"
    let CheckSubscriptionPlan = "CheckSubscriptionPlan.php"
    let SignUp = "SignUp.php"
}
