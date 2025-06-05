sap.ui.require(
    [
        'sap/fe/test/JourneyRunner',
        'project3/test/integration/FirstJourney',
		'project3/test/integration/pages/RoutelocationsList',
		'project3/test/integration/pages/RoutelocationsObjectPage'
    ],
    function(JourneyRunner, opaJourney, RoutelocationsList, RoutelocationsObjectPage) {
        'use strict';
        var JourneyRunner = new JourneyRunner({
            // start index.html in web folder
            launchUrl: sap.ui.require.toUrl('project3') + '/index.html'
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