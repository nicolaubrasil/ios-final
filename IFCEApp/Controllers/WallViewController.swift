//
//  WallViewController.swift
//  IFCEApp
//
//  Created by William Nicolau Brasil Araújo on 25/04/19.
//  Copyright © 2019 William Nicolau Brasil Araújo. All rights reserved.
//

import UIKit


class WallTableViewCell: UITableViewCell {
    @IBOutlet weak var descriptionTextLabel: UILabel!
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var dateTextLabel: UILabel!
}

class WallViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var posts = [Post]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        getAllPosts()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "wall", for: indexPath)
            as! WallTableViewCell
        
        let p = posts[indexPath.row]
        
        let dateString = p.date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = dateFormatter.date(from: dateString)
        dateFormatter.dateFormat = "dd/MM/yyyy"
        
        cell.descriptionTextLabel.text = p.description
        cell.coverImageView.load(url: URL(string: API.baseURL + p.image.url)!)
        cell.dateTextLabel.text = dateFormatter.string(from: date!)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 269.0
    }
    
    func getAllPosts () {
        
        let getURL = URL(string: "\(API.baseURL)/walls")!
        var getRequest = URLRequest(url: getURL, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 30)
        getRequest.httpMethod = "GET"
        
        let getTask = URLSession.shared.dataTask(with: getRequest) { (data, response, error) in
            if error != nil { print ("GET Request in \(getRequest) Error: \(error!)") }
            if data != nil {
                do {
                    let postsList = try JSONDecoder().decode([Post].self, from: data!)
                    DispatchQueue.main.async {

                        for post in postsList {
                            self.posts.append(post)
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
