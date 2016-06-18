//
//  ViewController.swift
//  MissingPersons
//
//  Created by Sagar Arora  on 6/14/16.
//  Copyright © 2016 Sagar Arora . All rights reserved.
//

import UIKit
import ProjectOxfordFace

let baseURL = "http://localhost:6069/img/"


class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var ImagePicked: UIImageView!
    @IBOutlet weak var matchBtn: UIButton!
    
    let imgPicker = UIImagePickerController()
    var selectedPerson: Person?
    var hasSelectedImage: Bool = false
    // creating a tap gesture that the function calls on itself with a selector as loadPicker which sets the imgPicker to load a photo library and present the view controller. With one arguement

 
    
    let missingPeople = [
    Person(personImageUrl: "person1.jpg"),
    Person(personImageUrl: "person2.jpg"),
    Person(personImageUrl: "person3.jpg"),
    Person(personImageUrl: "person4.jpg"),
    Person(personImageUrl: "person5.jpg"),
    Person(personImageUrl: "person6.png")
          
    
    
    ]

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(loadPicker(_:)))
        tap.numberOfTapsRequired = 1
       ImagePicked.addGestureRecognizer(tap)
        matchBtn.layer.cornerRadius = 5.0
        
        
       collectionView.dataSource = self
       collectionView.delegate = self
       imgPicker.delegate = self
    }
    func showErrorAlertWhenNotSelected() {
        
        let alert = UIAlertController(title: "Select Person and Image", message: "Please select a person image from above and from album.", preferredStyle: UIAlertControllerStyle.Alert)
        let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: { (nil) in
            
        })
        
        alert.addAction(ok)
        presentViewController(alert, animated: true, completion: nil)
        
        
    }


    @IBAction func checkforMatchBtnPressed(sender: AnyObject) {
        if selectedPerson == nil || !hasSelectedImage  {
            showErrorAlertWhenNotSelected()
        } else {
            
            if let img = ImagePicked.image, let imgData = UIImageJPEGRepresentation(img, 0.8) {
                FaceService.instance.client.detectWithData(imgData, returnFaceId: true, returnFaceLandmarks: false, returnFaceAttributes: nil, completionBlock: { ( faces: [MPOFace]!, error: NSError!) in
                    
                    if error == nil {
                    var faceID: String?
                    
                    for face in faces {
                        faceID = face.faceId
                       
                        break
                        
                    }
                        if faceID != nil {
                            FaceService.instance.faceIDArray.append(faceID!)
                            FaceService.instance.client.verifyWithFirstFaceId(self.selectedPerson!.faceID, faceId2:faceID, completionBlock: { ( result: MPOVerifyResult!, error: NSError!) in
                                if error == nil {
                                    if result.isIdentical == true {
                                       let alert = UIAlertController(title: "A match!", message: "The images you selected have matched faces! Confidence is \(result.confidence) Percent! ", preferredStyle: UIAlertControllerStyle.Alert)
                                      let action =  UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Cancel, handler: { (nil) in
                                            
                                        })
                                       alert.addAction(action)
                                        self.presentViewController(alert, animated: true, completion: nil)
                                    } else {
                                       print(result.debugDescription)
                                        
                                    }
                            
                                } else {
                                   print(error.debugDescription)
                                    
                                }
                                
                            })
                            
                        }
                    }
                    
                })
                
            }
            
        }
        // If an image from above has been selected and an image from the view controller has been selected then you are going to convert the image picked into data and then pass it into the detectwithData function and then loop through all the faces and then set a faceID variable equal to the first faceID in the return faces. (could return multiple faces in one picture like a group selfie. all of the have one so just set it equal to the first one). if faceID is not nil then you can verifybothID's then print the results.
        
    }
    // You created an alert controller that pops up if an image hasnt been selected. Data is added to the selectedPerson variable when the cell has been selected. The data that is added is the object at IndexPath
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return missingPeople.count
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        // when you are configuring data always use indexPath.row which means the row that has been selected. So if it is the first row selected it will reference the first index [0].
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("PersonCell", forIndexPath: indexPath) as! PersonCell
        let person = missingPeople[indexPath.row]
        cell.configureCell(person)
    
       
        
        return cell 
    }
    // This function is called for each cell item. The cell is configured based on the indexAtPath and the  configuring is basically taking the url and then converting it into NSURL and creating a datasession to retrieve data and create an image with that data. 
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            ImagePicked.image = image
            dismissViewControllerAnimated(true, completion: nil)
            hasSelectedImage = true
            // MediaWith info is passing in a dictionary type so you reference the value as a UIImage type then you set the imageView outlet equal to this image that was picked.
            
            
        }
    }
    
    func loadPicker(gesture: UITapGestureRecognizer) {
        imgPicker.allowsEditing = false
        imgPicker.sourceType = .PhotoLibrary
        presentViewController(imgPicker, animated: true, completion: nil)
        
        
    }
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as! PersonCell
         self.selectedPerson = missingPeople[indexPath.row]
         cell.configureCell(selectedPerson!)
        cell.setSelected()
      
       
   
        
        
    }
    
    

}

