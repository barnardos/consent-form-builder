/* eslint import/unambiguous:0 */
const chai = require("chai");
const sinon = require("sinon");
const jsdom = require("jsdom");
const { JSDOM } = jsdom;

chai.use(require("sinon-chai"));
chai.use(require("chai-as-promised"));

// mocha globals
global.expect = chai.expect;
global.sinon = sinon;

chai.config.truncateThreshold = 0;

process.setMaxListeners(0);
process.stdout.setMaxListeners(0);

global.render = function(markup) {
  const { document } = new JSDOM(markup).window;
  return document;
};
