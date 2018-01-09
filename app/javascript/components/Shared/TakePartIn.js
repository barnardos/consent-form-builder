import React from "react";
import PropTypes from "prop-types";
import Output from "./Output";

const TakePartIn = props => {
  const colonOrEllipsis = props.methodologies ? ":" : <span>&hellip;</span>;

  let jobTitle = "";

  if (props.researcher_job_title) {
    jobTitle = (
      <span>
        {", "}
        {Output(props, "researcher_job_title")}
        {","}
      </span>
    );
  }

  return (
    <p>
      {Output(props, "researcher_name")}
      {jobTitle} would like {props.you_or_your_child} to take part in
      {colonOrEllipsis}
    </p>
  );
};

TakePartIn.propTypes = {
  researcher_name: PropTypes.string,
  you_or_your_child: PropTypes.string,
  researcher_job_title: PropTypes.string,
  methodologies: PropTypes.array
};

export default TakePartIn;
