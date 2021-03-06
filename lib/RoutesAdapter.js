// Generated by CoffeeScript 1.9.0
var API, RoutesAdapter, e;

RoutesAdapter = (function() {
  RoutesAdapter.prototype.required = ['router'];

  function RoutesAdapter(_at_params) {
    var _ref;
    this.params = _at_params;
    if ((_ref = this.params.app) != null) {
      _ref.on('request', (function(_this) {
        return function() {
          return _this.requestHandler.apply(_this, arguments);
        };
      })(this));
    }
  }

  RoutesAdapter.prototype.addRoute = function(route, method, handler) {
    var _base, _name;
    return typeof (_base = this.params.router)[_name = method.toLowerCase()] === "function" ? _base[_name](route, handler || this.responseHandler) : void 0;
  };

  RoutesAdapter.prototype.requestHandler = function(req, res) {
    return this.params.router(req, res, this.responseHandler);
  };

  RoutesAdapter.prototype.responseHandler = function(res, data, headers) {
    var header, value;
    if (!headers) {
      res.setHeader('Content-Type', 'application/json');
    } else {
      for (header in headers) {
        value = headers[header];
        res.setHeader(header, value);
      }
    }
    res.writeHead("" + data.status, data.status !== 200 ? "" + data.content : 'ok');
    return res.end(data.status === 200 ? (typeof data.content === 'object' ? JSON.stringify(data.content) : data.content) : "");
  };

  return RoutesAdapter;

})();

module.exports = RoutesAdapter;

try {
  if ((API = require('rikki-tikki')) == null) {
    API = require('../../rikki-tikki');
  }
  API.registerAdapter('routes', RoutesAdapter);
} catch (_error) {
  e = _error;
  console.log(e);
  console.log('RoutesAdapter not registered.\nreason: rikki-tikki was not found');
}

module.exports.use = (function(_this) {
  return function(http, router) {
    return new RoutesAdapter({
      app: http,
      router: router
    });
  };
})(this);
