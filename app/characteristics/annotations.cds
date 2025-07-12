using scenariocharacteristics as service from '../../srv/processors-service';






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
        { Property: ConstraintCount },
        { Property: AvgConstraintsPerCustomer },
        { Property: TotalDistance },
        { Property: AvgWeightUsage },
        { Property: AvgVolumeUsage }
                 
      
      
      

    ]};


annotate service.characteristics with {

  SumWeight @Measures.Unit : 'kg';                   
  SumVolume @Measures.Unit : 'm³';                   
  AverageServiceTime @Measures.Unit : 'min';                                        
  ActiveTime @Measures.Unit : 'min';                 
  DeliveryTime @Measures.Unit : 'min';              
  DrivingTime @Measures.Unit : 'min';              
  VehicleCost @Measures.Unit : '€/km';                                      
  TotalDistance @Measures.Unit : 'km';               
  AvgWeightUsage @Measures.Unit : '%';               
  AvgVolumeUsage @Measures.Unit : '%';               

};


annotate service.characteristics with @(

    UI.Chart#MainChart: {

        Title : '{i18n>Characteristics Correlations}',
        ChartType : #Scatter,
        Dimensions : [Route],
    DynamicMeasures: [
  '@Analytics.AggregatedProperty#CustomerNumber',
  '@Analytics.AggregatedProperty#VehicleCost',
  
],
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
    },
    Analytics.AggregatedProperty #TotalConstraints : {
    $Type: 'Analytics.AggregatedPropertyType',
    Name: 'TotalConstraints',
    AggregatableProperty: ConstraintCount,
    AggregationMethod: 'sum',
    ![@Common.Label]: '{i18n>Total Constraints}'
},

Analytics.AggregatedProperty #AvgConstraintsPerCustomer : {
    $Type: 'Analytics.AggregatedPropertyType',
    Name: 'AvgConstraintsPerCustomer',
    AggregatableProperty: AvgConstraintsPerCustomer,
    AggregationMethod: 'average',
    ![@Common.Label]: '{i18n>Avg. Constraints per Customer}'
},

Analytics.AggregatedProperty #TotalDistance : {
    $Type: 'Analytics.AggregatedPropertyType',
    Name: 'TotalDistance',
    AggregatableProperty: TotalDistance,
    AggregationMethod: 'none',
    ![@Common.Label]: '{i18n>Total Route Distance (km)}'
},

Analytics.AggregatedProperty #AvgWeightUsage : {
    $Type: 'Analytics.AggregatedPropertyType',
    Name: 'AvgWeightUsage',
    AggregatableProperty: AvgWeightUsage,
    AggregationMethod: 'average',
    ![@Common.Label]: '{i18n>Avg. Weight Usage (%)}'
},

Analytics.AggregatedProperty #AvgVolumeUsage : {
    $Type: 'Analytics.AggregatedPropertyType',
    Name: 'AvgVolumeUsage',
    AggregatableProperty: AvgVolumeUsage,
    AggregationMethod: 'average',
    ![@Common.Label]: '{i18n>Avg. Volume Usage (%)}'
}


);


annotate service.characteristics with 
  @UI.Facets: [
    {
      $Type: 'UI.ReferenceFacet',
      Label: 'Vehicle Statistics',
      Target: '@UI.FieldGroup#VehicleStats'
    },
     {
      $Type: 'UI.ReferenceFacet',
      Label: 'Route Statistics',
      Target: '@UI.FieldGroup#RouteStats'
    },
     {
      $Type: 'UI.ReferenceFacet',
      Label: 'Constraint Statistics',
      Target: '@UI.FieldGroup#ConstraintStats'
    }
    
    
    
    
    ];

annotate service.characteristics with  @UI.FieldGroup#VehicleStats: { Data: [
    {Value: DrivingTime, Label: 'Driving Time'},
    {Value: DeliveryTime, Label: 'Delivery Time'},
    {Value: ActiveTime, Label: 'Active Time'},
    {Value: AvgWeightUsage, Label: 'Weight Usage'},
    {Value: AvgVolumeUsage, Label: 'Volume Usage'}
 
  ] };


annotate service.characteristics with  @UI.FieldGroup#RouteStats: { Data: [
    {Value: CustomerNumber, Label: 'Amount of Customers'},
    {Value: SumArticles, Label: 'Total Articles on Route'},
    {Value: SumWeight, Label: 'Total Package Weight'},
    {Value: SumVolume, Label: 'Total Package Volume'},
     {Value: AverageServiceTime, Label: 'Average Availability Time per Customer'},
 
  ] };

annotate service.characteristics with  @UI.FieldGroup#ConstraintStats: { Data: [
    {Value: ConstraintCount, Label: 'Amount of Constraints on Route'},
    {Value: AvgConstraintsPerCustomer, Label: 'Average Amount of Constraints per Customer'},
    
 
  ] };







 annotate service.characteristics with @UI.PresentationVariant#MainChartView: {
  Visualizations: ['@UI.Chart#MainChart', '@UI.LineItem'],
  RequestAtLeast: [ CustomerNumber, TotalDistance]
};

 annotate service.characteristics with @UI.LineItem: [
    {
            $Type : 'UI.DataFieldForAction',
            Action : 'scenariocharacteristics.EntityContainer/checkAI',
            Label : '{i18n>Evaluate_AI}'
        },
    { Value: Route, Label: 'Route' },
  { Value: CustomerNumber, Label: 'Customer Count' },
  { Value: AverageServiceTime, Label: 'Avg Service Time ' },
 
  { Value: DrivingTime, Label: 'Driving Time ' },
  { Value: DeliveryTime, Label: 'Delivery Time ' },
  { Value: ActiveTime, Label: 'Active Time ' },
  { Value: VehicleCost, Label: 'Vehicle Cost ' },
  
  { Value: TotalDistance, Label: 'Total Distance ' },
];
 

annotate service.characteristics with @UI.SelectionPresentationVariant: {
  SelectionVariant: { SelectOptions: [] },
  PresentationVariant: @UI.PresentationVariant#MainChartView
};






annotate service.characteristics with @Capabilities.SearchRestrictions.Searchable: false;

