using Visualization as service from '../../srv/processors-service';
annotate service.RouteAggregated with {
    Route @Common.Text : RouteCode
};

annotate service.RouteAggregated with {
    RouteCode @Common.Text : Route
};

annotate service.RouteAggregated with @(
    UI.Chart : {
        Title : '{i18n>RouteKilometersOverview}',
        ChartType : #Column,
        Dimensions : [
            
            Route,
        ],
        Measures : [
            TotalKilometers,
            MaxKilometers,
            RouteCount,
        ],
        MeasureAttributes : [
            { Measure: TotalKilometers, Role: #Axis1 },
            { Measure: MaxKilometers, Role: #Axis1 },
            { Measure: RouteCount, Role: #Axis1 }
        ],
        DynamicMeasures : [
            '@Analytics.AggregatedProperty#TotalKilometers_max',
        ],
    },
    Analytics.AggregatedProperty #TotalKilometers_max : {
        $Type : 'Analytics.AggregatedPropertyType',
        Name : 'TotalKilometers_max',
        AggregatableProperty : TotalKilometers,
        AggregationMethod : 'max',
        ![@Common.Label] : 'TotalKilometers (Maximum)',
    },
);

annotate Visualization.RouteAggregated with @Aggregation.ApplySupported : {
    Transformations : ['aggregate', 'groupby'],
    GroupableProperties : [ RouteCode, Route ],
    AggregatableProperties : [
        { Property : TotalKilometers },
        { Property : MaxKilometers },
        { Property : RouteCount }
    ]
};

annotate Visualization.RouteAggregated with @UI.SelectionFields : [

  Route
];

annotate Visualization.RouteAggregated with 
  @UI.LineItem: [
    { Value: RouteCode, @UI.Importance: #High },
    { Value: Route, @UI.Importance: #High },
    { Value: TotalKilometers, @UI.Importance: #High },
    { Value: MaxKilometers, @UI.Importance: #High },
    { Value: RouteCount, @UI.Importance: #High }
  ];



annotate Visualization.RouteAggregated with
  @UI.PresentationVariant: {
    GroupBy: [ RouteCode, Route ],        // default grouping in table
    Total: [ TotalKilometers, MaxKilometers, RouteCount ],  // aggregated measures
    Visualizations: ['@UI.Chart', '@UI.LineItem' ]
  };



