fs                = require 'fs'
path              = require 'path'
(chai             = require 'chai').should()
Adapter           = require '../src/RoutesAdapter'

describe 'RoutesAdapter Test Suite', ->
  clazz = class Tester extends Adapter
  describe 'RoutesAdapter Overrides', =>
    it 'should require app to be passed in constructor params object', =>
      chai.expect(-> 
        new clazz().requestHandler()
      ).to.throw 'required param \'router\' was not defined in the adapter params object'
  describe 'RoutesAdapter Overrides', =>
    it 'should require method requestHandler to be overriden', =>
      chai.expect(-> 
        new clazz(router:{match:(str)-> false}).requestHandler {url:'/blargh'}
      ).to.not.throw()
    it 'should require method responseHandler to be overriden', =>
      chai.expect(-> 
        new clazz(router:{}).responseHandler {setHeader:(->false), writeHead:(->false), end:(->false)}, {status:200}
      ).to.not.throw()
    it 'should require method addRoute to be overriden', =>
      chai.expect(-> 
        new clazz(router:{match:((str)-> null), addRoute:((str)-> null)}).addRoute '/blargh','get', (->false)
      ).to.not.throw()

