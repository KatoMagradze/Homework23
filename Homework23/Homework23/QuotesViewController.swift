//
//  QuotesViewController.swift
//  Homework23
//
//  Created by Kato on 5/18/20.
//  Copyright © 2020 TBC. All rights reserved.
//

import UIKit

class QuotesViewController: UIViewController {
    
   struct Quote : Codable {
    
    
        let created_at: String
        let icon_url: String
        let id: String
        let updated_at: String
        let url: String
        let value: String


    }
    
    var bgColor = UIColor()
    var quotes = [Quote]()

    
    @IBOutlet weak var quoteLabel: UILabel!
    @IBOutlet var backgroundView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        self.backgroundView.backgroundColor = bgColor
        // Do any additional setup after loading the view.
        
        self.getQuote()
        self.quoteLabel.text = ""
        
    }
    
   func getQuote() {
        let url = URL(string: "https://api.chucknorris.io/jokes/random?category=dev")!
    
        URLSession.shared.dataTask(with: url) { (data, res, err) in
            
            guard let data = data else {return}
            
            do {
                let decoder = JSONDecoder()
                let quote = try decoder.decode(Quote.self, from: data)
                
                self.quotes.append(quote)
                
                DispatchQueue.main.async {
                    self.quoteLabel.text = self.quotes[0].value
                }
                
            }
            catch {print(error.localizedDescription)}
    
        }.resume()
    }
    

}
