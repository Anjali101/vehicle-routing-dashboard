using Visualization as service from '../../srv/processors-service';



annotate service.Routelocations with @UI.SelectionFields  : [ Route];

annotate service.Routelocations with @Aggregation.ApplySupported  : {
    Transformations : ['aggregate', 'groupby'],
    GroupableProperties : [Route ],
    AggregatableProperties: [
       
        {Property: SumArticles},
        {Property: SumWeight},
        {Property: SumVolume},
        {Property: RouteDate},
        {Property: RouteCode},
        
        
       
    ]
    
};


annotate service.Routelocations with @(

    UI.Chart: {

        Title : '{i18n>Route Instances Overview}',
        ChartType : #Column,
        Dimensions : [Route],
        Measures: [SumArticles, SumWeight, SumVolume,RouteDate],
        MeasureAttributes: [{Measure: SumVolume, Role: #Axis2},
                            {Measure: SumArticles, Role: #Axis1},
                            {Measure: SumWeight, Role: #Axis1},
        ],
        DynamicMeasures: ['@Analytics.AggregatedProperty#TotalArticles','@Analytics.AggregatedProperty#SumWeight','@Analytics.AggregatedProperty#SumVolume' ],
        },

        Analytics.AggregatedProperty #TotalArticles : {
        $Type : 'Analytics.AggregatedPropertyType',
        Name : 'AverageArticles',
        AggregatableProperty : SumArticles,
        AggregationMethod : 'sum',
        ![@Common.Label] : ' {i18n>Number of Articles per Route}',
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
        ![@Common.Label] : 'Total Package Volume per Route (m^3)',}

);


annotate service.Routelocations with 
  @UI.LineItem: [
    { Value: Route, @UI.Importance: #High },
    { Value: RouteCode, @UI.Importance: #High },
    { Value: RouteDate, @UI.Importance: #High },
   
  ];

  annotate service.Routelocations with
  @UI.PresentationVariant: {
    GroupBy: [ Route ],        // default grouping in table
    Total: [ SumArticles,SumVolume,SumWeight, RouteDate ],  // aggregated measures
    Visualizations: [ '@UI.Chart', '@UI.LineItem'],
    RequestAtLeast: [SumArticles,SumVolume,SumWeight]
  };
