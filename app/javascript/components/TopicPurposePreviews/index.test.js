import React from 'react'
import TopicPurposePreviews from './index.js'

describe('TopicPurposePreviews', () => {
  let props
  let mountedTopicPurposePreviews
  const topicPurposePreviews = () => {
    if (!mountedTopicPurposePreviews) {
      mountedTopicPurposePreviews = mount(
        <TopicPurposePreviews {...props} />
      )
    }
    return mountedTopicPurposePreviews
  }

  /* I18n labels */
  const labels = {
    topic: 'Barnardo\'s is doing research to learn about',
    purpose: 'so that we can'
  }

  beforeEach(() => {
    props = {
      topic: undefined,
      purpose: undefined,
      labels: undefined,
      finalPreview: undefined,
      editLinks: {}
    }
    mountedTopicPurposePreviews = undefined
  })

  describe('the initial render state', () => {
    describe('no props are given', () => {
      beforeEach(() => {
        props = {
          labels: labels
        }
      })

      it('has a header', () => {
        const header = topicPurposePreviews().find('h3')
        expect(header.length).to.eql(1)
      })

      it('has a blank output for topic and one for purpose', () => {
        let outputs = topicPurposePreviews().find('output')
        expect(outputs.length).to.eql(2)
        outputs.forEach(output => expect(output.text()).to.be.empty)
      })
    })

    describe('props for the finalPreview are given', () => {
      beforeEach(() => {
        props = {
          finalPreview: true,
          topic: 'how young people use mobile devices',
          purpose: 'help them etc',
          labels: labels,
          editLinks: {
            topic: '/rails/path/to/topic',
            purpose: '/rails/path/to/purpose'
          }
        }
      })

      it('renders the topic and purpose in a readable sentence', () => {
        expect(topicPurposePreviews().text()).to.contain(
          `Barnardo's is doing research to learn about ` +
          `${props.topic} so that we can ${props.purpose}`
        )
      })
      it('renders an editLink with the supplied rails route for the topic', () => {
        expect(topicPurposePreviews()).to.contain(
          <output>
            <a className="editable" href="/rails/path/to/topic">{props.topic}</a>
          </output>
        )
      })
      it('renders an editLink with the supplied rails route for the purpose', () => {
        expect(topicPurposePreviews()).to.contain(
          <output>
            <a className="editable" href="/rails/path/to/purpose">{props.purpose}</a>
          </output>
        )
      })
    })
  })

  describe('values changing', () => {
    describe('the topic changing', () => {
      beforeEach(() => {
        props = {
          topic: 'an old topic',
          labels: labels
        }
      })

      describe('receipt of an input change', () => {
        // Simulate change from a field such as
        // <input name="research_session[researcher_name]" data-previewed-by="TopicPurposePreviews" />
        // - usually triggered oninput, but that link is not tested here, we're just simulating the
        //   resulting event

        it('changes the topic', () => {
          topicPurposePreviews().instance().handleTextChange({
            target: { name: 'research_session[topic]', value: 'a new topic' }
          })

          expect(topicPurposePreviews().find('output').first().text()).to.eql('a new topic')
        })
      })
    })
  })
})
