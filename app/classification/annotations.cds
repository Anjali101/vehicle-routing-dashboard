using RouteClassification as service from '../../srv/processors-service';


annotate service.CustomerArticleSummary with @Capabilities.SearchRestrictions.Searchable: false;

annotate service.CustomerArticleSummary with @UI.LineItem: [

    {Value: Route, Label: 'Route', @UI.Importance : #High,},
    {Value: CustomerKPI_Label, Label: 'CustomerLoad', @UI.Importance : #High, Criticality: CustomerKPI},
    {Value: constraintlevel.ConstraintLevel, Label: 'Constraint Level ', @UI.Importance : #High},
    {Value: RouteDistance_Label, Label: 'Customer Spread ', @UI.Importance : #High, Criticality: RouteDistance_Criticality},

    {
        $Type : 'UI.DataFieldForAnnotation',
        Label : 'Customer Availability',
        Target : '@UI.DataPoint#Rating',
        ![@HTML5.CssDefaults] : {width : '20rem'}
  
    },
     {
        $Type : 'UI.DataFieldForAnnotation',
        Label : 'Vehicle Cost Efficiency',
        Target : '@UI.DataPoint#VehicleRating',
        ![@HTML5.CssDefaults] : {width : '20rem'}
    },
    

  
 

];




annotate service.CustomerArticleSummary with @UI.Facets: [
  {
    $Type: 'UI.CollectionFacet',
    Label: 'Customer Load',
    ID: 'ClassificationsTab',
    Facets: [
      {
        $Type: 'UI.ReferenceFacet',
        Label: 'Customer Load',
        Target: '@UI.FieldGroup#Customerload'},

    ]
  },
  {
    $Type: 'UI.CollectionFacet',
    Label: 'Constraint Level',
    ID: 'ConstraintLevelTab',
    Facets: [
      {
        $Type: 'UI.ReferenceFacet',
        Label: 'Constraint Level',
        Target: '@UI.FieldGroup#ConstraintLevel'
      }
    ]
  },

    {
    $Type: 'UI.CollectionFacet',
    Label: 'Customer Availability',
    ID: 'CustomerAvailabilityTab',
    Facets: [
      {
        $Type: 'UI.ReferenceFacet',
        Label: 'Customer Availability',
        Target: '@UI.FieldGroup#AverageAvailability'
      }
    ]
  },

  {
    $Type: 'UI.CollectionFacet',
    Label: 'Vehicle Cost',
    ID: 'VehicleCostTab',
    Facets: [
      {
        $Type: 'UI.ReferenceFacet',
        Label: 'Vehicle Cost',
        Target: '@UI.FieldGroup#VehicleCost'
      }
    ]
  },
  {
    $Type: 'UI.CollectionFacet',
    Label: 'Route Distance',
    ID: 'RouteDistanceTab',
    Facets: [
      {
        $Type: 'UI.ReferenceFacet',
        Label: 'Vehicle Cost',
        Target: '@UI.FieldGroup#RouteDist'
      }
    ]
  }

  




];



annotate service.CustomerArticleSummary with @UI.DataPoint #WithCriticality: {
  Title: 'Customer Value (Colored)',
  Value: CustomerNumber,
  Criticality: CustomerKPI
};




annotate service.CustomerArticleSummary with @UI.FieldGroup #Customerload: {
  Data: [
    { Value: CustomerKPI_Label, Label: 'Customer Load ', Criticality: CustomerKPI },
    { Label: 'Description', Value: 'Measures the relative amount of Customers in Relation to other Routes',@UI.Importance : #High,},
    { Value: CustomerNumber, Label: 'Amount of Customers', Criticality: CustomerKPI,@UI.Importance : #High, },
    {Value: ReferenceValue , Label: 'Reference Value (Average across Routes)', @UI.Importance : #High,},
  ]
};

annotate service.CustomerArticleSummary with @UI.FieldGroup #ConstraintLevel: {
  Data: [
    { Value: constraintlevel.ConstraintLevel, Label: 'Constraint Level ' },
    { Label: 'Description', Value: 'Classifies the Route based on the amount of Constraints in Comparison to other Routes ',@UI.Importance : #High,},
    { Value: constraintlevel.ConstraintSum, Label: 'Amount of Constraints' ,@UI.Importance : #High, },
    {Value: ReferenceValueConstraintLevel , Label: 'Reference Value (Average across Routes)', @UI.Importance : #High,},
  ]
};


annotate service.CustomerArticleSummary with @UI.FieldGroup #AverageAvailability: {
  Data: [
    {
      $Type: 'UI.DataFieldForAnnotation',
      Label: 'Customer Availability',
      Target: '@UI.DataPoint#Rating'
    },
    { Label: 'Description', Value: 'Measures the average availability for delivery per Customer'},
    { Value: AverageCustomerAvailability, Label: 'Average Customer Availability Timefield (min)'},
    { Value: AvgCust_ReferenceValue, Label: 'Reference Value (Average across all Routes)',@UI.Importance : #High,}

  ]
};

annotate service.CustomerArticleSummary with @UI.FieldGroup #VehicleCost: {
  Data: [
    {
      $Type: 'UI.DataFieldForAnnotation',
      Label: 'VehicleCost',
      Target: '@UI.DataPoint#VehicleRating'
    },
    { Label: 'Description', Value: 'Measures the total cost of All Vehicles per Kilometer of the Route in Euro/km'},
    { Value: routecost.VehicleCostEfficiency, Label: 'Vehicle Cost per Kilometer (€/km) '},
    { Value: ReferenceValueVehicleCost, Label: 'Reference Value (Average across all Routes)', @UI.Importance : #High}

  ]
};



annotate service.CustomerArticleSummary with @UI.FieldGroup #RouteDist: {
  Data: [
    { Value: RouteDistance_Label, Label: 'Customer Spread', @UI.Importance : #High, Criticality: RouteDistance_Criticality},
    { Label: 'Description', Value: 'Average Distance between Customers'},
    { Value: avg_customer_spread, Label: 'Customer Distance (km) ', },
    { Value: ReferenceValueCustDIst, Label: 'Reference Value (Average across all Routes)', @UI.Importance : #High}

  ]
};



annotate service.CustomerArticleSummary with @(
  
  UI.DataPoint #Rating: {

    Value: AverageServiceStars,
    TargetValue: 5,
    Visualization: #Rating


  }
  
);



annotate service.CustomerArticleSummary with @(
  
  UI.DataPoint #VehicleRating: {

    Value: routecost.VehicleCostStars,
    TargetValue: 5,
    Visualization: #Rating


  }
  
);





   
annotate service.CustomerArticleSummary with @UI.SelectionPresentationVariant: {
  SelectionVariant: {
    SelectOptions: []
  },
  PresentationVariant: {
    Visualizations: ['@UI.LineItem'],

  }
};

annotate service.CustomerArticleSummary with @UI.SelectionFields: ['Route', CustomerLoad, constraintlevel.ConstraintLevel];

annotate service.CustomerArticleSummary with @UI.HeaderInfo: {
  TypeName: 'Route Classification',
  TypeNamePlural: 'Route Classifications',
  Title: { Value: Route }
};

annotate service.CustomerArticleSummary.AverageServiceTime with @UI.DataPoint#Average: {
  Title: 'Avg. Service Time',
  Value: AverageServiceTime,
  Visualization: #Rating,
  TargetValue: 5
};
