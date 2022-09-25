import Fluent
import FluentPostgresDriver
import Vapor

/*  stop - rm postgres et start */
/*
 docker stop postgres

 docker rm postgres
 
 docker run --name postgres -e POSTGRES_DB=vapor_database \
   -e POSTGRES_USER=vapor_username \
   -e POSTGRES_PASSWORD=vapor_password \
   -p 5432:5432 -d postgres
 
 */

// configures your application
public func configure(_ app: Application) throws {
    // uncomment to serve files from /Public folder
    // app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))

    app.databases.use(.postgres(
        hostname: Environment.get("DATABASE_HOST") ?? "localhost",
        port: Environment.get("DATABASE_PORT").flatMap(Int.init(_:)) ?? PostgresConfiguration.ianaPortNumber,
        username: Environment.get("DATABASE_USERNAME") ?? "vapor_username",
        password: Environment.get("DATABASE_PASSWORD") ?? "vapor_password",
        database: Environment.get("DATABASE_NAME") ?? "vapor_database"
    ), as: .psql)
    app.http.server.configuration.port = 8080
    //app.migrations.add(CreateTodo())
    app.migrations.add(CreateUser())
    app.migrations.add(CreateRecette())
    app.migrations.add(CreateIngredient())
    app.migrations.add(CreateCategory())
   app.migrations.add(CreateAcronymCategoryPivot())
    app.logger.logLevel = .debug
    try app.autoMigrate().wait()
    // register routes
    try routes(app)
}
