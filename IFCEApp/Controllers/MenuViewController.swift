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
        
        let weekDay = Calendar.current.component(.weekday, from: Calendar.current.startOfDay(for: Date()))
        segmentedControl?.selectedSegmentIndex = weekDay - 2
        
        guard let url = URL(string: "http://10.45.48.146:1337/uploads/6ad2a754552844eb91b1121634148d29.png") else {
            return
        }
        imageView.load(url: url)
        
        doGetRequest()
    }
    
    func doGetRequest () {
        
        let getURL = URL(string: "http://10.45.48.146:1337/menus/1")!
        var getRequest = URLRequest(url: getURL, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 30)
        getRequest.httpMethod = "GET"
        
        let getTask = URLSession.shared.dataTask(with: getRequest) { (data, response, error) in
            if error != nil { print ("GET Request in \(getRequest) Error: \(error!)") }
            if data != nil {
                do {
                    DispatchQueue.main.async {
                        
                        let menu = try? JSONDecoder().decode(Menu.self, from: data!)
                        
                        guard let imageURL = URL(string: API.baseURL + menu!.image.url) else {
                            return
                        }
                        
                        
                        self.textLabel?.text = menu?.description
                        self.imageView.load(url: imageURL)
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
    
    @IBAction func setWeekDay(_ sender: Any) {
        switch segmentedControl.selectedSegmentIndex
        {
        case 0:
            textLabel.text = "Segunda"
        case 1:
            textLabel.text = "Terça"
        case 2:
            textLabel.text = "Quarta"
        case 3:
            textLabel.text = "Quinta"
        case 4:
            textLabel.text = "Sexta"
        default:
            textLabel.text = "Segunda"
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
