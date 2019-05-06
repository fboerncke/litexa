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

import {assert} from 'chai';
import {spy} from 'sinon';
import {Time} from '@lib/services/time.service';

describe('Time', () => {
    let mockDate: any;
    beforeEach(() => {
        mockDate = {
            getDay: () => {
                return 0;
            }
        };
    });
    describe('#serverTimeGetDay', () => {
        it('returns the day', () => {
            const dateSpy = spy(mockDate, 'getDay');
            Time.serverTimeGetDay(mockDate);
            assert(dateSpy.calledOnce, 'got the day');
        });
    });
});
