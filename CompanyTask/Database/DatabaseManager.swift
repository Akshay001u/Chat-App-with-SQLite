//
//  DatabaseManager.swift
//  CompanyTask
//
//  Created by My Mac on 12/09/22.
//

import Foundation

var shareInstance = DatabaseManager()

class DatabaseManager: NSObject {
    
    var database: FMDatabase? = nil
    
    class func getInstance() -> DatabaseManager {
        if shareInstance.database == nil {
            shareInstance.database = FMDatabase(path: Util.getPath("CompanyTask.db"))
        }
        return shareInstance
    }
    
    
    //MARK:- Saving Person Data
    func saveData(_ modelInfo: APIModel) -> Bool {
        shareInstance.database?.open()
        
        let isSave = shareInstance.database?.executeUpdate("INSERT INTO CompanyTask (id, name, email, gender, status) VALUES (?,?,?,?,?)", withArgumentsIn:[modelInfo.id, modelInfo.name, modelInfo.email, modelInfo.gender, modelInfo.status])
        
        shareInstance.database?.close()
        return isSave!
    }
    
    
    //MARK:- Fetching Person Data
    func getData() -> [APIModel] {
        shareInstance.database?.open()
        
        var person = [APIModel]()
        do {
            let result: FMResultSet? = try shareInstance.database?.executeQuery("SELECT * FROM CompanyTask", values: nil)
            
            if result != nil {
                while result!.next(){
                    let person1 = APIModel(id: (result!.longLongInt(forColumn: "id")), name: (result!.string(forColumn: "name")!), email: (result!.string(forColumn: "email")!), gender: (result!.string(forColumn: "gender")!), status: (result!.string(forColumn: "status")!))
                    person.append(person1)
                }
            }
        } catch let error {
            print(error.localizedDescription)
        }
        
        shareInstance.database?.close()
        return person
    }
    
    
    //MARK:- Updating Person Data
    func updateData(person: APIModel) -> Bool {
        shareInstance.database?.open()
        
        let isUpdate = shareInstance.database?.executeUpdate("UPDATE CompanyTask SET name=?, email=?, gender=?, status=? WHERE id=?", withArgumentsIn: [person.name, person.email, person.gender, person.status, person.id])
        
        shareInstance.database?.close()
        return isUpdate!
    }
    
    
    //MARK:- Deleting Person Data
    func deleteData(person: APIModel) -> Bool {
        shareInstance.database?.open()

        let isDeleted = shareInstance.database?.executeUpdate("DELETE FROM CompanyTask WHERE id=?", withArgumentsIn: [person.id])

        shareInstance.database?.close()
        return isDeleted!
    }
}
