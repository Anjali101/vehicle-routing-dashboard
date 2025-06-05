sap.ui.require(
    [
        'sap/fe/test/JourneyRunner',
        'vrptest/test/integration/FirstJourney',
		'vrptest/test/integration/pages/RouteAggregatedList',
		'vrptest/test/integration/pages/RouteAggregatedObjectPage'
    ],
    function(JourneyRunner, opaJourney, RouteAggregatedList, RouteAggregatedObjectPage) {
        'use strict';
        var JourneyRunner = new JourneyRunner({
            // start index.html in web folder
            launchUrl: sap.ui.require.toUrl('vrptest') + '/index.html'
        });

       
        JourneyRunner.run(
            {
                pages: { 
					onTheRouteAggregatedList: RouteAggregatedList,
					onTheRouteAggregatedObjectPage: RouteAggregatedObjectPage
                }
            },
            opaJourney.run
        );
    }
);