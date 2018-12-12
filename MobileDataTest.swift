
//  ViewController.swift
//  sphTest
//
//  Created by Louie Jay Arreza on 12/2/18.
//  Copyright © 2018 Louie Jay Arreza. All rights reserved.
//

import UIKit

class MobileDataTest: UITableViewController {
    
    var mData = [MobileData]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Mobile Data List"
        fetchJSON()
        
    }

    struct MobileData: Decodable {
        
        let result : String
        let fields : String
        
        let id : String
        let type : String
        
        
        private enum CodingKeys: String, CodingKey {
            
            case result = "result"
            case fields = "fields"
            
            case id = "id"
            case type = "type"
            
        
            
        }
    }

    fileprivate func fetchJSON() {
        
        let urlString = "https://data.gov.sg/api/action/datastore_search?resource_id=a807b7ab-6cad-4aa6-87d0-e283a7353a0f&limit=5"
        
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, _, err) in
            
            DispatchQueue.main.async {
                
                if let err = err {
                    
                    print("Failed to get data from url:", err)
                    
                    return
                    
                }

                guard let data = data else { return }
                
                do {
               
                    let decoder = JSONDecoder()
                    
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    self.mData = try decoder.decode([MobileData].self, from: data)
                    
                    self.tableView.reloadData()
                    
                } catch let jsonErr {
                    
                    print("Failed to decode:", jsonErr)
                }
            }
            
            }.resume()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return mData.count
        
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cellId")
        let sData = mData[indexPath.row]
        
        cell.textLabel?.text = sData.result
        
        return cell
    }
}
