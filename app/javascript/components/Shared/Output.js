import React from "react";
import PropTypes from "prop-types";

const Output = (props, attr, value) => {
  const attrValue = value || props[attr];
  let linkOrValue;

  if (props.finalPreview) {
    linkOrValue = (
      <a className="editable" href={props.editLinks[attr]}>
        {attrValue}
      </a>
    );
  } else {
    linkOrValue = attrValue;
  }

  const optionalClass = props.finalPreview
    ? {}
    : { className: "reactive-preview__highlight" };

  return (
    <output {...optionalClass} data-field={attr}>
      {linkOrValue}
    </output>
  );
};

Output.propTypes = {
  finalPreview: PropTypes.bool,
  editLinks: PropTypes.array
};

export default Output;
