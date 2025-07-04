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
        {Property: SumArticles},
        {Property: ActiveTime},
        {Property: DeliveryTime},
        {Property: DrivingTime},
        {Property: VehicleCost},
       

    ]};


annotate service.characteristics with @(

    UI.Chart#MainChart: {

        Title : '{i18n>Characteristics Correlations}',
        ChartType : #Scatter,
        Dimensions : [Route],
        DynamicMeasures: ['@Analytics.AggregatedProperty#CustomerNumber',
      '@Analytics.AggregatedProperty#SumWeight',
      '@Analytics.AggregatedProperty#DeliveryTime', ],
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
    },

    Analytics.AggregatedProperty #Articles : {
        $Type : 'Analytics.AggregatedPropertyType',
        Name : 'NumberofArticles',
        AggregatableProperty : SumArticles,
        AggregationMethod : 'sum',
        ![@Common.Label] : 'Number of Articles'
    },
        Analytics.AggregatedProperty #ActiveTime : {
        $Type : 'Analytics.AggregatedPropertyType',
        Name : 'TotalActiveTime',
        AggregatableProperty : ActiveTime,
        AggregationMethod : 'sum',
        ![@Common.Label] : '{i18n>Total Active Time (min)}',
        },

    Analytics.AggregatedProperty #DeliveryTime : {
        $Type : 'Analytics.AggregatedPropertyType',
        Name : 'TotalDeliveryTime',
        AggregatableProperty : DeliveryTime,
        AggregationMethod : 'sum',
        ![@Common.Label] : '{i18n>Total Delivery Time (Min)}',
    },

    Analytics.AggregatedProperty #VehicleCost : {
        $Type : 'Analytics.AggregatedPropertyType',
        Name : 'TotalVehicleCost',
        AggregatableProperty : VehicleCost,
        AggregationMethod : 'sum',
        ![@Common.Label] : '{i18n>Total Vehicle Cost (€/km)}',
    },
    Analytics.AggregatedProperty #DrivingTime : {
        $Type : 'Analytics.AggregatedPropertyType',
        Name : 'TotalDrivingTime',
        AggregatableProperty : DrivingTime,
        AggregationMethod : 'sum',
        ![@Common.Label] : '{i18n>Total Driving Time (min)}',
    }
);

 annotate service.characteristics with @UI.PresentationVariant#MainChartView: {
  Visualizations: ['@UI.Chart#MainChart', '@UI.LineItem'],
  RequestAtLeast: []
};

 annotate service.characteristics with @UI.LineItem: [
    {
            $Type : 'UI.DataFieldForAction',
            Action : 'scenariocharacteristics.EntityContainer/checkAI',
            Label : '{i18n>Evaluate_AI}'
        },
  { Value: Route, @UI.Importance: #High, Label: 'Route' },
  { Value: CustomerNumber, @UI.Importance: #High, Label: 'Amount of Customers' },
  { Value: AverageServiceTime, @UI.Importance: #High, Label: 'Average Service Time (min)',  },
  { Value: SumArticles, @UI.Importance: #High, Label: 'Total Number of Articles' },
  { Value: DeliveryTime, @UI.Importance: #High, Label: ' Total Delivery Time(min)' },
  { Value: DrivingTime, @UI.Importance: #High, Label: 'Total Driving Time (min)' },
];
 

annotate service.characteristics with @UI.SelectionPresentationVariant: {
  SelectionVariant: { SelectOptions: [] },
  PresentationVariant: @UI.PresentationVariant#MainChartView
};
annotate service.characteristics with @Capabilities.SearchRestrictions.Searchable: false;

