sap.ui.require(
    [
        'sap/fe/test/JourneyRunner',
        'sap/capire/vrp/classifyroute1/test/integration/FirstJourney',
		'sap/capire/vrp/classifyroute1/test/integration/pages/RouteClassificationList',
		'sap/capire/vrp/classifyroute1/test/integration/pages/RouteClassificationObjectPage'
    ],
    function(JourneyRunner, opaJourney, RouteClassificationList, RouteClassificationObjectPage) {
        'use strict';
        var JourneyRunner = new JourneyRunner({
            // start index.html in web folder
            launchUrl: sap.ui.require.toUrl('sap/capire/vrp/classifyroute1') + '/index.html'
        });

       
        JourneyRunner.run(
            {
                pages: { 
					onTheRouteClassificationList: RouteClassificationList,
					onTheRouteClassificationObjectPage: RouteClassificationObjectPage
                }
            },
            opaJourney.run
        );
    }
);