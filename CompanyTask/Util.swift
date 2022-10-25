//
//  Util.swift
//  CompanyTask
//
//  Created by My Mac on 12/09/22.
//

import Foundation

class Util: NSObject {
    
    class func getPath(_ fileName: String) -> String {
        let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let fileUrl = documentDirectory.appendingPathComponent(fileName)
        print("Database Path :- \(fileUrl.path)")
        return fileUrl.path
    }
    
    class func copyDatabase(_ fileName: String) {
        let dbPath = getPath("CompanyTask.db")
        let fileManager = FileManager.default
        
        if !fileManager.fileExists(atPath: dbPath) {
            let bundle = Bundle.main.resourceURL
            let file = bundle?.appendingPathComponent(fileName)
            var error: NSError?
            do{
                try fileManager.copyItem(atPath: (file?.path)!, toPath: dbPath)
            } catch let error1 as NSError {
                error = error1
            }
            
            if error == nil {
                print("error in db")
            } else {
                print("Yeah! No error")
            }
        }
    }
}
