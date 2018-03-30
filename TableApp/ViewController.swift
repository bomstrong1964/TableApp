//
//  ViewController.swift
//  TableApp
//
//  Created by Macmini on 28/03/2018.
//  Copyright © 2018 Convert IT. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var lblTest: UILabel!
    
    @IBOutlet var companyTableView: UITableView!
    let URL_HEROES = "http://yourapproadmap.com/service.php";
    
    //A string array to save all the names
    var nameArray = [String]()
    
    let companyName = ["Vetech", "Melin", "Luthje Trading", "Seaflex"]
    let share = [12.34, 45.67, 16.93, 23.79]
  
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        companyTableView.delegate = self
        companyTableView.dataSource = self
        
        let decoder = JSONDecoder()
        do {
            let product = try decoder.decode(GroceryProduct.self, from: json)
             print(product.description) // Prints "Durian"
        }
        catch {}
            
        
       
        
        //.companyTableView.reloadData()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return companyName.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = companyTableView.dequeueReusableCell(withIdentifier: "cell")
        
        cell?.textLabel?.text = companyName[indexPath.row]
        cell?.detailTextLabel?.text = "\(share[indexPath.row]) %"
        
        return cell!
    }
    
    func getTodo(_ idNumber: Int) {
        Todo.todoByIDOld(idNumber, completionHandler: { (todo, error) in
            if let error = error {
                // got an error in getting the data, need to handle it
                print(error)
                return
            }
            guard let todo = todo else {
                print("error getting first todo: result is nil")
                return
            }
            // success :)
            debugPrint(todo)
            print(todo.title)
        })
    }
    
    struct Todo {
        
      
            var title: String
            var id: Int?
            var userId: Int
            var completed: Int
        
        init?(json: [String: Any]) {
            guard let title = json["title"] as? String,
                let id = json["id"] as? Int,
                let userId = json["userId"] as? Int,
                let completed = json["completed"] as? Int else {
                    return nil
            }
            self.title = title
            self.userId = userId
            self.completed = completed
            self.id = id
        }
        
        static func endpointForID(_ id: Int) -> String {
            return "https://jsonplaceholder.typicode.com/todos/\(id)"
        }
    }
    enum BackendError: Error {
        case urlError(reason: String)
        case objectSerialization(reason: String)
    }
    
    static func todoByID(_ id: Int, completionHandler: @escaping (Todo?, Error?) -> Void) {
        // set up URLRequest with URL
        let endpoint = Todo.endpointForID(id)
        guard let url = URL(string: endpoint) else {
            print("Error: cannot create URL")
            let error = BackendError.urlError(reason: "Could not construct URL")
            completionHandler(nil, error)
            return
        }
        let urlRequest = URLRequest(url: url)
        
        // Make request
        let session = URLSession.shared
        let task = session.dataTask(with: urlRequest, completionHandler: {
            (data, response, error) in
            // handle response to request
            // check for error
            guard error == nil else {
                completionHandler(nil, error!)
                return
            }
            // make sure we got data in the response
            guard let responseData = data else {
                print("Error: did not receive data")
                let error = BackendError.objectSerialization(reason: "No data in response")
                completionHandler(nil, error)
                return
            }
            
            // parse the result as JSON
            // then create a Todo from the JSON
            do {
                if let todoJSON = try JSONSerialization.jsonObject(with: responseData, options: []) as? [String: Any],
                    let todo = Todo(json: todoJSON) {
                    // created a TODO object
                    completionHandler(todo, nil)
                } else {
                    // couldn't create a todo object from the JSON
                    let error = BackendError.objectSerialization(reason: "Couldn't create a todo object from the JSON")
                    completionHandler(nil, error)
                }
            } catch {
                // error trying to convert the data to JSON using JSONSerialization.jsonObject
                completionHandler(nil, error)
                return
            }
        })
        task.resume()
    }
    
  
    
    func showNames(){
        //looing through all the elements of the array
        for name in nameArray{
            
            //appending the names to label
            lblTest.text = lblTest.text! + name + "\n";
        }
    }
    
    
    
    




}

