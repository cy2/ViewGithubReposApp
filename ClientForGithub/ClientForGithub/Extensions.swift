//
//  Extensions.swift
//  ClientForGithub
//
//  Created by cm2y on 1/25/15.
//  Copyright (c) 2015 cm2y. All rights reserved.
//

import Foundation



  //an Extention of the String class to add valdation(regex) to the seach bars
extension String {

  func validate() -> Bool {
    
    //list all the range of acceptable characters
    let regex = NSRegularExpression(pattern: "[^0-9a-zA-Z\n]", options: nil, error: nil)
    
    let elements = countElements(self)
    
    let range = NSMakeRange(0, elements)
    
    let matches = regex?.numberOfMatchesInString(self, options: nil, range: range)
    
    if matches > 0 {
    
      return false
    }
    
    return true
  }
  
}