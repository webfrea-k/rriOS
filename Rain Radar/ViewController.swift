//
//  ViewController.swift
//  Rain Radar
//
//  Created by Simon Hočevar on 06/03/2018.
//  Copyright © 2018 Simon Hočevar. All rights reserved.
//

import UIKit

class ViewController: UIViewController , UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {

  
    @IBOutlet weak var searchbar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    let countries: [String] = ["Slovenia", "Croatia", "Austria", "Italy", "Hungary"]
    var filteredCountries = [String]()
    var isSearching = false
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if(isSearching)
        {
            return filteredCountries.count
        }
        return (countries.count)
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ViewControllerTableViewCell
        if (isSearching)
        {
            cell.name.text = filteredCountries[indexPath.row]
            cell.logo.image = UIImage(named: filteredCountries[indexPath.row]+"-icon.png")
        }
        else
        {
            cell.name.text = countries[indexPath.row]
            cell.logo.image = UIImage(named: countries[indexPath.row]+"-icon.png")
        }
        return (cell)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchbarText: String)
    {
        if(searchbar.text == nil || searchbar.text == "")
        {
            isSearching = false
            view.endEditing(true)
            tableView.reloadData()
        }
        else
        {
            isSearching = true
            filteredCountries = countries.filter({$0.contains(searchBar.text!)})
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        searchbar.delegate = self
        searchbar.returnKeyType = UIReturnKeyType.done
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "show_country", sender: self)
    }
   
}
