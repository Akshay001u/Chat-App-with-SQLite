//
//  ViewController.swift
//  CompanyTask
//
//  Created by My Mac on 12/09/22.
//

import UIKit
import MobileCoreServices

class ViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    @IBOutlet weak var dataTableView: UITableView!
    
    var person = [APIModel]()
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataPass()
       
    }

    override func viewWillAppear(_ animated: Bool) {
        person = DatabaseManager.getInstance().getData()
        print(person)
        dataTableView.reloadData()
    }
    
    @objc func selectImage(gesture: UITapGestureRecognizer) {
        imagePermission()
    }
    
    //MARK :- Permission Manager
    func imagePermission() {
        let alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (handler) in
            self.openCamera()
        }))
        alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { (handler) in
            self.openGallery()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (handler) in
            
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    //MARK :- Camera Permission
    func openCamera() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePicker.allowsEditing = true
            imagePicker.sourceType = .camera
            imagePicker.mediaTypes = [kUTTypeImage as String]
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    //MARK :- Gallery Permission
    func openGallery() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            imagePicker.allowsEditing = true
            imagePicker.sourceType = .savedPhotosAlbum
            imagePicker.delegate = self
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        dismiss(animated: true, completion: nil)
        if let img = info[.originalImage] as? UIImage {
            var cell = dataTableView.cellForRow(at: IndexPath.init(row: 0, section: 0)) as! DataTableViewCell
            cell.profileImage.image = img
        }
    }
    
    //MARK :- API Calling
    func dataPass() {

    let urlString = "https://gorest.co.in/public/v2/users"
    
    guard let url = URL(string: urlString) else{
        print("URL Invalid")
        return
        }
        
        var request = URLRequest(url:url)
        request.httpMethod = "GET"
        
        let session = URLSession(configuration: .default)
        
        let dataTask = session.dataTask(with: request){(data, response, error) in
            
            print("The error is \(String(describing: error))")
            print("The Data is \(String(describing: data))")
            
            guard let data = data else {
                print("Data not found")
                return
            }
            
            let getJsonObject = try? JSONSerialization.jsonObject(with: data) as? [[String: Any]]
            
            for dictionary in getJsonObject!
            {
                let eachDictionary = dictionary as [String: Any]
                let pId = eachDictionary["id"] as! Int64
                let pName = eachDictionary["name"] as! String
                let pEmail = eachDictionary["email"] as! String
                let pGender = eachDictionary["gender"] as! String
                let pStatus = eachDictionary["status"] as! String
                
                DatabaseManager.getInstance().saveData(APIModel(id: pId, name: pName, email: pEmail, gender: pGender, status: pStatus))
                
            }
            DispatchQueue.main.async {
                self.dataTableView.reloadData()
            }
        }
        dataTask.resume()
    }
}

//MARK :- TableView DataSource and Delegate Method
extension ViewController : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DatabaseManager.getInstance().getData().count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.dataTableView.dequeueReusableCell(withIdentifier: "cell") as! DataTableViewCell
        let fetchedData = DatabaseManager.getInstance().getData()[indexPath.row]
        
        cell.nameLabel.text = fetchedData.name
        cell.emailLabel.text = fetchedData.email
        
        if fetchedData.status == "active" {
            cell.statusImage.image = UIImage(named: "green")
        } else {
            cell.statusImage.image = UIImage(named: "grey")
        }
        
        // Tap Gesture Methods
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.selectImage(gesture:)))
        tapGesture.numberOfTapsRequired = 1
        cell.profileImage.isUserInteractionEnabled = true
        cell.profileImage.addGestureRecognizer(tapGesture)
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 114
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let updateDataVC = self.storyboard?.instantiateViewController(identifier: "UpdateDataViewController") as! UpdateDataViewController
        updateDataVC.details = self.person[(dataTableView.indexPathForSelectedRow?.row)!]
            self.navigationController?.pushViewController(updateDataVC, animated: true)
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let deleteObject = DatabaseManager.getInstance().getData()[indexPath.row]
        DatabaseManager.getInstance().deleteData(person: deleteObject)
        dataTableView.reloadData()
        print("Deleted")
    }
    
}
