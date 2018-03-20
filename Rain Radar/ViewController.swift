//
//  ViewController.swift
//  Rain Radar
//
//  Created by Simon Hočevar on 06/03/2018.
//  Copyright © 2018 Simon Hočevar. All rights reserved.
//

import UIKit

class ViewController: UIViewController , UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    let countries: [String] = ["Slovenia", "Croatia", "Austria", "Italy", "Hungary"]
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return (countries.count)
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ViewControllerTableViewCell
        cell.logo.image = UIImage(named: countries[indexPath.row]+"-icon.png")
        cell.name.text = countries[indexPath.row]
        return (cell)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(countries[indexPath.row])
        performSegue(withIdentifier: "segue", sender: self)
    }
   
}
