using { sap.capire.vrp as my } from '../db/schema';

service Visualization {

    @readonly
    entity Routelocations as select from my.Customer as Customer 
    left join my.Depots as Depot on Customer.route_id = Depot.route_id
    left join my.Route as Way on Customer.route_id = Way.route_id 
    left  join  my.Vehicle as Vehicle on Customer.route_id = Vehicle.route_id 
     {

       
        @Common.ValueList: {
            CollectionPath: 'Routelocations',
            Parameters: [
                {
                    $Type: 'Common.ValueListParameterInOut',
                    LocalDataProperty: 'Route',
                    ValueListProperty: 'Route'
                }
            ]
        }


        to_Vehicles: Composition of many Vehicle on to_Vehicles.Route = $self.Route,
        to_VehicleDistribution: Composition of  many VehicleDistribution on to_VehicleDistribution.Route = $self.Route,
        to_VehicleDistributionView: Composition of  many VehicleDistributionView on to_VehicleDistributionView.Route = $self.Route,
        to_Customers: association to many RouteCustomers on to_Customers.RouteID = $self.Route,
        to_blocks: Association to many  BlockedRoads on True,
        to_averages: Association to many averages on to_averages.Route = $self.Route,

        @UI.Hidden: false
        key Customer.route_id as Route,
        
        round(sum(Customer.number_of_articles), 3) as SumArticles: Decimal,
        round(sum(Customer.total_weight_kg), 3)    as SumWeight: Decimal,
        round(sum(Customer.total_volume_m3), 3)    as SumVolume: Decimal,
        count(distinct(Customer.customer_code))    as TotalCustomers: Integer,
        round(avg(customer_time_window_to_min - customer_time_window_from_min), 3) as AverageServiceTime: Decimal,
        Way.route_date as RouteDate: DateTime,
        Way.route_code as RouteCode: String,
        Depot.depot_latitude as DepotLatitude,
        Depot.depot_longitude as DepotlLongitude,
        Depot.depot_code as DepotCode,
        sum(distinct(Vehicle.result_vehicle_final_cost_km)) as VehicleCostEfficiency: Decimal,
       
   



    
    }group by Customer.route_id;


    entity averages as select from my.Vehicle {

        key ID as Identifierm,
        route_id as Route,
        round(
  avg( case
      when weightusage != 0 then weightusage
    end
  ), 2
) as AvgWeightUsage: Decimal(5,2),

round(
  avg(
    case
      when volumeusage != 0 then volumeusage
    end
  ), 2
) as AvgVolumeUsage: Decimal(5,2),

    } group by route_id;



    entity Vehicle as select from  my.Vehicle{

        key ID as Identifierm,
        route_id as Route,
        vehicle_number as VehicleNumber,
        vehicle_code as VehicleCode,
        vehicle_total_volume_m3 as VehicleMaxVolume,
        vehicle_total_weight_kg as VehicleTotalweight,
        result_vehicle_total_driving_time_min as DrivingTime,
        result_vehicle_total_delivery_time_min as DeliveryTime,
        result_vehicle_driving_weight_kg,
        result_vehicle_driving_volume_m3,
        result_vehicle_final_cost_km as VehicleCost,
        weightusage as WeightUsage,
        volumeusage as VolumeUsage,
       
        
    } where result_vehicle_total_driving_time_min != 0;

   entity VehicleDistribution as select from my.Vehicle {
    key vehicle_code                 as VehicleCode: String,
    route_id                         as Route,
    min(vehicle_number)             as VehicleNumber: Integer,
    min(vehicle_total_weight_kg)    as TotalWeight: Decimal,
    min(vehicle_total_volume_m3)    as TotalVolume: Decimal,
} group by vehicle_code;

    entity RouteCustomers as select from my.Customer {
        
        route_id as RouteID,
        key Customer.customer_code as CustomerID,
        customer_latitude as CustomerLatitude,
        customer_longitude as customer_longitude,
        Customer.customer_number as CustomerNumber,
        cast(Customer.customer_number as Integer) as CustomerNumberSort: Integer
       
        

    }

    entity BlockedRoads as select from my.BlockedRoad {

        key ID as RoadBlockID,
        blocked_part_of_the_road_lat as Latitude,
        blocked_part_of_the_road_lon as Longitude,
        cast (BlockedRoad.ID as Integer) as BlockedRoadSort: Integer

    }

entity VehicleDistributionView as select from my.Vehicle{
    route_id as Route,
  key vehicle_code: String,
  vehicle_number: String,
  vehicle_total_weight_kg: Decimal,
  vehicle_total_volume_m3: Decimal
}





    } 
     


