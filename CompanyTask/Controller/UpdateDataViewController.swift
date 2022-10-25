//
//  UpdateDataViewController.swift
//  CompanyTask
//
//  Created by My Mac on 13/09/22.
//

import UIKit


class UpdateDataViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {

    @IBOutlet weak var txtId: UITextField!
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtGender: UITextField!
    @IBOutlet weak var txtStatus: UITextField!
    @IBOutlet weak var updateBtn: UIButton!
    
    var details : APIModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        txtId.text = String(details?.id ?? 12)
        txtName.text = details?.name
        txtEmail.text = details?.email
        txtGender.text = details?.gender
        txtStatus.text = details?.status
        
        navigationItem.title = "Details"
        updateBtn.layer.cornerRadius = 15
        updateBtn.layer.masksToBounds = true
    }
    
    //MARK :- Update Data in Database
    @IBAction func updateButtonClick(_ sender: UIButton) {
        
        let modelInfo = APIModel(id: Int64(txtId.text!) ?? 65, name: txtName.text!, email: txtEmail.text!, gender: txtGender.text!, status: txtStatus.text!)
            let isUpdate = DatabaseManager.getInstance().updateData(person: modelInfo)
            print("isUpdate :- \(isUpdate)")
    }

}
