//
//  APIModel.swift
//  CompanyTask
//
//  Created by My Mac on 12/09/22.
//

import Foundation

class APIModel {
    var id : Int64
    var name : String
    var email : String
    var gender : String
    var status : String
   
    
    init (id: Int64, name : String, email : String, gender : String, status : String) {
        self.id = id
        self.name = name
        self.email = email
        self.gender = gender
        self.status = status
    }
}
