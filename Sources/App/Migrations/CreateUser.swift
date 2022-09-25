//
//  File.swift
//  
//
//  Created by Lunack on 25/09/2022.
//

import Foundation
import Fluent

// 1
struct CreateUser: Migration {
  // 2
  func prepare(on database: Database) -> EventLoopFuture<Void> {
    // 3
    database.schema("utilisateurs")
      // 4
      .id()
      // 5
      .field("name", .string, .required)
      .field("username", .string, .required)
      // 6
      .create()
  }
  
  // 7
  func revert(on database: Database) -> EventLoopFuture<Void> {
    database.schema("utilisateurs").delete()
  }
}
