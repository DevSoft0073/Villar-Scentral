//
//  EditProfileVC.swift
//  Villar Scentral
//
//  Created by Vivek Dharmani on 07/12/20.
//

import UIKit

class EditProfileVC: UIViewController {

    @IBOutlet weak var bioTXtView: UITextView!
    @IBOutlet weak var addressBottamLbl: UILabel!
    @IBOutlet weak var emailBottamLbl: UILabel!
    @IBOutlet weak var addressLbl: UITextField!
    @IBOutlet weak var emailLbl: UITextField!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    
    var imagePicker: ImagePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.imagePicker = ImagePicker(presentationController: self, delegate: self)
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        profileImage.layer.masksToBounds = true
        profileImage.layer.cornerRadius = profileImage.frame.height/2
    }
    
    @IBAction func backButton(_ sender: Any) {
//        self.navigationController?.
    }
    
    @IBAction func doneButton(_ sender: Any) {
        let story = UIStoryboard(name: "SideMenu", bundle: nil)
        let rootViewController:UIViewController = story.instantiateViewController(withIdentifier: "SideMenuControllerID")
        self.navigationController?.pushViewController(rootViewController, animated: true)
    }
    
    
    @IBAction func addProfileImageButton(_ sender: UIButton) {
        
        self.imagePicker.present(from: sender)        
        
    }
}

extension EditProfileVC: ImagePickerDelegate {

    func didSelect(image: UIImage?) {
        self.profileImage.image = image
    }
}
