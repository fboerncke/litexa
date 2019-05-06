/*
 * ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 * Copyright 2019 Amazon.com (http://amazon.com/), Inc. or its affiliates. All Rights Reserved.
 * These materials are licensed as "Restricted Program Materials" under the Program Materials
 * License Agreement (the "Agreement") in connection with the Amazon Alexa voice service.
 * The Agreement is available at https://developer.amazon.com/public/support/pml.html.
 * See the Agreement for the specific terms and conditions of the Agreement. Capitalized
 * terms not defined in this file have the meanings given to them in the Agreement.
 * ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 */

const stringBuilder = require('./aplParserHelpers').ObjectStringBuilder;

module.exports = function(lib) {
  return function (document = undefined) {
    this.attributes = {
      document: document,
      data: undefined,
      commands: undefined
    };

    this.pushAttribute = function(location, key, value) {
      switch (key) {
        case 'token':
          if (typeof(value.toExpression) !== 'function' && typeof(value) !== 'string') {
            throw new lib.ParserError(location, `Attribute '${key}' expects a String, but found a '${typeof(value)}' instead.`);
          }
          break;

        case 'document':
        case 'data':
        case 'commands':
          if (typeof(value) !== 'object') {
            throw new lib.ParserError(location, `Attribute '${key}' expects a value of type 'object', but found a '${typeof(value)}' instead.`);
          }
          break;

        default:
          throw new lib.ParserError(location, `Unknown attribute '${key}' found in APL statement.`);
      }
      // No invalid keys/values found.
      this.attributes[key] = value;
    }

    this.toLambda = function(output, indent, options) {

      let aplString = stringBuilder.parseAndStringify({
        options,
        indent,
        attributes: this.attributes,
        ParserError: lib.ParserError
      });

      output.push(`context.apl = context.apl || [];`);
      output.push(`context.apl.push(${aplString});`);

      // Let's add a speech marker, which will allow us to push speech into ExecuteCommands.
      output.push(`context.aplSpeechMarkers = context.aplSpeechMarkers || [];`);
      output.push(`context.aplSpeechMarkers.push(context.say.length);`);
    }

    this.collectRequiredAPIs = function(apis) {
      apis['ALEXA_PRESENTATION_APL'] = true;
    }
  };
}
