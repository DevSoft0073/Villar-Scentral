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
    let appTitle  = "Villar Scentral"
    let device_token = "1"
    let baseUrl = "https://www.dharmani.com/Scentral/WebServices/"
    
    let SignUP = "SignUp.php"
    let SignIN = "Login.php"
    let ForgotPassword = "ForgetPassword.php"
    let EditProfile = "EditUserProfile.php"
    let profile = "GetUserProfile.php"
    let allVideos = "GetVideoDetailById.php"
    let allProducts = "GetAllProduct.php"
    let addRemoveProduct = "AddRemoveProduct.php"
    let checkout = "Checkout.php"
    let orderHistory = "OrderHistory.php"
    let notification = "GetNotificationDetailById.php"
}
