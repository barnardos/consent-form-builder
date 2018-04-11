import React from "react";
import PropTypes from "prop-types";
import Output from "./Output";
import sortAgainst from "./sort-against";

const WeWillRecordBy = props => {
  let listItems;

  if (props.methodologies) {
    const sortedMethodologies = sortAgainst(
      props.methodologies,
      props.all_methodologies
    );
    listItems = sortedMethodologies.map(method => {
      if (method === "other") {
        return <li key={method}>{Output(props, "other_methodology")}</li>;
      }

      return (
        <li key={method}>
          {Output(props, "methodologies", props.all_methodologies[method])}
        </li>
      );
    });
  } else {
    listItems = (
      <li>
        <output className="reactive-preview__highlight" />
      </li>
    );
  }

  return <ul className="bullet-point-list">{listItems}</ul>;
};

WeWillRecordBy.propTypes = {
  methodologies: PropTypes.array,
  all_methodologies: PropTypes.object,
  other_methodology: PropTypes.string,
  able_to_consent: PropTypes.bool,
  researcher_name: PropTypes.string
};

export default WeWillRecordBy;
