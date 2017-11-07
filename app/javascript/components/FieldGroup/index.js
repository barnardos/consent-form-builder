import React from 'react';
import './index.css';

const FieldGroup = props => {
  const { name, label, children } = props

  return (
    <fieldset className="fieldset">
      <label htmlFor={name} className="label">
        {label}
      </label>
      {children}
    </fieldset>
  )
};

export default FieldGroup