service RouteClassification{




entity CustomerArticleSummary as select from my.Customer left join my.CustomerDistance on Customer.route_id = CustomerDistance.route_id {


       @Common.ValueList : {
        $Type : 'Common.ValueListType',
        Label : 'Route',
        CollectionPath : 'CustomerArticleSummary',
        Parameters : [
            {
                $Type : 'Common.ValueListParameterInOut',
                LocalDataProperty : Route,
                ValueListProperty : 'Route'
            },
           
        ]
    }

  

    @UI.Hidden: false
    
    key Customer.route_id as Route ,
    sum(number_of_articles) as TotalArticles: Integer,


    count(distinct customer_code) as Customers: Integer,

    case 
        when count(distinct customer_code) <= 100 then 'Low'
        when count(distinct customer_code) <= 110 then 'Medium'
        else 'High'
    end as CustomerLoad: String,


  case
    when sum(number_of_articles) >2000 then 3
    when sum(number_of_articles) <1750 then 1
    else 2
  end as TotalArticleCriticality: Integer,
  round(avg(customer_time_window_to_min - customer_time_window_from_min), 3) as AverageCustomerAvailability: Decimal,
  cast (487.56 as Decimal (5,2)) as AvgCust_ReferenceValue,

case
  when round(avg(customer_time_window_to_min - customer_time_window_from_min), 3) >= 454 then 5
  when round(avg(customer_time_window_to_min - customer_time_window_from_min), 3) >= 448 then 4
  when round(avg(customer_time_window_to_min - customer_time_window_from_min), 3) >= 442 then 3
  when round(avg(customer_time_window_to_min - customer_time_window_from_min), 3) >= 436 then 2
  else 1
end as AverageServiceStars: Integer,

    count(distinct customer_code) as CustomerNumber: Integer,
    cast(105.27 as Decimal(5,2)) as ReferenceValue,  

    case 

        when count(distinct customer_code)  <= 110 then 3
        when count(distinct customer_code)  <= 120 then 2
        else  1

        end as CustomerKPI: Integer,


    case

        when count (distinct customer_code) <= 110 then 'Low'
        when count (distinct customer_code) <= 120 then 'Medium'
        else 'High'
        end as CustomerKPI_Label: String,


       

    constraintlevel: association to many constraintcount on  constraintlevel.ConstraintRoute = Route,
    routecost: association to one vehiclecost on routecost.Route = Route,

     cast(169.82 as Decimal(5,2)) as ReferenceValueVehicleCost,
     cast(40.18 as Decimal(5,2)) as ReferenceValueConstraintLevel,
     cast(40.18 as Decimal(5,2)) as ReferenceValueCustDIst,


    round(avg(CASE WHEN CustomerDistance.distance_km != 0 THEN CustomerDistance.distance_km ELSE NULL END),3) AS avg_customer_spread: Decimal,
    cast(3385.376 as Decimal(5,2)) as ReferenceValueDist,

case
  when avg(
         case 
           when  CustomerDistance.distance_km != 0.0 
           then CustomerDistance.distance_km 
           else null 
         end
       ) is null
       or avg(
         case 
           when CustomerDistance.distance_km  != 0.0  
           then CustomerDistance.distance_km
         end
       ) = 0
    then 'NO DATA AVAILABLE'
  when avg(
         case 
           when CustomerDistance.distance_km != 0.0 
           then CustomerDistance.distance_km
         end
       ) <= 40
    then 'High'
  when avg(
         case 
           when CustomerDistance.distance_km != 0.0 
           then CustomerDistance.distance_km
         end
       ) <= 55
    then 'Medium'
  else 'Low'
end as RouteDistance_Label: String,


case
  when avg(
         case 
           when CustomerDistance.distance_km != 0.0 
           then CustomerDistance.distance_km 
           else null 
         end
       ) is null
       or avg(
         case 
           when CustomerDistance.distance_km != 0.0 
           then CustomerDistance.distance_km
         end
       ) = 0
    then null
  when avg(
         case 
           when CustomerDistance.distance_km != 0.0  
           then CustomerDistance.distance_km
         end
       ) <= 40
    then 1
  when avg(
         case 
           when CustomerDistance.distance_km != 0.0 
           then CustomerDistance.distance_km
         end
       ) <= 55
    then 2
  else 3
end as RouteDistance_Criticality: Integer,

} group by Customer.route_id ;


entity constraintcount as select from my.Constraints {

    key Constraints.ID as ID,
    Constraints.route_id as ConstraintRoute,

        count(distinct Constraints.ID) as ConstraintSum: Integer,

    case

        when count (distinct Constraints.ID ) <= 20 then 'Low'
        when count (distinct Constraints.ID ) <= 40 then 'Medium'
        else 'High'
        end as ConstraintLevel: String,

         case

        when count (distinct Constraints.ID ) <= 20 then 1
        when count (distinct Constraints.ID ) <= 40 then 2
        else 3
        end as ConstraintLevelSort: Integer
    



} group by route_id;


entity vehiclecost as select from my.Customer left join my.Vehicle on 
Customer.route_id = Vehicle.route_id {


           @Common.ValueList : {
        $Type : 'Common.ValueListType',
        Label : 'constraintlevel',
        CollectionPath : 'vehiclecost',
        Parameters : [
            {
                $Type : 'Common.ValueListParameterInOut',
                LocalDataProperty : VehicleCostEfficiency,
                ValueListProperty : 'VehicleCostEfficiency'
            },
           
        ]
    }




    Vehicle.route_id as Route,
    key Vehicle.ID as ID,
    sum ( distinct result_vehicle_final_cost_km)  as VehicleCostEfficiency: Decimal(10,4),

    case
        when round( (sum ( distinct result_vehicle_final_cost_km)), 3) <= 143.8 then 5
        when round( (sum ( distinct result_vehicle_final_cost_km)), 3) <= 171.6 then 4
        when round( (sum ( distinct result_vehicle_final_cost_km)), 3) <= 199.4 then 3
        when round( (sum ( distinct result_vehicle_final_cost_km)), 3) >= 227.2 then 2
        else 2
        end as VehicleCostStars: Integer,


} group by Vehicle.route_id;







}

