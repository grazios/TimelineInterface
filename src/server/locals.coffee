module.exports = (app, db) ->
  app.use (req, res, next)->
    app.locals.isAuthorized = req.isAuthenticated()
    if app.locals.isAuthorized
      app.locals.user = req.user
    next()
