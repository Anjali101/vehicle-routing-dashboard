sap.ui.require(
    [
        'sap/fe/test/JourneyRunner',
        'vrp/classify/classifyvrptest/test/integration/FirstJourney',
		'vrp/classify/classifyvrptest/test/integration/pages/RoutelocationsList',
		'vrp/classify/classifyvrptest/test/integration/pages/RoutelocationsObjectPage'
    ],
    function(JourneyRunner, opaJourney, RoutelocationsList, RoutelocationsObjectPage) {
        'use strict';
        var JourneyRunner = new JourneyRunner({
            // start index.html in web folder
            launchUrl: sap.ui.require.toUrl('vrp/classify/classifyvrptest') + '/index.html'
        });

       
        JourneyRunner.run(
            {
                pages: { 
					onTheRoutelocationsList: RoutelocationsList,
					onTheRoutelocationsObjectPage: RoutelocationsObjectPage
                }
            },
            opaJourney.run
        );
    }
);