//
//  File.swift
//  
//
//  Created by Lunack on 25/09/2022.
//

import Vapor

// 1
struct CategoriesController: RouteCollection {
  // 2
  func boot(routes: RoutesBuilder) throws {
    // 3
    let categoriesRoute = routes.grouped("categories")
    // 4
    categoriesRoute.post(use: createHandler)
    categoriesRoute.get(use: getAllHandler)
    categoriesRoute.get(":categoryID", use: getHandler)
    categoriesRoute.get(
        ":categoryID",
        "ingredients",
        use: getIngredientsHandler)
  }
  
  // 5
  func createHandler(_ req: Request)
    throws -> EventLoopFuture<Category> {
    // 6
    let category = try req.content.decode(Category.self)
    return category.save(on: req.db).map { category }
  }
  
  // 7
  func getAllHandler(_ req: Request)
    -> EventLoopFuture<[Category]> {
    // 8
    Category.query(on: req.db).all()
  }
  
  // 9
  func getHandler(_ req: Request)
    -> EventLoopFuture<Category> {
    // 10
    Category.find(req.parameters.get("categoryID"), on: req.db)
      .unwrap(or: Abort(.notFound))
  }
    
    
    func getIngredientsHandler(_ req: Request)
      -> EventLoopFuture<[Ingredient]> {
      // 2
      Category.find(req.parameters.get("ingredientID"), on: req.db)
        .unwrap(or: Abort(.notFound))
        .flatMap { category in
          // 3
          category.$ingredients.get(on: req.db)
        }
    }
}
