//
//  ViewController.swift
//  myNote
//
//  Created by Nuch Phromsorn on 2018-03-02.
//  Copyright © 2018 Nuch Phromsorn. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {

    // MARK: Properties
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
   
    var data:[String] = []          // Datasource. Create an array for table view
    var selectedRow:Int = -1        // Detail view
    var newRowText:String = ""      // Any change from detailView will be in this property
    var fileURL: URL!               // Save data to file
    
    
     // Search
    var filteredData = [String]()
    var inSearchMode = false
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        table.dataSource = self
        table.delegate = self
        
        // Search part
        searchBar.delegate = self
        searchBar.returnKeyType = UIReturnKeyType.done
       
 
        // MARK: Navigation
        
        self.title = "myNotes"
        self.navigationController?.navigationBar.prefersLargeTitles = false
        self.navigationItem.largeTitleDisplayMode = .always
       
        
        // Define the add button for new note
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNote))
        
        
        // Button position
        self.navigationItem.rightBarButtonItem = addButton
        self.navigationItem.leftBarButtonItem = editButtonItem
        

        let baseURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        fileURL = baseURL.appendingPathComponent("notes.txt")
        
        
        load()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // check that the row has been selected
        
        if selectedRow == -1 {
            return
        }
        if searchBar.text != nil || searchBar.text != "" {
            searchBar.text = ""
            view.endEditing(true)
            inSearchMode = false
        }
        

        if newRowText == "" {
            data.remove(at: selectedRow)
        }
        
        data[selectedRow] = newRowText
        table.reloadData()
        save()
       
    }
    
   
    // MARK: Add
    @objc func addNote() {
        // Create the new note button to navigation and add animation
        // disable addButton while in the editing mode
        
        if table.isEditing {
            return
        }
        
        // Adding new note to array here
        
        let name: String = ""
        data.insert(name, at: 0)
        
        // Insert rows method for the table view and add auto-animation
        let indexPath:IndexPath = IndexPath(row: 0, section: 0)
        table.insertRows(at: [indexPath], with: .automatic)
        table.selectRow(at: indexPath, animated: true, scrollPosition: .none)
        
        self.performSegue(withIdentifier: "detail", sender: nil)
    }
    
   
    // MARK: Searchbar
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchBar.text == nil || searchBar.text == "" {
            inSearchMode = false
            view.endEditing(true)
            table.reloadData()
        } else {
            inSearchMode = true
            filteredData = data.filter({$0.range(of: searchText, options: .caseInsensitive) != nil})
            table.reloadData()
        }
    }
   
    
    // MARK: UITableViewCell (Items)
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if inSearchMode {
            return filteredData.count   // <-- Number of rows based on the rank of filteredData array
        }
        return data.count               // <-- Number of rows based on the rank of data array
    }
    
    
    // put the appropriate text items inside and return with reusable string called cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell",for: indexPath)

        if inSearchMode {
             cell.textLabel?.text =  filteredData[indexPath.row]
        } else {
             cell.textLabel?.text = data[indexPath.row]
        }

       
       //cell.textLabel?.text = data[indexPath.row]
        return cell
    }
    
  
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "detail", sender: nil)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let detailView:DetailViewController = segue.destination as! DetailViewController
        selectedRow = table.indexPathForSelectedRow!.row
        detailView.masterView = self
        if inSearchMode {
            detailView.setText(t: filteredData[selectedRow])
        } else {
            detailView.setText(t: data[selectedRow])
        }
    }
    
   
     //MARK: Edit
    override func setEditing(_ editing: Bool, animated: Bool) {
        
        //Handle the editbutton method
        super.setEditing(editing, animated: animated)
        
        //(built-in method)
        table.setEditing(editing, animated: animated)
    }

    // Handle editing the content inside of the table
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        data.remove(at: indexPath.row)
        table.deleteRows(at: [indexPath], with: .fade)
        save()
    }
    
    
    // MARK: SAVE to file
    func save() {
        
        let me = NSArray(array: data)
        do {
            try me.write(to: fileURL)
        } catch  {
            print("error from writing file")
        }
    }
    
  
    // MARK: LOAD table from .txt file
    func load() {
        if  let loadedData:[String] = NSArray(contentsOf:fileURL) as? [String]{
            data = loadedData
            table.reloadData()
        }
    }
}


