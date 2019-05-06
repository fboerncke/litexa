
###

 * ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 * Copyright 2019 Amazon.com (http://amazon.com/), Inc. or its affiliates. All Rights Reserved.
 * These materials are licensed as "Restricted Program Materials" under the Program Materials
 * License Agreement (the "Agreement") in connection with the Amazon Alexa voice service.
 * The Agreement is available at https://developer.amazon.com/public/support/pml.html.
 * See the Agreement for the specific terms and conditions of the Agreement. Capitalized
 * terms not defined in this file have the meanings given to them in the Agreement.
 * ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

###


assert = require 'assert'
debug = require('debug')('litexa')
{runSkill, expectParse, expectFailParse} = require '../preamble.coffee'

describe 'supports intent statements', ->
  it 'runs the intents integration test', ->
    runSkill 'intents'

  it 'does not allow wrong indentation of intents', ->
    expectParse """
    waitForResponse
      say "hello"
      when AMAZON.YesIntent
        say "yes"

      when AMAZON.NoIntent
        say "no"
      say "post processor"
    """

    expectFailParse """
    waitForResponse
      when AMAZON.YesIntent
        say "hello"

        when AMAZON.NoIntent
          say "hi"
    """

    expectFailParse """
    waitForResponse
      say "howdy."

      when AMAZON.YesIntent
        say "hello"
        if 3 > 1
          when AMAZON.YesIntent
            say "meow"
          when AMAZON.NoIntent
            say "bork"
    """

    expectFailParse """
    waitForResponse
      say "howdy."

      when "nested level"
        say "hello"
        if 3 > 1
          if 4 > 3
            say "one more nested level"
            when "another level"
              say "meow"
            when AMAZON.NoIntent
              say "bork"
    """

    expectFailParse """
    someState
      when "hi"
        say "hi"
    when "imposter state"
      say "hello"
    """
  
  it 'does not allow duplicate intents in the same state', ->
    expectParse """
    someState
      when "yes"
        say "wahoo"
      when AMAZON.NoIntent
        say "aww"
    
    anotherState
      when "yes"
        or "yea"
        say "wahoo"
      when AMAZON.NoIntent
        say "aww"
    """

    expectFailParse """
    someState
      when "meow"
        or "mreow"
        say "meow meow"
      when AMAZON.NoIntent
        say "aww"
      when "Meow"
        say "meow meow"
    """, "redefine intent `MEOW`"

    expectFailParse """
    waitForAnswer
      when "Yea"
        or "yes"
        say "You said"

      when AMAZON.NoIntent
        say "You said"
      
      when AMAZON.NoIntent
        say "no."
    """, "redefine intent `AMAZON.NoIntent`"

    expectParse """
    global 
      when AMAZON.StopIntent
        say "Goodbye."
        END

      when AMAZON.CancelIntent
        say "Bye."
        END
      
      when AMAZON.StartOverIntent
        say "No."
        END
    """

    expectFailParse """
    global 
      when AMAZON.StopIntent
        say "Goodbye."
        END

      when AMAZON.CancelIntent
        say "Bye"
      
      when AMAZON.StartOverIntent
        say "No."
        END
      
      when AMAZON.CancelIntent
        say "bye."
        END
    """

    expectFailParse """
    global 
      when AMAZON.YesIntent
        say "Goodbye."
        END

      when AMAZON.CancelIntent
        say "Bye"
      
      when AMAZON.StartOverIntent
        say "No."
        END
      
      when AMAZON.YesIntent
        say "bye."
        END
    """

