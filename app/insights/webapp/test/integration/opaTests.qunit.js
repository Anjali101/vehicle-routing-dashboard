sap.ui.require(
    [
        'sap/fe/test/JourneyRunner',
        'insights/insights/test/integration/FirstJourney',
		'insights/insights/test/integration/pages/ScenarioInsightsList',
		'insights/insights/test/integration/pages/ScenarioInsightsObjectPage'
    ],
    function(JourneyRunner, opaJourney, ScenarioInsightsList, ScenarioInsightsObjectPage) {
        'use strict';
        var JourneyRunner = new JourneyRunner({
            // start index.html in web folder
            launchUrl: sap.ui.require.toUrl('insights/insights') + '/index.html'
        });

       
        JourneyRunner.run(
            {
                pages: { 
					onTheScenarioInsightsList: ScenarioInsightsList,
					onTheScenarioInsightsObjectPage: ScenarioInsightsObjectPage
                }
            },
            opaJourney.run
        );
    }
);