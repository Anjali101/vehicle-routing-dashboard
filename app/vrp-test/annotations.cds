using Visualization as service from '../../srv/processors-service';



annotate service.Routelocations with @UI.SelectionFields  : [ Route];

annotate service.Routelocations with @Aggregation.ApplySupported  : {
    Transformations : ['aggregate', 'groupby'],
    GroupableProperties : [Route],
    AggregatableProperties: [
       
        {Property: SumArticles},
        {Property: SumWeight},
        {Property: SumVolume},
        {Property: AverageServiceTime},
        {Property: RouteDate},
        {Property: RouteCode},
  
      
       
        
        
       
    ]
    
};


annotate service.Routelocations with @(

    UI.Chart#MainChart: {

        Title : '{i18n>Route Instances Overview}',
        ChartType : #Column,
        Dimensions : [Route],
        DynamicMeasures: ['@Analytics.AggregatedProperty#TotalArticles','@Analytics.AggregatedProperty#SumWeight','@Analytics.AggregatedProperty#SumVolume', '@Analytics.AggregatedProperty#AvgServiceTime' ],
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
        ![@Common.Label] : 'Total Package Volume per Route (m^3)',},

    
    Analytics.AggregatedProperty #AvgServiceTime : {
        $Type : 'Analytics.AggregatedPropertyType',
        Name : 'AvgServiceTime',
        AggregatableProperty : AverageServiceTime,
        AggregationMethod : 'average',
        ![@Common.Label] : 'Average Service Time (min)'
    }
);



 annotate service.Routelocations with @UI.PresentationVariant#MainChartView: {
  Visualizations: ['@UI.Chart#MainChart', '@UI.LineItem'],
  RequestAtLeast: [SumArticles,SumVolume,SumWeight]
};

annotate service.Routelocations with @UI.SelectionPresentationVariant: {
  SelectionVariant: { SelectOptions: [] },
  PresentationVariant: @UI.PresentationVariant#MainChartView
};

annotate service.Routelocations with {
  Route              @Common.Label: 'Route';
  SumArticles        @Common.Label: 'Number of Articles';
  SumWeight          @Common.Label: 'Total Weight (kg)';
  SumVolume          @Common.Label: 'Total Volume (m³)';
  AverageServiceTime @Common.Label: 'Average Service Time (min)';
  RouteDate          @Common.Label: 'Route Date';
  RouteCode          @Common.Label: 'Route Code';



};

