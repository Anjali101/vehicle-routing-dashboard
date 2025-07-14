using scenariocharacteristics as service from '../../srv/processors-service';

annotate service.ScenarioInsights with @Capabilities.SearchRestrictions.Searchable: false;

annotate service.ScenarioInsights with @UI.LineItem: [
  { Value: Route, Label: 'Route ID', @UI.Importance: #High },
  { Value: ConstraintCount, Label: 'Number of Constraints', @UI.Importance: #High },
  { Value: AverageServiceTime, Label: 'Avg. Service Time (min)', @UI.Importance: #High }
];

annotate service.ScenarioInsights with @UI.SelectionFields: [
  Route,
  ConstraintCount,
  AverageServiceTime
];

annotate service.ScenarioInsights with @UI.HeaderInfo: {
  TypeName: 'Scenario Insight',
  TypeNamePlural: 'Scenario Insights',
  Title: { Value: Route }
};

annotate service.ScenarioInsights with @UI.SelectionPresentationVariant: {
  SelectionVariant: {
    SelectOptions: []
  },
  PresentationVariant: {
    Visualizations: ['@UI.LineItem']
  }
};

annotate service.ScenarioInsights with @UI.Facets: [
  {
    $Type: 'UI.CollectionFacet',
    Label: 'Scenario Overview',
    ID: 'ScenarioOverviewTab',
    Facets: [
      {
        $Type: 'UI.ReferenceFacet',
        Label: 'Tight Time Windows & Constraints',
        Target: '@UI.FieldGroup#ScenarioSummary'
      }
    ]
  },
  
  {
    $Type: 'UI.CollectionFacet',
    Label: 'Reason',
    ID: 'ReasonTab',
    Facets: [
      {
        $Type: 'UI.ReferenceFacet',
        Label: 'Reason Details',
        Target: '@UI.FieldGroup#ReasonDetails'
      }
    ]
  }
];
 
annotate service.ScenarioInsights with @UI.FieldGroup#ReasonDetails: {
  Data: [
    { Value: Reason, Label: 'Reason' }
  ]
};
annotate service.ScenarioInsights with @UI.FieldGroup#ScenarioSummary: {
  Data: [
    { Value: Route, Label: 'Route ID' },
    { Value: ConstraintCount, Label: 'Total Constraints on Route' },
    { Value: AverageServiceTime, Label: 'Avg. Service Time (min)' }
  ]
};

annotate service.ScenarioInsights with @UI.DataPoint#KPIConstraintCount : {
  Value : ConstraintCount,
  Title : 'Total Constraints'
};

annotate service.ScenarioInsights with @UI.DataPoint#KPIServiceTime : {
  Value : AverageServiceTime,
  Title : 'Avg. Service Time (min)'
};

annotate service.ScenarioInsights with @UI.HeaderFacets : [
  {
    $Type: 'UI.ReferenceFacet',
    Target: '@UI.DataPoint#KPIConstraintCount',
    Label: 'Total Constraints'
  },
  {
    $Type: 'UI.ReferenceFacet',
    Target: '@UI.DataPoint#KPIServiceTime',
    Label: 'Avg. Service Time'
  }
];
