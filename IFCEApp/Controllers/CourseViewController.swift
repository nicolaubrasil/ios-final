//
//  CourseViewController.swift
//  IFCEApp
//
//  Created by William Nicolau Brasil Araújo on 25/04/19.
//  Copyright © 2019 William Nicolau Brasil Araújo. All rights reserved.
//

import UIKit

class CourseViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var courses = [Course]()
    var sections = [String]()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        doGetRequest()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return courses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let course = courses[indexPath.row]
        
        cell.textLabel?.text = course.title
        
        return cell
    }
    
    // Sections
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section]
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    // Refactor
    func doGetRequest () {
        
        let getURL = URL(string: "http://10.45.48.146:1337/categories")!
        var getRequest = URLRequest(url: getURL, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 30)
        getRequest.httpMethod = "GET"
        
        let getTask = URLSession.shared.dataTask(with: getRequest) { (data, response, error) in
            if error != nil { print ("GET Request in \(getRequest) Error: \(error!)") }
            if data != nil {
                do {
                    let resultObject = try JSONSerialization.jsonObject(with   : data!, options: [])
                    DispatchQueue.main.async {
                        let categories = try? JSONDecoder().decode([Category].self, from: data!)
                        print(resultObject)
//                        self.tableView.reloadData()
                    }
                } catch {
                    DispatchQueue.main.async {
                        print("Unable to parse JSON response in \(getRequest)")}
                }
            }
            else {print ("Received empty quest response from \(getRequest)")}
        }
        DispatchQueue.global(qos: .background).async {
            getTask.resume()
        }
    }
}
