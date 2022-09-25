//
//  File.swift
//  
//
//  Created by Lunack on 25/09/2022.
//

import Foundation
import Fluent

// 1
struct CreateAcronymCategoryPivot: Migration {
  // 2
  func prepare(on database: Database) -> EventLoopFuture<Void> {
    // 3
    database.schema("ingredient-category")
      // 4
      .id()
      // 5
      .field("ingredientID", .uuid, .required,
        .references("ingredients", "id", onDelete: .cascade))
      .field("categoryID", .uuid, .required,
        .references("categoriesDB", "id", onDelete: .cascade))
      // 6
      .create()
  }
  
  // 7
  func revert(on database: Database) -> EventLoopFuture<Void> {
    database.schema("ingredient-category").delete()
  }
}
