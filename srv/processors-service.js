


module.exports = srv => {
    // Your event handlers go here
    srv.on('navigateToVehicleStats', req => {
      // Optional: You can return nothing if it's only for navigation
      return {};
    });
  };