//
//  File.swift
//  
//
//  Created by Lunack on 25/09/2022.
//

import Foundation
import Vapor

// 1
struct UsersController: RouteCollection {
  // 2
  func boot(routes: RoutesBuilder) throws {
    // 3
      // localhost:8080/utilisateurs
    let usersRoute = routes.grouped("utilisateurs")
    // 4
    usersRoute.post(use: createHandler)
    usersRoute.get(use: getAllHandler)
      // 2
    usersRoute.get(":userID", use: getHandler)
  }

  // 5
  func createHandler(_ req: Request)
    throws -> EventLoopFuture<Utilisateur.Public> {
    // 6
    let user = try req.content.decode(Utilisateur.self)
        user.password = try Bcrypt.hash(user.password)
    // 7
        return user.save(on: req.db).map { user.convertToPublic() }
  }
    
    
    func getAllHandler(_ req: Request)
    -> EventLoopFuture<[Utilisateur.Public]> {
      // 2
        Utilisateur.query(on: req.db).with(\.$recettes).all().convertToPublic()
    }

    // 3
    func getHandler(_ req: Request)
    -> EventLoopFuture<Utilisateur.Public> {
      // 4
          
     Utilisateur.find(req.parameters.get("userID"), on: req.db)
          .unwrap(or: Abort(.notFound))
          .convertToPublic()
    }
}
