//
//  MenuViewController.swift
//  IFCEApp
//
//  Created by William Nicolau Brasil Araújo on 25/04/19.
//  Copyright © 2019 William Nicolau Brasil Araújo. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        Spinner.start()
        setSegmented()
        
        // Refactor
        let d = Calendar.current.component(.weekday, from: Calendar.current.startOfDay(for: Date()))
        getFood(day: (d-1))
    }
    
    @IBAction func setWeekDay(_ sender: Any) {
        switch segmentedControl.selectedSegmentIndex
        {
        case 0:
            getFood(day: 1)
        case 1:
            getFood(day: 2)
        case 2:
            getFood(day: 3)
        case 3:
            getFood(day: 4)
        case 4:
            getFood(day: 5)
        default:
            getFood(day: 1)
        }
    }
    
    func setSegmented() {
        var weekDay = Calendar.current.component(.weekday, from: Calendar.current.startOfDay(for: Date()))
        switch weekDay {
        case 1, 7:
            weekDay = 2
        default:
            break
        }
        segmentedControl?.selectedSegmentIndex = weekDay - 2
    }
    
    func getFood(day: Int) {
        let id = day > 5 || day < 1 ? 1 : day
        let getURL = URL(string: "\(API.baseURL)/foods/\(id)")!
        var getRequest = URLRequest(url: getURL, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 30)
        getRequest.httpMethod = "GET"
        
        let getTask = URLSession.shared.dataTask(with: getRequest) { (data, response, error) in
            if error != nil { print ("GET Request in \(getRequest) Error: \(error!)") }
            if data != nil {
                do {
                    let menu = try JSONDecoder().decode(Menu.self, from: data!)
                    DispatchQueue.main.async {
                        guard let imageURL = URL(string: API.baseURL + menu.image.url) else {
                            return
                        }
                        
                        self.textLabel?.text = menu.description
                        self.imageView.load(url: imageURL)
                        
                        Spinner.stop()
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

extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}