annotate service.Routelocations with @Capabilities.SearchRestrictions.Searchable: false;
annotate service.Routelocations with 
  @UI.LineItem: [
    { Value: Route, @UI.Importance: #High },
    { Value: RouteCode, @UI.Importance: #High },
    { Value: RouteDate, @UI.Importance: #High },
    { Value: AverageServiceTime, @UI.Importance: #High },
    { Value: RouteDate, @UI.Importance: #High },
    { Value: SumArticles, @UI.Importance: #High },
    { Value: SumWeight, @UI.Importance: #High },
    { Value: SumVolume, @UI.Importance: #High },
    { Value: DepotLatitude, @UI.Importance: #High },
      { Value: DepotlLongitude, @UI.Importance: #High },
     
   
  ];


annotate service.Vehicle with @UI.Chart #Dist: {
  ChartType: #Column,
  Dimensions: [VehicleCode],
  Measures: [VehicleTotalweight, VehicleMaxVolume],
  MeasureAttributes: [
    { Measure: VehicleMaxVolume, Role: #Axis1 },
    { Measure: VehicleTotalweight, Role: #Axis2 }
  ]
};


  annotate service.Routelocations with @UI.Identification: [
  { Value: Route, Label: 'Route' },
  { Value: RouteCode, Label: 'Route Code' },
  { Value: RouteDate, Label: 'Route Date' },
  { Value: SumArticles, Label: 'Total Articles on Route' },
  { Value: SumWeight, Label: ' Total Package Weight (kg)' },
  { Value: SumVolume, Label: 'Total Package Volume (m³)' },
  { Value: AverageServiceTime, Label: 'Average Service Time (min)' },
  
];

annotate service.Vehicle with 
  @UI.LineItem: [
    { Value: VehicleNumber, Label: 'Vehicle Number' },
    { Value: VehicleCode, Label: 'Vehicle Code' },
    { Value: DrivingTime, Label: 'Driving Time (min)' },
    { Value: DeliveryTime, Label: 'Delivery Time (min)'},
    { Value: result_vehicle_driving_volume_m3, Label: 'Driving Volume (m^3)'},
     { Value: result_vehicle_driving_weight_kg, Label: 'Driving Volume (kg)'},
     { Value: VehicleTotalweight, Label: 'Vehicle Wight Capacity(kg)' },
      {Value: VehicleMaxVolume, Label: 'Vehicle Volume Capacity (m^3)' },

  ];

  annotate service.RouteCustomers with @UI.LineItem: [
  {Value: CustomerNumber, Label: 'Customer Number'},
  {Value: CustomerLatitude, Label: 'Latitude' },
  { Value: customer_longitude, Label: 'Longitude' },
  {Value: CustomerNumber, Label: 'Customer Number'}
];


  annotate service.RouteCustomers with @UI.PresentationVariant: {
  SortOrder: [
    { Property: CustomerNumberSort, Descending: false }
  ],
  Visualizations: ['@UI.LineItem']
};



  annotate service.BlockedRoads with @UI.LineItem: [

    { Value: RoadBlockID, Label: 'Road Block ID' },
    { Value: Latitude, Label: 'Latidue' },
    { Value: Longitude, Label: 'Longitude' },


  ];

   annotate service.BlockedRoads with @UI.PresentationVariant: {
  SortOrder: [
    { Property: BlockedRoadSort, Descending: false }
  ],
  Visualizations: ['@UI.LineItem']
};



annotate service.Routelocations with @UI.Facets: [

  // Overview tab
  {
    $Type: 'UI.CollectionFacet',
    ID: 'OverviewTab',
    Label: 'Overview',
    Facets: [
      {
        $Type: 'UI.ReferenceFacet',
        Target: '@UI.Identification',
        Label: 'General Info'
      },
       {
        $Type: 'UI.ReferenceFacet',
        Target: '@UI.FieldGroup#DepotGroup',
        Label: 'Route Depot'
      }
    ]
  },

  // Vehicles Used tab
   {
    $Type: 'UI.CollectionFacet',
    ID: 'VehiclesUsedTab',
    Label: 'Vehicles Used',
    Facets: [
      {
        $Type: 'UI.ReferenceFacet',
        Target: 'to_Vehicles/@UI.LineItem',
        Label: 'Used Vehicles'
      }
    ]
  },

    {
    $Type: 'UI.CollectionFacet',
    ID: 'CustomersTab',
    Label: 'Locations',
    Facets: [
      {
        $Type: 'UI.ReferenceFacet',
        Target: 'to_Customers/@UI.PresentationVariant',
        Label: 'Customer Locations'
      },
       {
        $Type: 'UI.ReferenceFacet',
        Target: 'to_blocks/@UI.PresentationVariant',
        Label: 'Road Block Locations'
      }
    ]
  }
  
];




annotate service.Routelocations with @UI.FieldGroup#DepotGroup: {
  Label: 'Depot Information',
  Data: [
     { Value: DepotCode, Label: 'Depot Code' },
    { Value: DepotLatitude, Label: 'Depot Latitude' },
    { Value: DepotlLongitude, Label: 'Depot Longitude' }
  ]
};


annotate service.Routelocations with @UI.HeaderInfo: {
  TypeName: 'Route',
  TypeNamePlural: 'Routes',
  Title: {
    Value: 'Route Details ',
    Label: 'Route Number'
  },
  Description: {
    Value: Route,
    Label: 'Route'
  }
};


