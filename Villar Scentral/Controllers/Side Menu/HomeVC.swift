//
//  HomeVC.swift
//  Villar Scentral
//
//  Created by Vivek Dharmani on 09/12/20.
//

import UIKit
import LGSideMenuController
import MessageUI


class HomeVC: UIViewController ,MFMailComposeViewControllerDelegate
{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    @IBAction func requetRefillButtonAction(_ sender: Any) {
        let vc = OtherProductsVC.instantiate(fromAppStoryboard: .SideMenu)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @IBAction func openMenu(_ sender: Any) {
        sideMenuController?.showLeftViewAnimated()
    }
    
    
    @IBAction func aboutUsButtonAction(_ sender: Any) {
        
        let mailComposeViewController = configureMailComposer()
        if MFMailComposeViewController.canSendMail(){
            self.present(mailComposeViewController, animated: true, completion: nil)
        }else{
            print("Can't send email")
        }
        
    }
    
    func configureMailComposer() -> MFMailComposeViewController{
        let mailComposeVC = MFMailComposeViewController()
        mailComposeVC.mailComposeDelegate = self
        mailComposeVC.setToRecipients([""])
        mailComposeVC.setSubject("")
        mailComposeVC.setMessageBody("", isHTML: false)
        return mailComposeVC
    }
    
    
    // MARK: - MFMail compose method
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
}
