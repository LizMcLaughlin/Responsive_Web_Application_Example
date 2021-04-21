//
//  ViewController.swift
//

// Defines the behavior of my app objects

import UIKit

class ViewController: UIViewController {
    
    var t = "" //to hold obtained token
    var validRatings = ["1","2","3","4","5"] //for valid entry check in POST
    
    struct Tokens: Decodable {
        let token: String
    }
    
    //MARK: Properties
    @IBOutlet weak var userPrompt: UILabel! // instructions to user
    @IBOutlet weak var rating_input: UITextField! // where user enter rating
    @IBOutlet weak var login_filmTitle_input: UITextField! // where user enters login and film title
    
    //buttons
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var filmTitleLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    
    
    // called immediately after view controller is loaded from storyboard, and values are assigned to outlets
    // defines any initial settings and behaviors when the app first loads
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        login_filmTitle_input.text="Enter Username Here"
        rating_input.isHidden=true
        filmTitleLabel.isHidden=true
        ratingLabel.isHidden=true
    }


    //MARK: Actions
    
    // when the Log In button is pressed
    @IBAction func getToken(_ sender: UIButton) {
        
        if (login_filmTitle_input.text=="Liz") == false {
            
            let alert = UIAlertController(title: "Oops!", message: "Please enter a valid username", preferredStyle: .alert)

            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))

            self.present(alert, animated: true)

        } else {
        
            //create session obj w default configuration
            let configuration = URLSessionConfiguration.default
            let session = URLSession(configuration: configuration)
            
            let parameters : [String: Any] = ["name": login_filmTitle_input.text!]
            
            //convert string value into URL and store in constant
            let url = URL(string: "http://10.0.0.133:8080/api/v1/login")!
            
            //create request obj -> ecapsulates URL/method (GET,POST,...)/headers
            var request : URLRequest = URLRequest(url: url)
            
            //set up package
            request.httpMethod = "GET"
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            
            //pass dict to nsdata obj and set as request body
            do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
            } catch let error {
                print(error.localizedDescription)
            }
                        
            //create task that retrieves contents of URL based on request obj
            let dataTask = session.dataTask(with: url) { data, response, error in guard let httpResponse = response as? HTTPURLResponse, let receivedData = data
                else {
                    print("error: not a valid http response")
                    return
                }
                switch (httpResponse.statusCode) {
                    case 200: //success
                        print("Success")
                        let decoder = JSONDecoder()
                        decoder.keyDecodingStrategy = .convertFromSnakeCase
                        let tt: Tokens = try! decoder.decode(Tokens.self, from: receivedData)
                        self.t=tt.token
                        break
                    case 400:
                        print("400")
                        break
                    default:
                        print("Default")
                        break
                }
            }
            dataTask.resume()
            
            //removes login button
            loginButton.isHidden = true
            rating_input.isHidden=false
            userPrompt.text="Welcome!\n\n★Please enter a film and rating (1-5)★\n\nSelect 'Add Film' to create a film entry\nSelect 'Update Rating' to edit an existing"
            filmTitleLabel.isHidden=false
            ratingLabel.isHidden=false
            login_filmTitle_input.text=""
            rating_input.text=""

        }
    }
    
    
    // when user clicks 'Add Film' button
    @IBAction func postFilmRating(_ sender: UIButton) {
        
        //checks for valid user input
        if t == "" {
            
            let alert = UIAlertController(title: "Oops!", message: "Please enter your username before submitting or editing ratings", preferredStyle: .alert)

            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))

            self.present(alert, animated: true)
            
            login_filmTitle_input.text=""
            rating_input.text=""

        } else if rating_input.text==nil || rating_input.text!=="" || login_filmTitle_input.text=="" || login_filmTitle_input.text==nil {
        
            let alert = UIAlertController(title: "EMPTY FIELD", message: "Please entered both a film title and rating before submitting", preferredStyle: .alert)

            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))

        self.present(alert, animated: true)
            
            login_filmTitle_input.text=""
            rating_input.text=""
            
        } else if validRatings.contains(rating_input.text!) == false  {
            
            let alert = UIAlertController(title: "INVALID RATING", message: "Please enter a valid rating (1-5)", preferredStyle: .alert)

            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))

            self.present(alert, animated: true)
            
            rating_input.text=""
           
        //once validity checks have all passed
        } else{
                        
            var ratingInt: Int = Int(rating_input.text!)!
            //sample film submission
            let parameters = ["name":login_filmTitle_input.text!,"rating": ratingInt] as [String : Any]
            
            //create session obj w default configuration
                let configuration = URLSessionConfiguration.default
                let session = URLSession(configuration: configuration)
                            
                //convert string value into URL and store in constant
                let url = URL(string: "http://10.0.0.133:8080/api/v1/films/")!
                
                //create request obj -> ecapsulates URL/method (GET,POST,...)/headers
                var request = URLRequest(url: url)
                
                //set up package
                request.httpMethod = "POST"
                request.addValue("application/json", forHTTPHeaderField: "Accept")
                request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                request.addValue("Bearer \(self.t)", forHTTPHeaderField: "Authorization")

                //pass dict to nsdata obj and set as request body
                do {
                request.httpBody = try JSONSerialization.data(withJSONObject: parameters)
                } catch let error {
                    print(error.localizedDescription)
                }
                
                //create task that retrieves contents of URL based on request obj
            let dataTask=URLSession.shared.dataTask(with: request) { data, response, error in
            guard let httpResponse = response as? HTTPURLResponse, let receivedData = data
                
                    else {
                        print("error: not a valid http response")
                        return
                    }
                    switch (httpResponse.statusCode) {
                        case 200: //success
                            print("Success")
                            
                            //decode response
                            let resp=String(data: receivedData, encoding: String.Encoding.utf8)!
                            break
                        case 304:
                            print("Not Modified")
                            break
                        default:
                            print("Default")
                            break
                    }
                }
                dataTask.resume()
            }
        
        //reset user entry field
        login_filmTitle_input.text=""
        rating_input.text=""
        
        //successful submission alert
        let alert = UIAlertController(title: "Success!", message: "Add as many as you like, then select 'View Ratings' to see your films.", preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))

        self.present(alert, animated: true)

        }

    
}

