//
//  PersonCell.swift
//  MissingPersons
//
//  Created by Sagar Arora  on 6/14/16.
//  Copyright © 2016 Sagar Arora . All rights reserved.
//

import UIKit


class PersonCell: UICollectionViewCell {
    
    
    @IBOutlet weak var personImage: UIImageView!
    var person: Person!

    
    
    func configureCell(person: Person) {
        self.person = person
        
        if let url =  NSURL(string: "\(baseURL)\(person.personImageUrl!)") {
            
        downloadImage(url)
            
            
        }
        // Now in the main thread where we retrieved data from the url and then set image equal to that data if there are no errors and if data return from data task exists. This is taking the url and call the getData and downloadImage with that url.
        
        
    }
    
    func downloadImage(url: NSURL) {
        getDatafromURL(url) { (Data, response, error) in
            dispatch_async(dispatch_get_main_queue()) { () -> Void in
                guard let data = Data where error == nil else { return }
                self.personImage.image = UIImage(data: data)
                self.person.personImage = self.personImage.image
              
                
                // person.personImage is the property created in the person class which is being referenced for the faceID and that image converted into data. 
       
                // Now we are in the main thread so we can work with the data.
                // If data exists and there is no error then store the data in the let constant. then we are going to set the image equal to the data that was retrieved from the datatask with the url. This is downloading the image meaning taking the data retrieved and converting it into a UIImage and setting it to the personImage. Now that you have retrieved data and then created a UIImage out of it and set that UIImage to the PersonImage outlet you can now downloadFaceID of that UIImage. 
           
                
            }
        }
      
        
        
        
        
    }

    
    func getDatafromURL(url: NSURL, completion: ((Data: NSData?, response: NSURLResponse?, error: NSError?) -> Void)) {
        
        NSURLSession.sharedSession().dataTaskWithURL(url) { ( data: NSData?,  response: NSURLResponse?, error: NSError?) in
            completion(Data: data, response: response, error: error)
        }.resume()
            
            
            
    }
    
    func setSelected() {
        personImage.layer.borderWidth = 2.0
        personImage.layer.borderColor = UIColor.yellowColor().CGColor
        
                self.person.downloadFaceID()
    }
        // must call .resume in order to start DataSession with URL passed in. THis basically sets a datatask in which it retireves data, and then after that is done it calls the completion handler which returns back data, a response, and an error if it exists.
        
        
          
        

    // You need to retrieve the data for the images by passing in a url and then in the completion handler retrieving data, response, and error. Then for configuration, a string url is going to be passed in that represents an image from a server and essentially you need to convert that to NSURL and then do a data session then a data task where you retrieve data and then set the detail equal to a UIImage.
  
    
    
}
