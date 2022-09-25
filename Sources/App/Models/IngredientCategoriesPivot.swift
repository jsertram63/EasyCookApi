//
//  File.swift
//  
//
//  Created by Lunack on 25/09/2022.
//

import Foundation
import Fluent


// 1
final class IngredientCategoryPivot: Model {
  static let schema = "ingredient-category"
  
  // 2
  @ID
  var id: UUID?
  
  // 3
  @Parent(key: "ingredientID")
  var ingredient: Ingredient
  
  @Parent(key: "categoryID")
  var category: Category
  
  // 4
  init() {}
  
  // 5
  init(
    id: UUID? = nil,
    ingredient: Ingredient,
    category: Category
  ) throws {
    self.id = id
    self.$ingredient.id = try ingredient.requireID()
    self.$category.id = try category.requireID()
  }
}
