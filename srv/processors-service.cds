using { sap.capire.vrp as my } from '../db/schema';

@readonly
entity CustomerSummary as select from my.Customer {
  route_id,
  count(distinct customer_code) as CustomerCount: Integer,
  avg(customer_time_window_to_min - customer_time_window_from_min) as AvgTimeWindowLength: Decimal
}
group by route_id;

@readonly
entity ConstraintSummary as select from my.Constraints {
  route_id,
  count(ID) as ConstraintCount: Integer
}
group by route_id;

@readonly
entity RouteTimeWindowConstraintSummary as select from my.Route as R
left join CustomerSummary as CS on CS.route_id = R.route_id
left join ConstraintSummary as CT on CT.route_id = R.route_id {
  key R.route_id as RouteID,
  CS.CustomerCount,
  CS.AvgTimeWindowLength,
  CT.ConstraintCount
};

@readonly
entity RouteComplexityClassified as select from RouteTimeWindowConstraintSummary {
  key RouteID,
  CustomerCount,
  AvgTimeWindowLength,
  ConstraintCount,

  // Time Window Classification
  case
    when AvgTimeWindowLength < 445 then 'Tight'
    when AvgTimeWindowLength < 452 then 'Moderate'
    else 'Loose'
  end as TimeWindowComplexity: String,

  // Constraint Load Classification
  case
    when ConstraintCount < 25 then 'Low'
    when ConstraintCount < 50 then 'Medium'
    else 'High'
  end as ConstraintLevel: String,

  // Customer Volume Classification
  case
    when CustomerCount < 100 then 'Low'
    when CustomerCount < 115 then 'Medium'
    else 'High'
  end as CustomerLevel: String,

  // Time Window Criticality Coloring
  case
    when AvgTimeWindowLength < 445 then 1  // Green
    when AvgTimeWindowLength < 452 then 2  // Orange
    else 3                                 // Red
  end as TimeWindowCriticality: Integer,

  // Constraint Criticality Coloring
  case
    when ConstraintCount < 25 then 3       // Green
    when ConstraintCount < 50 then 2       // Orange
    else 1                                 // Red
  end as ConstraintCriticality: Integer,

  // Customer Count Criticality Coloring
  case
    when CustomerCount < 100 then 3         // Green
    when CustomerCount < 115 then 2         // Orange
    else 1                                 // Red
  end as CustomerCriticality: Integer
};

service Visualization {

  @readonly
  entity Routelocations as select from my.Customer as Customer 
  left join my.Depots as Depot on Customer.route_id = Depot.route_id
  left join my.Route as Way on Customer.route_id = Way.route_id {

    @Common.ValueList: {
      CollectionPath: 'Routes',
      Parameters: [
        {
          $Type: 'Common.ValueListParameterInOut',
          LocalDataProperty: 'Route',
          ValueListProperty: 'RouteID'
        }
      ]
    }

    @UI.Hidden: false
    key Customer.route_id as Route,

    round(sum(Customer.number_of_articles), 3) as SumArticles: Decimal,
    round(sum(Customer.total_weight_kg), 3)    as SumWeight: Decimal,
    round(sum(Customer.total_volume_m3), 3)    as SumVolume: Decimal,
    round(avg(customer_time_window_to_min - customer_time_window_from_min), 3) as AverageServiceTime: Decimal,
    Way.route_date as RouteDate: DateTime,
    Way.route_code as RouteCode: String

  } group by Customer.route_id;

  entity Routes as select from my.Routes {
    key RouteID
  };

  entity Customers as projection on my.Customer;
  entity BlockedRoads as projection on my.BlockedRoad;

  entity Route as projection on my.Route {
    ID,
    route_id,
    route_code,
    route_date,
    algorithm_number_of_iterations,
    result_total_cost_km,
    to_Customers,
    to_BlockedRoads: association to many BlockedRoads on to_BlockedRoads.route_id = route_id
  };

  entity RouteTimeWindowSummary as projection on RouteTimeWindowConstraintSummary;
  entity RouteClassification as projection on RouteComplexityClassified;
}

