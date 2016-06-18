//
//  Person.swift
//  MissingPersons
//
//  Created by Sagar Arora  on 6/15/16.
//  Copyright © 2016 Sagar Arora . All rights reserved.
//

import Foundation
import ProjectOxfordFace
import UIKit

class Person {
    var faceID: String?
    var personImage: UIImage?
    var personImageUrl: String?
    
    init(personImageUrl: String) {
        self.personImageUrl = personImageUrl
    
        
    }
    
    func downloadFaceID() {
        if let img = personImage,let imgData = UIImageJPEGRepresentation(img, 0.8) {
            
            FaceService.instance.client.detectWithData(imgData, returnFaceId: true, returnFaceLandmarks: false, returnFaceAttributes: nil, completionBlock: { ( faces: [MPOFace]!, error: NSError!) in
                if error == nil {
                    var faceId: String?
                    for face in faces {
                        faceId = face.faceId
                        
                       
                    
                        break
                    }
                    
                    self.faceID = faceId
                    FaceService.instance.faceIDArray.append(self.faceID!)
                    
                } else {
                    print(error.debugDescription)
                    
                    
                }
                
            })

       
            
            
            
            
            
            
            
            
            
            
            
        }
        
        
    }
    
    
    
    





}


