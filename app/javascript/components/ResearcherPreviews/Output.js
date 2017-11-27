import React from "react"

const Output = (props, attr) => {
  const attrValue = props[attr]
  let linkOrValue

  if (props.finalPreview) {
    linkOrValue = (
      <a className="editable" href={props.editLinks[attr]}>
        {attrValue}
      </a>
    )
  } else {
    linkOrValue = attrValue
  }

  return (
    <output className="highlight">
      {linkOrValue}
    </output>
  )
}

export default Output
