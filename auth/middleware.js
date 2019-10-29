function authMiddleware () {
  return function (req, res, next) {
    if (req.isAuthenticated()) {
      return next()
    }
    res.redirect('/login?login=authwalled')
  }
}

module.exports = authMiddleware