service scenariocharacteristics {
    entity SpreadVehicleAnalysis as select from my.Vehicle {
    key route_id as Route,
    sum(vehicle_total_weight_kg) as VehicleCapacityKG: Decimal(10,2),
    sum(vehicle_total_volume_m3) as VehicleVolumeM3: Decimal(10,2)
  } group by route_id;

    entity characteristics as select from my.Customer
    left join my.Vehicle on Customer.route_id = Vehicle.route_id
    left join my.Depots as Depot on Customer.route_id = Depot.route_id
    left join my.DepotDistance as Dist 
        on Customer.route_id = Dist.route_id 
        and Customer.customer_code = Dist.customer_code
    left join my.Spread as Spread on Customer.route_id = Spread.route_id
    left join SpreadVehicleAnalysis as VehicleAgg 
        on Customer.route_id = VehicleAgg.Route
    join my.Constraints on Customer.route_id = Constraints.route_id
   


{
    key Customer.route_id as Route,
    count(distinct Customer.customer_code) as CustomerNumber: Integer,
    round(sum(Customer.total_weight_kg), 3) as SumWeight: Decimal,
    round(sum(Customer.total_volume_m3), 3) as SumVolume: Decimal,
    round(avg(Customer.customer_time_window_to_min - Customer.customer_time_window_from_min), 3) as AverageServiceTime: Decimal,
    sum(Customer.number_of_articles) as SumArticles: Integer,
    round(avg( case when weightusage != 0 then weightusage end ), 2) as AvgWeightUsage: Decimal(5,2),
    round(avg(case when volumeusage != 0 then volumeusage end), 2) as AvgVolumeUsage: Decimal(5,2),

    round(sum(distinct Vehicle.result_vehicle_total_driving_time_min), 3) as DrivingTime: Decimal,
    round(sum(distinct Vehicle.result_vehicle_total_delivery_time_min),3) as DeliveryTime: Decimal,
    round(sum(distinct Vehicle.result_vehicle_total_active_time_min),3) as ActiveTime: Decimal,
    round(sum(distinct Vehicle.result_vehicle_final_cost_km),3) as VehicleCost: Decimal,

    count (distinct(Constraints.ID)) as ConstraintCount: Integer,

    AVGCustomerDistanceKM AS avg_customer_spread: Decimal,
    AVGCustomerTimeMin AS avg_customer_spread_time: Decimal,
    AvgDepotCustomerDistanceKM AS avg_depot_distance: Decimal,

 
    max(Dist.distance_km) as MaxCustomerDistanceKM : Decimal(10,2),
    VehicleAgg.VehicleCapacityKG,
    VehicleAgg.VehicleVolumeM3,

    round(count(distinct(Constraints.ID)) * 1.0 / nullif(count(distinct Constraints.sdvrp_constraint_customer_code), 0), 2) as AvgConstraintsPerCustomer: Decimal(5,2),


  






} group by Customer.route_id;

    action checkAI (Query: String) ;
    action showCorrelations();
    function diagram(xField: String, yField: String, Query: String) returns LargeString;






}


