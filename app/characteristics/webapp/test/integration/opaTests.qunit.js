sap.ui.require(
    [
        'sap/fe/test/JourneyRunner',
        'characteristics/test/integration/FirstJourney',
		'characteristics/test/integration/pages/characteristicsList',
		'characteristics/test/integration/pages/characteristicsObjectPage'
    ],
    function(JourneyRunner, opaJourney, characteristicsList, characteristicsObjectPage) {
        'use strict';
        var JourneyRunner = new JourneyRunner({
            // start index.html in web folder
            launchUrl: sap.ui.require.toUrl('characteristics') + '/index.html'
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