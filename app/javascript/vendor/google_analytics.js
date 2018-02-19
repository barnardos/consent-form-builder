(function() {
  const head = document.getElementsByTagName("head")[0];
  const googleAnalyticsCode = window.googleAnalyticsCode || "UA-000000-00";

  let script = document.createElement("script");
  script.async = 1;
  script.src =
    "https://www.googletagmanager.com/gtag/js?id=" + googleAnalyticsCode;

  head.appendChild(script);

  window.dataLayer = window.dataLayer || [];
  function gtag() {
    dataLayer.push(arguments);
  }
  gtag("js", new Date());
  gtag("config", googleAnalyticsCode);
})();
