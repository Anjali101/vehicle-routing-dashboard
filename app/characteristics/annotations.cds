using scenariocharacteristics as service from '../../srv/processors-service';





annotate service.characteristics with  @UI.SelectionFields  : [ Route];

annotate service.characteristics with @Aggregation.ApplySupported  : {
    Transformations : ['aggregate', 'groupby'],
    GroupableProperties : [Route],
    AggregatableProperties: [
       
        
        {Property: SumWeight},
        {Property: SumVolume},
        {Property: AverageServiceTime},
        {Property: CustomerNumber},
       

    ]};


annotate service.characteristics with @(

    UI.Chart#MainChart: {

        Title : '{i18n>Route Instances Overview}',
        ChartType : #Bubble,
        Dimensions : [Route],
        DynamicMeasures: ['@Analytics.AggregatedProperty#CustomerNumber','@Analytics.AggregatedProperty#SumWeight','@Analytics.AggregatedProperty#SumVolume', '@Analytics.AggregatedProperty#AvgServiceTime' ],
        },

        Analytics.AggregatedProperty #CustomerNumber : {
        $Type : 'Analytics.AggregatedPropertyType',
        Name : 'NumberofCustomers',
        AggregatableProperty : CustomerNumber,
        AggregationMethod : 'sum',
        ![@Common.Label] : ' {i18n>Number of Customers per route}',
    },
    Analytics.AggregatedProperty #SumWeight : {
        $Type : 'Analytics.AggregatedPropertyType',
        Name : 'SumWeight',
        AggregatableProperty : SumWeight,
        AggregationMethod : 'sum',
        ![@Common.Label] : '{i18n>Total Package Weight per Route(kg)}'},

     Analytics.AggregatedProperty #SumVolume : {
        $Type : 'Analytics.AggregatedPropertyType',
        Name : 'TotalVolume',
        AggregatableProperty : SumVolume,
        AggregationMethod : 'sum',
        ![@Common.Label] : 'Total Package Volume per Route (m^3)',},

    
    Analytics.AggregatedProperty #AvgServiceTime : {
        $Type : 'Analytics.AggregatedPropertyType',
        Name : 'AvgServiceTime',
        AggregatableProperty : AverageServiceTime,
        AggregationMethod : 'average',
        ![@Common.Label] : 'Average Service Time (min)'
    }
);

 annotate service.characteristics with @UI.PresentationVariant#MainChartView: {
  Visualizations: ['@UI.Chart#MainChart', '@UI.LineItem'],
  RequestAtLeast: []
};

 annotate service.characteristics with @UI.LineItem: [
  { Value: Route, @UI.Importance: #High },
  { Value: CustomerNumber, @UI.Importance: #High },
  { Value: SumWeight, @UI.Importance: #High },
  { Value: SumVolume, @UI.Importance: #High },
  { Value: AverageServiceTime, @UI.Importance: #High }
];
 

annotate service.characteristics with @UI.SelectionPresentationVariant: {
  SelectionVariant: { SelectOptions: [] },
  PresentationVariant: @UI.PresentationVariant#MainChartView
};
