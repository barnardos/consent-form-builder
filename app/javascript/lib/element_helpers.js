/* eslint import/unambiguous:0 */
function addClass(element, className) {
  if (!element) return;
  if (isNodeList(element)) {
    for (let pos = element.length - 1; pos > -1; pos -= 1) {
      addClass(element.item(pos), className);
    }
  } else if (element.classList) {
    element.classList.add(className);
  } else if (!hasClass(element, className)) {
    element.className += " " + className;
  }
}

function removeClass(element, className) {
  if (!element) return;
  if (isNodeList(element)) {
    for (let pos = element.length - 1; pos > -1; pos -= 1) {
      removeClass(element.item(pos), className);
    }
  } else if (element.classList) {
    element.classList.remove(className);
  } else if (hasClass(element, className)) {
    const regClass = new RegExp(`(\\s|^)${className}(\\s|$`);
    element.className = element.className.replace(regClass, " ");
  }
}

function hasClass(element, className) {
  if (!element) {
    return false;
  }

  if (element.classList) {
    return element.classList.contains(className);
  }
  return element.className.match(new RegExp(`(\\s|^)${className}(\\s|$`));
}

function isNodeList(nodes) {
  const stringRepr = Object.prototype.toString.call(nodes);

  return (
    typeof nodes === "object" &&
    /^\[object (HTMLCollection|NodeList|Object)\]$/.test(stringRepr) &&
    typeof nodes.length === "number" &&
    (nodes.length === 0 ||
      (typeof nodes[0] === "object" && nodes[0].nodeType > 0))
  );
}

module.exports = {
  addClass,
  removeClass,
  hasClass
};
