const { Elm } = require('../Main.elm');
import sample from "../img/sample.png"

const app = Elm.Main.init({
  node: document.body.appendChild(document.createElement('div')),
  flags: {
    images: {
      "sample": sample
    }
  }
});


const hljs = require('highlight.js');
hljs.registerLanguage('elm', require('highlight.js/lib/languages/elm'));
hljs.registerLanguage('scss', require('highlight.js/lib/languages/scss'));
require('highlight.js/styles/a11y-dark.css');
window.hljs = hljs;

app.ports.extraJS.subscribe(() => {
  try {
    hljs.highlightAll();
  } catch (e) { }

  try {
    window.twttr.widgets.load();
  } catch (e) { }
});
