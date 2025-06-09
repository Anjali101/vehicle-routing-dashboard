sap.ui.require(
    [
        'sap/fe/test/JourneyRunner',
        'classification/test/integration/FirstJourney',
		'classification/test/integration/pages/CustomerArticleSummaryList',
		'classification/test/integration/pages/CustomerArticleSummaryObjectPage'
    ],
    function(JourneyRunner, opaJourney, CustomerArticleSummaryList, CustomerArticleSummaryObjectPage) {
        'use strict';
        var JourneyRunner = new JourneyRunner({
            // start index.html in web folder
            launchUrl: sap.ui.require.toUrl('classification') + '/index.html'
        });

       
        JourneyRunner.run(
            {
                pages: { 
					onTheCustomerArticleSummaryList: CustomerArticleSummaryList,
					onTheCustomerArticleSummaryObjectPage: CustomerArticleSummaryObjectPage
                }
            },
            opaJourney.run
        );
    }
);