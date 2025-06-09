using { sap.capire.vrp as my, sap.capire.vrp.ClassificationLevel } from '../db/schema';

service Visualization {

    @readonly
    entity Routelocations as select from my.Customer as Customer 
    left join my.Depots as Depot on Customer.route_id = Depot.route_id
    left join my.Route as Way on Customer.route_id = Way.route_id 
    left  join  my.Vehicle as Vehicle on Customer.route_id = Vehicle.route_id{

       
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



        @UI.Hidden: false
        key Customer.route_id as Route,
        
        round(sum(Customer.number_of_articles), 3) as SumArticles: Decimal,
        round(sum(Customer.total_weight_kg), 3)    as SumWeight: Decimal,
        round(sum(Customer.total_volume_m3), 3)    as SumVolume: Decimal,
        round(avg(customer_time_window_to_min - customer_time_window_from_min), 3) as AverageServiceTime: Decimal,
        Way.route_date as RouteDate: DateTime,
        Way.route_code as RouteCode: String,
        Depot.depot_latitude as DepotLatitude,
        Depot.depot_longitude as DepotlLongitude,
        Depot.depot_code as DepotCode,


        to_Vehicles: Composition of many Vehicle on to_Vehicles.Route = $self.Route,
        to_VehicleDistributionView: Composition of  many VehicleDistributionView on to_VehicleDistributionView.Route = $self.Route,
        to_Customers: association to many RouteCustomers on to_Customers.RouteID = $self.Route,
        to_blocks: Association to many  BlockedRoads on True,



    
    }group by Customer.route_id;


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
    } where result_vehicle_total_driving_time_min != 0;

   entity VehicleDistribution as select from my.Vehicle {
    key vehicle_code                 as VehicleCode: String,
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




entity CustomerArticleSummary as select from my.Customer {


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

  case
    when sum(number_of_articles) >2000 then 3
    when sum(number_of_articles) <1750 then 1
    else 2
  end as TotalArticleCriticality: Integer,

case
  when round(avg(customer_time_window_to_min - customer_time_window_from_min), 3) >= 454 then 5
  when round(avg(customer_time_window_to_min - customer_time_window_from_min), 3) >= 448 then 4
  when round(avg(customer_time_window_to_min - customer_time_window_from_min), 3) >= 442 then 3
  when round(avg(customer_time_window_to_min - customer_time_window_from_min), 3) >= 436 then 2
  else 1
end as AverageServiceStars: Integer,
  


} group by Customer.route_id ;


      

}