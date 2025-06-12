using Visualization as service from '../../srv/processors-service';

// Route summary chart setup
annotate service.Routelocations with @UI.SelectionFields: [ Route ];

annotate service.Routelocations with @Aggregation.ApplySupported: {
  Transformations: ['aggregate', 'groupby'],
  GroupableProperties: [ Route ],
  AggregatableProperties: [
    { Property: SumArticles },
    { Property: SumWeight },
    { Property: SumVolume },
    { Property: AverageServiceTime },
    { Property: RouteDate },
    { Property: RouteCode }
  ]
};

annotate service.Routelocations with @(

  UI.Chart: {
    Title: '{i18n>Route Instances Overview}',
    ChartType: #Column,
    Dimensions: [ Route ],
    Measures: [ SumArticles, SumWeight, SumVolume ],
    MeasureAttributes: [
      { Measure: SumVolume, Role: #Axis2 },
      { Measure: SumArticles, Role: #Axis1 },
      { Measure: SumWeight, Role: #Axis1 }
    ],
    DynamicMeasures: [
      '@Analytics.AggregatedProperty#TotalArticles',
      '@Analytics.AggregatedProperty#SumWeight',
      '@Analytics.AggregatedProperty#SumVolume'
    ]
  },

  Analytics.AggregatedProperty #TotalArticles: {
    $Type: 'Analytics.AggregatedPropertyType',
    Name: 'AverageArticles',
    AggregatableProperty: SumArticles,
    AggregationMethod: 'sum',
    ![@Common.Label]: '{i18n>Number of Articles per Route}'
  },

  Analytics.AggregatedProperty #SumWeight: {
    $Type: 'Analytics.AggregatedPropertyType',
    Name: 'SumWeight',
    AggregatableProperty: SumWeight,
    AggregationMethod: 'sum',
    ![@Common.Label]: '{i18n>Total Package Weight per Route(kg)}'
  },

  Analytics.AggregatedProperty #SumVolume: {
    $Type: 'Analytics.AggregatedPropertyType',
    Name: 'TotalVolume',
    AggregatableProperty: SumVolume,
    AggregationMethod: 'sum',
    ![@Common.Label]: 'Total Package Volume per Route (m^3)'
  }

);

// General labeling
annotate service.Routelocations with {
  Route              @Common.Label: 'Route';
  SumArticles        @Common.Label: 'Number of Articles';
  SumWeight          @Common.Label: 'Total Weight (kg)';
  SumVolume          @Common.Label: 'Total Volume (m³)';
  AverageServiceTime @Common.Label: 'Average Service Time (min)';
  RouteDate          @Common.Label: 'Route Date';
  RouteCode          @Common.Label: 'Route Code';
};

// Route summary table (LineItem)
annotate service.Routelocations with @UI.LineItem: [
  { Value: Route, @UI.Importance: #High },
  { Value: RouteCode, @UI.Importance: #High },
  { Value: RouteDate, @UI.Importance: #High },
  { Value: AverageServiceTime, @UI.Importance: #High },
  { Value: SumArticles, @UI.Importance: #High },
  { Value: SumWeight, @UI.Importance: #High },
  { Value: SumVolume, @UI.Importance: #High }
];

// Default view
annotate service.Routelocations with @UI.PresentationVariant: {
  GroupBy: [ ],
  Total: [ SumArticles, SumVolume, SumWeight, AverageServiceTime ],
  Visualizations: [ '@UI.Chart', '@UI.LineItem' ],
  RequestAtLeast: [ SumArticles, SumVolume, SumWeight ]
};

// Object page identification
annotate service.Routelocations with @UI.Identification: [
  { Value: Route, Label: 'Route' }
];

// Facets for custom section, route chart, and map
annotate service.Routelocations with @UI.Facets: [
  {
    $Type: 'UI.CollectionFacet',
    Label: 'Route Details',
    Facets: [
      {
        $Type: 'UI.ReferenceFacet',
        Label: 'General Info',
        Target: '@UI.Identification'
      }
    ]
  },
  {
    $Type: 'UI.ReferenceFacet',
    Label: 'Customer & Depot Map',
    Target: '@UI.FieldGroup#GeoMap'
  }
];

// Field group for custom XML section
annotate service.Routelocations with @UI.FieldGroup#GeoMap: {
  Data: [
    { Value: Route },
    { Value: RouteCode },
    { Value: RouteDate }
  ]
};

// --- Customer Subtable in Route Object Page ---
annotate service.Route with @UI.Facets: [
  {
    $Type: 'UI.ReferenceFacet',
    Label: 'Customers for this Route',
    Target: 'to_Customers/@UI.LineItem'
  },
  {
    $Type: 'UI.ReferenceFacet',
    Label: 'Blocked Road Segments',
    Target: 'to_BlockedRoads/@UI.LineItem'
  }
];

annotate service.Customers with @UI.LineItem: [
  { Value: customer_code, Label: 'Customer Code' },
  { Value: total_weight_kg, Label: 'Weight (kg)' },
  { Value: total_volume_m3, Label: 'Volume (m³)' },
  { Value: number_of_articles, Label: 'Articles' },
  { Value: customer_latitude, Label: 'Latitude' },
  { Value: customer_longitude, Label: 'Longitude' }
];

// --- Blocked Road table for Route object page ---
annotate service.BlockedRoads with {
  blocked_part_of_the_road_lat @Common.Label: 'Latitude';
  blocked_part_of_the_road_lon @Common.Label: 'Longitude';
};

annotate service.BlockedRoads with @UI.LineItem: [
  { Value: blocked_part_of_the_road_lat, Label: 'Latitude' },
  { Value: blocked_part_of_the_road_lon, Label: 'Longitude' }
];
