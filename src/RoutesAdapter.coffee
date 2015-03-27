url     = require 'url'
path    = require 'path'
{_}     = require 'lodash'
Adapter = require 'rikki-tikki-route-adapter'
class RoutesAdapter extends Adapter
  required:['router']
  routes: []
  addRoute:(route, method, handler)->
    fn = if (match = @params.router.match route)? then match.fn else {}
    fn[method.toUpperCase()] = handler
    @routes = _.union @routes, route
    @params.router.addRoute route, fn
  requestHandler:(req, res)=>
    normalPathname = path.normalize(pathname = (parsed = url.parse req.url).pathname).replace /\\/g, '/'
    route = @params.router.match normalPathname
    return if !route
    queryToObject = (string)->
      o = {}
      decodeURIComponent(string).replace('?','').split('&').forEach (v,k)=> o[p[0]] = p[1] if (p = v.split '=').length == 2
      o
    req.params  = route.params
    req.query   = queryToObject req.url.split('?').pop()
    if (route.route? and @routes.lastIndexOf route.route) >= 0
      return route.fn[req.method] req, res
    else
      return route.fn req, res
  responseHandler:(res, data, headers)->
    if !headers
      res.setHeader 'Content-Type', 'application/json'
    else
      for header,value of headers
        console.log "#{header}: #{value}"
        res.setHeader header, value
    res.writeHead "#{data.status}", if data.status != 200 then "#{data.content}" else 'ok'
    res.end if data.status == 200 then (if typeof data.content is 'object' then JSON.stringify data.content else data.content) else ""
module.exports = RoutesAdapter