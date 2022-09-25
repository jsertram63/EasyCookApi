import Fluent
import Vapor

func routes(_ app: Application) throws {

    //try app.register(collection: TodoController())
    //let ingredientController = IngredientController()
    try app.register(collection: RecetteController())
    try app.register(collection: IngredientController())
    let usersController = UsersController()
    // 2
    try app.register(collection: usersController)

}

