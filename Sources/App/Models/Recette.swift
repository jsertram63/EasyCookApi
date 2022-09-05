//
//  File.swift
//  
//
//  Created by Lunack on 29/08/2022.
//

import Foundation
import Vapor
import Fluent

final class Recette: Model, Content {
    static var schema: String = "recette"
    @ID(key: .id)
    var id:UUID?
    @Field(key:"name")
    var name:String
    @Field(key:"imageURL")
    var imageURL:String
    @Field(key:"description")
    var description: String
    
    init(id:UUID,name:String, imageURL:String,description:String){
        self.id = id
        self.name = name
        self.description = description
        self.imageURL = imageURL
    }
}
