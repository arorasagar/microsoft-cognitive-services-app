//
//  FaceService.swift
//  MissingPersons
//
//  Created by Sagar Arora  on 6/15/16.
//  Copyright © 2016 Sagar Arora . All rights reserved.
//

import Foundation
import ProjectOxfordFace


class FaceService {
    static let instance = FaceService()
    
    


    let client = MPOFaceServiceClient(subscriptionKey: "9e4e5366c5334e4fa707242d1245c98c")
    var faceIDArray = [String]()


}