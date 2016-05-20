env = (process.env.NODE_ENV or "development")
config = require("./config/env/" + env)

express = require("express")
errorHandler = require("errorhandler")
bodyParser = require("body-parser")
methodOverride = require("method-override")
cookieParser = require "cookie-parser"
session = require "express-session"


express_init_basic = (app)->
  app.set "views", __dirname + "/../client/views"
  app.set "view engine", "jade"
  app.use errorHandler()
  app.use bodyParser.urlencoded({limit: '32mb', extended: true})
  app.use bodyParser.json({limit: '32mb'})
  app.use methodOverride()

  #app.use staticAsset __dirname + "/../public/"
  app.use express.static __dirname + "/../../public/"

express_init_routes = (app)->
  require("./routes/home")(app)


###
  Exit Initialize Methods
###
app = express()
express_init_basic(app)
express_init_routes(app)

app.listen config.express.port
