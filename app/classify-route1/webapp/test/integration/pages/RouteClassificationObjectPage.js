sap.ui.define(['sap/fe/test/ObjectPage'], function(ObjectPage) {
    'use strict';

    var CustomPageDefinitions = {
        actions: {},
        assertions: {}
    };

    return new ObjectPage(
        {
            appId: 'sap.capire.vrp.classifyroute1',
            componentId: 'RouteClassificationObjectPage',
            contextPath: '/RouteClassification'
        },
        CustomPageDefinitions
    );
});