//
//  File.swift
//


//data model to store the info our rating scene displays
//class defined with film name, rating, and photo (stars to display in table)
import UIKit

class Film {
    
    //MARK: Properties
    
    var name: String
    var photo: UIImage?
    
    //MARK: Initialization
     
    init?(name: String, photo: UIImage?, rating: Int) {
        
        // Initialization should fail if there is no name or if the rating is negative.
        if name.isEmpty || rating < 0  {
            return nil
        }
        
        // Initialize stored properties.
        self.name = name
        self.photo = photo
        
    }
    
    
    
    
    
}
