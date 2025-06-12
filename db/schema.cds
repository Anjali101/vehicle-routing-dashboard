using { cuid } from '@sap/cds/common';
namespace sap.capire.vrp; 

entity Route: cuid  {
    key ID: String;
    route_id: String;
    route_code: String;
    route_date: DateTime;
    algorithm_number_of_iterations: Integer;
    result_total_cost_km: Decimal;
};

entity Customer: cuid {

    key ID: UUID;
    route_id: String;
    customer_number: String;
    customer_code: String;
    customer_latitude: Decimal;
    customer_longitude: Decimal;
    customer_time_window_from_min: Decimal;
    customer_time_window_to_min: Decimal;
    number_of_articles: Integer;
    total_weight_kg: Decimal;
    total_volume_m3: Decimal;
    customer_delivery_service_time_min: Decimal;
}


entity Vehicle: cuid  {
    key ID: UUID;
    route_id: String;
    vehicle_number: Integer;
    vehicle_code: String;
    vehicle_total_weight_kg: Decimal;
    vehicle_total_volume_m3: Decimal;
    vehicle_fixed_cost_km: Decimal;
    vehicle_variable_cost_km: Decimal;
    vehicle_available_time_from_min: Decimal;
    vehicle_available_time_to_min: Decimal;
    result_vehicle_total_driving_time_min: Decimal;
    result_vehicle_total_delivery_time_min: Decimal;
    result_vehicle_total_active_time_min: Decimal;
    result_vehicle_driving_weight_kg: Decimal;
    result_vehicle_driving_volume_m3: Decimal;
    result_vehicle_final_cost_km: Decimal;
} 

entity Depots: cuid {

    key ID: UUID;
    route_id: String;
    depot_number: Integer;
    depot_code: String;
    depot_latitude: Decimal;
    depot_longitude: Decimal;
    depot_available_time_from_min: Decimal;
    depot_available_time_to_min: Decimal;
}

entity Constraints: cuid {

    key ID: UUID;
    route_id: String;
    sdvrp_constraint_number: Integer;
    sdvrp_constraint_customer_code: String;
    sdvrp_constraint_vehicle_code: String;
}

entity DepotDistance: cuid {
    key ID: UUID;
    route_id: String;
    customer_number: String;
    depot_code: String;
    customer_code: String;
    direction: String;
    distance_km: Decimal;
    time_distance_min: Decimal;
}

entity CustomerDistance: cuid {
    
    key ID: UUID;
    route_id: String;
    customer_code_from: String;
    customer_code_to: String;
    distance_km: Decimal;
    time_distance_min: Decimal;
}

entity BlockedRoad: cuid {
    key ID: UUID;
    blocked_part_of_the_road_lat: Decimal;
    blocked_part_of_the_road_lon: Decimal;
}

entity Routes as select from Route {
    key route_id as RouteID,
    route_code as RouteCode
}

type ClassificationLevel : String enum {
    Low;
    Medium;
    High;
}

entity CustomerLoadValues {
    key Value: String;
    Label: String;
}