/*
  Take an array like ['voice', 'other', 'video'] and a hash like
  {
    'voice': '...',
    'video': '...',
    'something_else': '...'
  }
  and return an array of keys in the order encountered in the hash, like
  => ['voice', 'video', 'other']

  'other' isn't expected to be present in the hash and will always come last.
 */
function sortAgainst(array, hash) {
  const hashKeys = Object.keys(hash);
  hashKeys.push("other");

  const index = array.reduce((hash, key) => {
    hash[key] = hashKeys.indexOf(key);
    return hash;
  }, {});
  return array.sort((a, b) => (index[a] > index[b] ? 1 : -1));
}

export default sortAgainst;
