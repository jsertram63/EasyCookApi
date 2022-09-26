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
    init() {
    }
    
    static var schema: String = "recette"
    @ID(key: .id)
    var id:UUID?
    
    @Field(key:"name")
    var name:String
    
    @Field(key:"imageURL")
    
    var imageURL:String
    @Field(key:"description")
    var description: String
    
    @Parent(key: "userID")
    var user: Utilisateur
    
    
    @Children(for: \.$recette)
    var ingredients:[Ingredient]
    
    
    
    init(id:UUID? = nil,name:String, imageURL:String,description:String,userID: Utilisateur.IDValue){
        self.id = id
        self.name = name
        self.description = description
        self.imageURL = imageURL
        self.$user.id = userID
    }
}
