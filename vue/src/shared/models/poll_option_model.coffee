import BaseModel  from  '@/shared/record_store/base_model'
import Records  from  '@/shared/services/records'
import {map, parseInt, slice, max} from 'lodash'
import I18n from '@/i18n'

export default class PollOptionModel extends BaseModel
  @singular: 'pollOption'
  @plural: 'pollOptions'
  @indices: ['pollId']
  @uniqueIndices: ['id']
  @serializableAttributes: ['id', 'name', 'icon', 'priority', 'meaning', 'prompt']

  defaultValues: ->
    voterScores: {}
    name: null
    icon: null
    meaning: null
    prompt: null
    priority: null
    _destroy: null

  relationships: ->
    @belongsTo 'poll'

  stances: ->
    @poll().latestStances().filter((s) => s.pollOptionIds().includes(@id))

  beforeRemove: ->
    @stances().forEach (stance) -> stance.remove()

  optionName: ->
    poll = @poll()
    switch poll.pollOptionNameFormat
      when 'plain' then @name
      when 'i18n' then i18n.t('poll_' + poll.pollType + '_options.' + @name)
      else
        console.error 'unsupported option format', poll.pollOptionNameFormat
