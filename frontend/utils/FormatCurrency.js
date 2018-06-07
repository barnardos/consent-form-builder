const FormatCurreny = value => {
  return new Intl.NumberFormat("en-GB", {
    style: "currency",
    currency: "GBP"
  }).format(value);
};

export default FormatCurreny;
