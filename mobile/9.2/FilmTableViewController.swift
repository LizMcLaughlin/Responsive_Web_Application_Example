//
//  FilmTableViewController.swift
//

import UIKit
import Foundation


//In this custom subclass, I define a property to store a list of Film objects
class FilmTableViewController: UITableViewController {

    struct Entries : Decodable {
        let name : String
        let rating : Int
    }
        
    //MARK: Properties
    var films = [Film]()
    var tableData = [String:Int]()

    override func viewDidLoad() {
                
        super.viewDidLoad()
        getReviews()
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        
        //returns 1 section
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // return the appropriate number of rows - however are currently in films array
        return films.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "FilmTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? FilmTableViewCell  else {
            fatalError("The dequeued cell is not an instance of FilmTableViewCell.")
        }
        
        // Fetches the appropriate meal for the data source layout.
        let film = films[indexPath.row]
        
        cell.filmTitle.text = film.name
        cell.ratingImage.image = film.photo
        
        return cell
    }
    
    private func getReviews() {
        
        print("getting reviews..")
        
        //create session obj w default configuration
            let configuration = URLSessionConfiguration.default
            let session = URLSession(configuration: configuration)
                        
            //convert string value into URL and store in constant
            let url = URL(string: "http://10.0.0.133:8080/api/v1/films")!
            
            //create request obj -> ecapsulates URL/method (GET,POST,...)/headers
            var request : URLRequest = URLRequest(url: url)
            
            //set up package
            request.httpMethod = "GET"
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            
            //create task taht retrieves contents of URL based on request obj
            let dataTask = session.dataTask(with: url) { data, response, error in guard let httpResponse = response as? HTTPURLResponse, let receivedData = data
                else {
                    print("error: not a valid http response")
                    return
                }
                switch (httpResponse.statusCode) {
                    case 200: //success
                        print("Success")

                        //decode data received from server into an iterable format so we can parse
                        let entries = try! JSONDecoder().decode([Entries].self, from: receivedData)
                        
                        //assign ea data element received from server to the films dict to later enter into table
                        for element in entries {
                            self.tableData[element.name] = element.rating
                        }
                        
                        //calls function to load data into and display table
                        self.loadFilms()

                        break
                    
                    default:
                        print("Failure")
                        break
                }
            }
            dataTask.resume()
        }
    
         
    private func loadFilms() {
        print("loading films...")
        
        for (filmTitle, rating) in self.tableData {
        
            //temp var to hold images for ea ratings table cell
            var img = UIImage(named: " ")
            
            //assign num stars to film obj to match its rating
            switch rating {
            case 1:
                img = UIImage(named: "1")
                break
            case 2:
                img = UIImage(named: "2")
                break
            case 3:
                img = UIImage(named: "3")
                break
            case 4:
                img = UIImage(named: "4")
                break
            case 5:
                img = UIImage(named: "5")
                break
            default:
                break
            }
                        
            //create row based on Film struct with correct title and image
            guard let row = Film(name: filmTitle, photo: img, rating: 1) else {
                fatalError("Unable to instantiate")
                    }
            
            //append to films array
            films.append(row)
            
            //reloads table data for multiple http requets to display
            self.tableView.reloadData()
            
        }
    
    
}
}
