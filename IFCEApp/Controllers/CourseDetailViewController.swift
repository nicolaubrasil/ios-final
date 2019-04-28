//
//  CourseDetailViewController.swift
//  IFCEApp
//
//  Created by Nicolau Brasil on 27/04/19.
//  Copyright © 2019 William Nicolau Brasil Araújo. All rights reserved.
//

import UIKit

class CourseDetailViewController: UIViewController {

    var course: Course?
    
    @IBOutlet weak var textView: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = course?.title
        textView.setHTML(text: course!.description!)
    }
}

extension UILabel {
    func setHTML(text: String) {
        print(self.font!.fontName)
        let modifiedFont = NSString(format:"<span style=\"font-family: '-apple-system', 'HelveticaNeue'; text-align: justify; font-size: \(17.0)\">%@</span>" as NSString, text)
        
        let attrStr = try! NSAttributedString(
            data: modifiedFont.data(using: String.Encoding.unicode.rawValue, allowLossyConversion: true)!,
            options: [NSAttributedString.DocumentReadingOptionKey.documentType:NSAttributedString.DocumentType.html, NSAttributedString.DocumentReadingOptionKey.characterEncoding: String.Encoding.utf8.rawValue],
            documentAttributes: nil)
        
        self.attributedText = attrStr
    }
}
