//
//  ViewController.swift
//  Homework23
//
//  Created by Kato on 5/18/20.
//  Copyright © 2020 TBC. All rights reserved.
//

import UIKit

struct UserColor: Codable {
    
    let colors: [Color]
    
    enum CodingKeys: String, CodingKey {
        case colors = "data"
    }
    
}

struct Color: Codable {
    let id: Int
    let name: String
    let year: Int
    let color: String
    let pantone: String
    
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case year
        case color
        case pantone = "pantone_value"
    }
}

class ViewController: UIViewController {
    


    @IBOutlet weak var collectionView: UICollectionView!
    
    var colors = [Color]()
    var selectedIndex = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        
        self.get()
        
    }
    
    func get() {
        let url = URL(string: "https://reqres.in/api/unknown")!
        URLSession.shared.dataTask(with: url) { (data, res, err) in
            
            guard let data = data else {return}
            
            do {
                let decoder = JSONDecoder()
                let userColor = try decoder.decode(UserColor.self, from: data)
                
                self.colors.append(contentsOf: userColor.colors)
                
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            }
            catch {print(error.localizedDescription)}
            
        }.resume()
    }
    
    

}
extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return colors.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collection_cell", for: indexPath) as! CollectionViewCell
        
        let cellColor = hexStringToUIColor(hex: colors[indexPath.row].color)
        
        cell.colorNumberLabel.text = colors[indexPath.row].color
        cell.colorNameLabel.text = colors[indexPath.row].name
        cell.backgroundColor = cellColor
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        self.selectedIndex = indexPath.row
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let temp = storyboard.instantiateViewController(withIdentifier: "quotes_vc")
        
        if let vc = temp as? QuotesViewController {
        
            let cellColor = hexStringToUIColor(hex: colors[indexPath.row].color)

            vc.bgColor = cellColor
        }
        
        self.navigationController?.pushViewController(temp, animated: true)
        
        //present(temp, animated: true, completion: nil)
        
        print("cell tapped")
        
    }
    
}
extension ViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let itemWith = collectionView.frame.width / 2
        
        return CGSize(width: itemWith - 20 - 20, height: 150)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 30, left: 20, bottom: 0, right: 20)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
}

extension ViewController {
    
    func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }

        if ((cString.count) != 6) {
            return UIColor.gray
        }

        var rgbValue:UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)

        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}
