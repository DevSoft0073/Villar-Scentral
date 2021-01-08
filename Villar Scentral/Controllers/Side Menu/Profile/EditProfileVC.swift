//
//  EditProfileVC.swift
//  Villar Scentral
//
//  Created by Vivek Dharmani on 07/12/20.
//

import UIKit
import SDWebImage
import SKCountryPicker

class EditProfileVC: UIViewController , UITextFieldDelegate ,UITextViewDelegate ,UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var countryButton: UIButton!
    @IBOutlet weak var flagImage: UIImageView!
    @IBOutlet weak var nameTxtFld: UITextField!
    @IBOutlet weak var bioTXtView: UITextView!
    @IBOutlet weak var addressBottamLbl: UILabel!
    @IBOutlet weak var emailBottamLbl: UILabel!
    @IBOutlet weak var addressLbl: UITextField!
    @IBOutlet weak var emailLbl: UITextField!
    @IBOutlet weak var profileImage: UIImageView!
    var message = String()
    var imagePicker: ImagePicker!
    var imagePickers = UIImagePickerController()
    var base64String = String()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.imagePicker = ImagePicker(presentationController: self, delegate: self)
        getData()
        guard let country = CountryManager.shared.currentCountry else {
            self.countryButton.setTitle("Pick Country", for: .normal)
            self.flagImage.isHidden = true
            return
        }

        countryButton.setTitle(country.dialingCode, for: .normal)
        flagImage.image = country.flag
        countryButton.clipsToBounds = true
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        profileImage.layer.masksToBounds = true
        profileImage.layer.cornerRadius = profileImage.frame.height/2
    }
    
    
    @IBAction func countryCodeButton(_ sender: Any) {
        
        let countryController = CountryPickerWithSectionViewController.presentController(on: self) { [weak self] (country: Country) in

           guard let self = self else { return }

           self.flagImage.image = country.flag
           self.countryButton.setTitle(country.dialingCode, for: .normal)

         }

         // can customize the countryPicker here e.g font and color
         countryController.detailColor = UIColor.red
    }
    
    @IBAction func backButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == emailLbl {
            emailBottamLbl.backgroundColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
            addressBottamLbl.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            
            
        } else if textField == addressLbl{
            emailBottamLbl.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            addressBottamLbl.backgroundColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        }
    }
    
    //MARK:-->    Upload Images
    
    func showActionSheet(){
        //Create the AlertController and add Its action like button in Actionsheet
        let actionSheetController: UIAlertController = UIAlertController(title: NSLocalizedString("Upload Image", comment: ""), message: nil, preferredStyle: .actionSheet)
        actionSheetController.view.tintColor = UIColor.black
        let cancelActionButton: UIAlertAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel) { action -> Void in
            print("Cancel")
        }
        actionSheetController.addAction(cancelActionButton)
        
        let saveActionButton: UIAlertAction = UIAlertAction(title: NSLocalizedString("Take Photo", comment: ""), style: .default)
        { action -> Void in
            self.openCamera()
        }
        actionSheetController.addAction(saveActionButton)
        
        let deleteActionButton: UIAlertAction = UIAlertAction(title: NSLocalizedString("Choose From Gallery", comment: ""), style: .default)
        { action -> Void in
            self.gallery()
        }
        actionSheetController.addAction(deleteActionButton)
        self.present(actionSheetController, animated: true, completion: nil)
    }
    
    func openCamera()
    {
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.camera))
        {
            imagePickers.delegate = self
            imagePickers.sourceType = UIImagePickerController.SourceType.camera
            imagePickers.allowsEditing = true
            self.present(imagePickers, animated: true, completion: nil)
        }
        else
        {
            let alert  = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func gallery()
    {
        
        let myPickerControllerGallery = UIImagePickerController()
        myPickerControllerGallery.delegate = self
        myPickerControllerGallery.sourceType = UIImagePickerController.SourceType.photoLibrary
        myPickerControllerGallery.allowsEditing = true
        self.present(myPickerControllerGallery, animated: true, completion: nil)
        
    }
    
    
    //MARK:- ***************  UIImagePickerController delegate Methods ****************
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        //        guard let image = info[UIImagePickerController.InfoKey.originalImage]
        guard let image = info[UIImagePickerController.InfoKey.editedImage]
            as? UIImage else {
                return
        }
        //        let imgData3 = image.jpegData(compressionQuality: 0.4)
        self.profileImage.contentMode = .scaleToFill
        self.profileImage.image = image
        guard let imgData3 = image.jpegData(compressionQuality: 0.2) else {return}
        base64String = imgData3.base64EncodedString(options: .lineLength64Characters)
        dismiss(animated: true, completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.imagePickers = UIImagePickerController()
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func doneButton(_ sender: Any) {
        
    }
    
    
    @IBAction func saveButton(_ sender: Any) {
        editProfile()
    }
    
    
    @IBAction func addProfileImageButton(_ sender: UIButton) {
        
        //        self.imagePicker.present(from: sender)
        showActionSheet()
        
    }
    
    func getData() {
        let id = UserDefaults.standard.value(forKey: "id") ?? ""
        if Reachability.isConnectedToNetwork() == true {
            print("Internet connection OK")
            IJProgressView.shared.showProgressView()
            let signInUrl = Constant.shared.baseUrl + Constant.shared.profile
            print(signInUrl)
            let parms : [String:Any] = ["user_id" : id]
            print(parms)
            AFWrapperClass.requestPOSTURL(signInUrl, params: parms, success: { (response) in
                IJProgressView.shared.hideProgressView()
                print(response)
                self.message = response["message"] as? String ?? ""
                let status = response["status"] as? Int
                if status == 1{
                    if let allData = response["user_details"] as? [String:Any]{
                        self.emailLbl.text = allData["email"] as? String ?? ""
                        self.addressLbl.text = allData["address"] as? String ?? ""
                        self.bioTXtView.text = allData["biography"] as? String ?? ""
                        self.nameTxtFld.text = allData["name"] as? String ?? ""
                        self.profileImage.sd_setImage(with: URL(string:allData["profile_image"] as? String ?? ""), placeholderImage: UIImage(named: "img"))
                        let url = URL(string:allData["profile_image"] as? String ?? "")
                        if url != nil{
                            if let data = try? Data(contentsOf: url!)
                            {
                                if let image: UIImage = (UIImage(data: data)){
                                    self.profileImage.image = image
                                    self.profileImage.contentMode = .scaleToFill
                                    IJProgressView.shared.hideProgressView()
                                }
                            }
                        }
                        else{
                            self.profileImage.image = UIImage(named: "img")
                        }
                    }
                }else{
                    IJProgressView.shared.hideProgressView()
                    alert(Constant.shared.appTitle, message: self.message, view: self)
                }
            }) { (error) in
                IJProgressView.shared.hideProgressView()
                alert(Constant.shared.appTitle, message: error.localizedDescription, view: self)
                print(error)
            }
            
        } else {
            print("Internet connection FAILED")
            alert(Constant.shared.appTitle, message: "Check internet connection", view: self)
        }
    }
    
    
    func editProfile() {
        let id = UserDefaults.standard.value(forKey: "id") ?? ""
        if Reachability.isConnectedToNetwork() == true {
            print("Internet connection OK")
            IJProgressView.shared.showProgressView()
            let url = Constant.shared.baseUrl + Constant.shared.EditProfile
            print(url)
            //            var base64String = String()
            //            base64String = UserDefaults.standard.value(forKey: "imag") as? String ?? ""
            
            let parms : [String:Any] = ["user_id": id,"email" : emailLbl.text ?? "","address" : addressLbl.text ?? "" ,"image" : self.base64String,"bio" : bioTXtView.text ?? "" ,"latitude" : "" , "longitude" : "" , "name":nameTxtFld.text ?? ""]
            print(parms)
            AFWrapperClass.requestPOSTURL(url, params: parms, success: { (response) in
                IJProgressView.shared.hideProgressView()
                self.message = response["message"] as? String ?? ""
                let status = response["status"] as? Int
                if status == 1{
                    if let allData = response["userDetails"] as? [String:Any] {
                        IJProgressView.shared.hideProgressView()
                    }
                    showAlertMessage(title: Constant.shared.appTitle, message: self.message, okButton: "Ok", controller: self) {
                        let story = UIStoryboard(name: "SideMenu", bundle: nil)
                        let rootViewController:UIViewController = story.instantiateViewController(withIdentifier: "SideMenuControllerID")
                        self.navigationController?.pushViewController(rootViewController, animated: true)
                    }
                }else{
                    IJProgressView.shared.hideProgressView()
                    alert(Constant.shared.appTitle, message: self.message, view: self)
                }
            }) { (error) in
                IJProgressView.shared.hideProgressView()
                alert(Constant.shared.appTitle, message: error.localizedDescription, view: self)
                print(error)
            }
            
        } else {
            print("Internet connection FAILED")
            alert(Constant.shared.appTitle, message: "Check internet connection", view: self)
        }
    }
}

extension EditProfileVC: ImagePickerDelegate {
    
    func didSelect(image: UIImage?) {
        self.profileImage.image = image
    }
}
