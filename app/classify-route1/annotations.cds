using { Visualization } from '../../srv/processors-service';

annotate Visualization.RouteClassification with @(
  UI.FieldGroup #GeneratedGroup : {
    $Type : 'UI.FieldGroupType',
    Data : [
      { $Type : 'UI.DataField', Label : 'Route ID', Value : RouteID },
      { $Type : 'UI.DataField', Label : 'Customer Count', Value : CustomerCount },
      {
        $Type : 'UI.DataField',
        Label : 'Customer Level',
        Value : CustomerLevel,
        Criticality : CustomerCriticality
      },
      {
        $Type : 'UI.DataFieldForAnnotation',
        Label : 'SDVRP Constraint Load',
        Target : '@UI.DataPoint#ConstraintProgress'
      },
      {
        $Type : 'UI.DataField',
        Label : 'SDVRP Constraint Level',
        Value : ConstraintLevel,
        Criticality : ConstraintCriticality
      },
      { $Type : 'UI.DataField', Label : 'Avg Time Window Length', Value : AvgTimeWindowLength },
      {
        $Type : 'UI.DataField',
        Label : 'Time Window Complexity',
        Value : TimeWindowComplexity,
        Criticality : TimeWindowCriticality
      }
    ]
  },

  UI.Facets : [
    {
      $Type : 'UI.ReferenceFacet',
      ID : 'GeneralInfo',
      Label : 'General Information',
      Target : '@UI.FieldGroup#GeneratedGroup'
    }
  ],

  UI.LineItem : [
    { $Type : 'UI.DataField', Label : 'Route ID', Value : RouteID },
    { $Type : 'UI.DataField', Label : 'Customer Count', Value : CustomerCount },
    {
      $Type : 'UI.DataField',
      Label : 'Customer Level',
      Value : CustomerLevel,
      Criticality : CustomerCriticality
    },
    {
      $Type : 'UI.DataFieldForAnnotation',
      Label : 'SDVRP Constraint Load',
      Target : '@UI.DataPoint#ConstraintProgress'
    },
    {
      $Type : 'UI.DataField',
      Label : 'SDVRP Constraint Level',
      Value : ConstraintLevel,
      Criticality : ConstraintCriticality
    },
    { $Type : 'UI.DataField', Label : 'Avg Time Window Length', Value : AvgTimeWindowLength },
    {
      $Type : 'UI.DataField',
      Label : 'Time Window Complexity',
      Value : TimeWindowComplexity,
      Criticality : TimeWindowCriticality
    }
  ]
);

// 📊 Progress bar for Constraint Load
annotate Visualization.RouteClassification with @UI.DataPoint #ConstraintProgress : {
  Title: 'SDVRP Constraint Load',
  Value: ConstraintCount,
  TargetValue: 59,
  Visualization: #Progress
};

// 🏷️ HeaderInfo for the List Report Page Title
annotate Visualization.RouteClassification with @UI.HeaderInfo: {
  TypeName: 'Route Classification',
  TypeNamePlural: 'Route Classifications',
  Title: { Value: RouteID }
};
