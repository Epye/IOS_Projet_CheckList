//
//  DataModel.swift
//  Checklists
//
//  Created by iem on 29/03/2018.
//  Copyright © 2018 iem. All rights reserved.
//

import Foundation

class DataModel {
    static let sharedInstance = DataModel()
    
    var listCheckList: Array<Checklist> = []
    
    private var documentDirectory: URL = FileManager.default.urls(for: FileManager.SearchPathDirectory.documentDirectory, in: FileManager.SearchPathDomainMask.userDomainMask).first!
    
    private var dataFileUrl: URL = URL(fileURLWithPath: "")
    
    init() {
        let file = "data.json"
        dataFileUrl = documentDirectory.appendingPathComponent(file)
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(saveCheckList),
            name: .UIApplicationDidEnterBackground,
            object: nil)
    }
    
    @objc public func saveCheckList(){
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        do {
            let data = try encoder.encode(listCheckList)
            try data.write(to: dataFileUrl)
            print(dataFileUrl.absoluteString)
        } catch {
            
        }
    }
    
    public func loadCheckList(){
        let decoder = JSONDecoder()
        do {
            let data = try String(contentsOf: dataFileUrl, encoding: .utf8).data(using: .utf8)
            listCheckList = try decoder.decode([Checklist].self, from: data!)
        } catch {
            
        }
    }
}
