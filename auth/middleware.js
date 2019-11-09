function authMiddleware () {
  return function (req, res, next) {
    if (req.isAuthenticated()) {
      return next()
    }
    res.redirect('/login?msg=please%20login%20first')
  }
}

module.exports = authMiddleware
