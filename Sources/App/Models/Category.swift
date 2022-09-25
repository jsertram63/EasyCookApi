//
//  File.swift
//  
//
//  Created by Lunack on 25/09/2022.
//

//
//  File.swift
//
//
//  Created by Lunack on 12/09/2022.
//

import Fluent
import Vapor

import Fluent
import Vapor

final class Category: Model, Content {
  static let schema = "categoriesDB"
  
  @ID
  var id: UUID?
  
  @Field(key: "name")
  var name: String
    
    @Siblings(
      through: IngredientCategoryPivot.self,
      from: \.$category,
      to: \.$ingredient)
    var ingredients: [Ingredient]
  
  init() {}
  
  init(id: UUID? = nil, name: String) {
    self.id = id
    self.name = name
  }
}
