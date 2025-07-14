sap.ui.require(
    [
        'sap/fe/test/JourneyRunner',
        'insights/test/integration/FirstJourney',
		'insights/test/integration/pages/characteristicsList',
		'insights/test/integration/pages/characteristicsObjectPage'
    ],
    function(JourneyRunner, opaJourney, characteristicsList, characteristicsObjectPage) {
        'use strict';
        var JourneyRunner = new JourneyRunner({
            // start index.html in web folder
            launchUrl: sap.ui.require.toUrl('insights') + '/index.html'
        });

       
        JourneyRunner.run(
            {
                pages: { 
					onThecharacteristicsList: characteristicsList,
					onThecharacteristicsObjectPage: characteristicsObjectPage
                }
            },
            opaJourney.run
        );
    }
);