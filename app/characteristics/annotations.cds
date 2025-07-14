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
       
        { Property: AvgWeightUsage },
        { Property: AvgVolumeUsage },
        { Property: MaxCustomerDistanceKM },
        { Property: VehicleCapacityKG },
        { Property: VehicleVolumeM3 },
        { Property: avg_customer_spread },
        { Property: avg_customer_spread_time },
                 
      
      
      

    ]};


annotate service.characteristics with {

  SumWeight @Measures.Unit : 'kg';                   
  SumVolume @Measures.Unit : '';                   
  AverageServiceTime @Measures.Unit : 'min';                                        
  ActiveTime @Measures.Unit : 'min';                 
  DeliveryTime @Measures.Unit : 'min';              
  DrivingTime @Measures.Unit : 'min';              
  VehicleCost @Measures.Unit : '€/km';                                      
               
  AvgWeightUsage @Measures.Unit : '%';               
  AvgVolumeUsage @Measures.Unit : '%';        
  MaxCustomerDistanceKM @Measures.Unit : 'km';
  VehicleCapacityKG @Measures.Unit : 'kg'; 
  avg_customer_spread @Measures.Unit : 'kg';   
  avg_customer_spread_time @Measures.Unit : 'min';  
  VehicleVolumeM3 @Measures.Unit : 'm³'

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
},
 
 Analytics.AggregatedProperty #MaxCustomerDistance : {
    $Type: 'Analytics.AggregatedPropertyType',
    Name: 'MaxCustomerDistance',
    AggregatableProperty: MaxCustomerDistanceKM,
    AggregationMethod: 'max',
    ![@Common.Label]: 'Max Distance of Customer to Depot (km)'
},

Analytics.AggregatedProperty #VehicleCapacityKG : {
    $Type: 'Analytics.AggregatedPropertyType',
    Name: 'VehicleWeightCapacity',
    AggregatableProperty: VehicleCapacityKG,
    AggregationMethod: 'sum',
    ![@Common.Label]: 'Total Vehicle Weight Capacity (kg)'
},

Analytics.AggregatedProperty #VehicleVolumeM3 : {
    $Type: 'Analytics.AggregatedPropertyType',
    Name: 'VehicleVolumeCapacity',
    AggregatableProperty: VehicleVolumeM3,
    AggregationMethod: 'sum',
    ![@Common.Label]: 'Total Vehicle Volume Capacity (m³)'
},
Analytics.AggregatedProperty #avg_customer_spread : {
    $Type: 'Analytics.AggregatedPropertyType',
    Name: 'CustomerSpread',
    AggregatableProperty: avg_customer_spread,
    AggregationMethod: 'average',
    ![@Common.Label]: 'Customer Spread (avg Dist between Customers) (km)'
},
Analytics.AggregatedProperty #avg_customer_spread_time : {
    $Type: 'Analytics.AggregatedPropertyType',
    Name: 'CustomerSpread_time',
    AggregatableProperty: avg_customer_spread_time,
    AggregationMethod: 'average',
    ![@Common.Label]: 'Customer Spread (avg Time Distance between Customers) (min)'
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
    },
      {
    $Type: 'UI.ReferenceFacet',
    Label: 'Spread Analysis',
    Target: '@UI.FieldGroup#SpreadAnalysis'
    },
    
    
    
    
    ];


annotate service.characteristics with @UI.FieldGroup#SpreadAnalysis : {
  Data: [
    { Value: Route, Label: 'Route ID' },
    { Value: MaxCustomerDistanceKM, Label: 'Max Distance of Customer to Depot (km)' },
    { Value: VehicleCapacityKG, Label: 'Total Weight Capacity of Vehicles (kg)' },
    { Value: VehicleVolumeM3, Label: 'Total Volume Capacity of Vehicles (m³)' },
    { Value: avg_customer_spread, Label: 'Average Distance between Customers (km)' },
    { Value: avg_customer_spread_time, Label: 'Average Time Distance between Customers (km)' }
  ]
};

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
  RequestAtLeast: [ CustomerNumber, DeliveryTime]
};

 annotate service.characteristics with @UI.LineItem: [
    
      {
            $Type : 'UI.DataFieldForAction',
            Action : 'scenariocharacteristics.EntityContainer/showCorrelations',
            Label : '{i18n>What to Explore?}'
        },
    
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
  

];
 

annotate service.characteristics with @UI.SelectionPresentationVariant: {
  SelectionVariant: { SelectOptions: [] },
  PresentationVariant: @UI.PresentationVariant#MainChartView
};






annotate service.characteristics with @Capabilities.SearchRestrictions.Searchable: false;