service insights {

   entity SpreadVehicleAnalysis as select from my.Vehicle {
    key route_id as Route,
    sum(vehicle_total_weight_kg) as VehicleCapacityKG: Decimal(10,2),
    sum(vehicle_total_volume_m3) as VehicleVolumeM3: Decimal(10,2)
  } group by route_id;

    entity ScenarioInsights as select from my.Customer
  left join my.Vehicle on Customer.route_id = Vehicle.route_id
    left join my.Depots as Depot on Customer.route_id = Depot.route_id
    left join my.DepotDistance as Dist 
        on Customer.route_id = Dist.route_id 
        and Customer.customer_code = Dist.customer_code
    left join my.Spread as Spread on Customer.route_id = Spread.route_id
    left join SpreadVehicleAnalysis as VehicleAgg 
        on Customer.route_id = VehicleAgg.Route
    join my.Constraints on Customer.route_id = Constraints.route_id
left join my.RouteReasons as Reasons on Customer.route_id = Reasons.route_id
{
  key Customer.route_id as Route,
  count(distinct Customer.customer_code) as CustomerCount: Integer,
  round(avg(Customer.customer_time_window_to_min - Customer.customer_time_window_from_min), 2) as AverageServiceTime: Decimal(10,2),
  count(distinct Constraints.ID) as ConstraintCount: Integer,
   count(distinct Customer.customer_code) as CustomerNumber: Integer,
    round(sum(Customer.total_weight_kg), 3) as SumWeight: Decimal,
    round(sum(Customer.total_volume_m3), 3) as SumVolume: Decimal,

    sum(Customer.number_of_articles) as SumArticles: Integer,
    round(avg( case when weightusage != 0 then weightusage end ), 2) as AvgWeightUsage: Decimal(5,2),
    round(avg(case when volumeusage != 0 then volumeusage end), 2) as AvgVolumeUsage: Decimal(5,2),

    round(sum(distinct Vehicle.result_vehicle_total_driving_time_min), 3) as DrivingTime: Decimal,
    round(sum(distinct Vehicle.result_vehicle_total_delivery_time_min),3) as DeliveryTime: Decimal,
    round(sum(distinct Vehicle.result_vehicle_total_active_time_min),3) as ActiveTime: Decimal,
    round(sum(distinct Vehicle.result_vehicle_final_cost_km),3) as VehicleCost: Decimal,


    AVGCustomerDistanceKM AS avg_customer_spread: Decimal,
    AVGCustomerTimeMin AS avg_customer_spread_time: Decimal,
    AvgDepotCustomerDistanceKM AS avg_depot_distance: Decimal,

 
    max(Dist.distance_km) as MaxCustomerDistanceKM : Decimal(10,2),
    VehicleAgg.VehicleCapacityKG,
    VehicleAgg.VehicleVolumeM3,

    
    known_issues as Issues: String,

    data_availability as  Data: String,

    case when data_availability = 0 then 'Data available'
    else 'Data not available'
    end as dataclassifier: String,

     case when data_availability = 0 then 3
    else 1
    end as datacrit: Integer,


    status as ChallengeStatus: Integer,
    case

        when status = 1 then 'Severe'
        when status <= 2 then 'Moderate'
        else 'Minor'
        end as ChallengeLevel: String,

         case

          when status = 1 then 1
        when status = 2 then 2
        else 3
        end as challengecrit: String,



    round(count(distinct(Constraints.ID)) * 1.0 / nullif(count(distinct Constraints.sdvrp_constraint_customer_code), 0), 2) as AvgConstraintsPerCustomer: Decimal(5,2),

      cast (487.56 as Decimal (5,2)) as AvgCustAvailability: Decimal,
      cast(169.82 as Decimal(5,2)) as ReferenceValueVehicleCost: Decimal,
      cast(40.18 as Decimal(5,2)) as ReferenceValueConstraintLevel: Decimal,
      cast(40.18 as Decimal(5,2)) as ReferenceValueCustDIst: Decimal,
      cast(105.27 as Decimal(5,2)) as ReferenceCustCount: Decimal, 


  short_description as short_description: String,
  description as description: String


}
where Customer.route_id in ( '2604001', '2990001', '3005971', '3016355', '3044702' )
group by Customer.route_id

}



    