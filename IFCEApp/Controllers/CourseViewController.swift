//
//  CourseViewController.swift
//  IFCEApp
//
//  Created by William Nicolau Brasil Araújo on 25/04/19.
//  Copyright © 2019 William Nicolau Brasil Araújo. All rights reserved.
//

import UIKit

class CourseViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var courses = [[Course]]()
    var sections = [String]()
    var spinner = UIActivityIndicatorView()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        Spinner.start()
        getAllCourses()
    }
    
    // Table
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = courses[indexPath.section][indexPath.row].title
        
        return cell
    }
    
    // Sections
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return courses[section].count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    // Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let indexPath = tableView.indexPathForSelectedRow {
            let courseDetails = segue.destination as! CourseDetailViewController
            courseDetails.course = courses[indexPath.section][indexPath.row]
        }
    }
    
    // Refactor to generic
    func getAllCourses () {
        
        let getURL = URL(string: "\(API.baseURL)/categories")!
        var getRequest = URLRequest(url: getURL, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 30)
        getRequest.httpMethod = "GET"
        
        let getTask = URLSession.shared.dataTask(with: getRequest) { (data, response, error) in
            if error != nil { print ("GET Request in \(getRequest) Error: \(error!)") }
            if data != nil {
                do {
                    let categories = try JSONDecoder().decode([Category].self, from: data!)
                    DispatchQueue.main.async {
                        for category in categories {
                            self.sections.append(category.title)
                            var coursesList: [Course] = []
                            
                            for course in category.courses {
                                coursesList.append(course)
                            }
                            
                            self.courses.append(coursesList)
                        }
                        
                        self.tableView.reloadData()
                        Spinner.stop()
                    }
                } catch {
                    DispatchQueue.main.async {
                        print("Unable to parse JSON response in \(getRequest)")}
                }
            }
            else { print ("Received empty quest response from \(getRequest)") }
        }
        DispatchQueue.global(qos: .background).async {
            getTask.resume()
        }
    }
}

