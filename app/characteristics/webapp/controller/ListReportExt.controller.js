sap.ui.define([
  'sap/m/MessageToast',
  'sap/m/MessageBox',
  "sap/ui/core/mvc/ControllerExtension",
  "sap/ui/core/Fragment",
  "sap/ui/model/json/JSONModel",
  "sap/ui/core/HTML"
], (MessageToast, MessageBox, ControllerExtension, Fragment, JSONModel, HTML) => ControllerExtension.extend('characteristics.controller.ListReportExt', {

  async openDiagram() {
    if (!this._dialog) {
      this._dialog = await Fragment.load({
        name: "characteristics.ext.fragment.UploadDiagram",
        controller: this
      });

      this.getView().addDependent(this._dialog);

      const fields = [
        { name: "CustomerNumber", label: "Total Customers" },
        { name: "SumWeight", label: "Total Weight" },
        { name: "SumVolume", label: "Total Volume" },
        { name: "AverageServiceTime", label: "Avg Service Time" },
        { name: "SumArticles", label: "Total Articles" },
        { name: "DrivingTime", label: "Driving Time" },
        { name: "DeliveryTime", label: "Delivery Time" },
        { name: "ActiveTime", label: "Active Time" },
        { name: "VehicleCost", label: "Vehicle Cost" }
      ];

      const model = new JSONModel({ fields });
      this._dialog.setModel(model, "fieldsModel");
    }

    this._dialog.open();
  },

  async onGeneratePlot() {
    const xField = sap.ui.getCore().byId("xFieldSelect").getSelectedKey();
    const yField = sap.ui.getCore().byId("yFieldSelect").getSelectedKey();
    const sQuery = "";
  
    const oModel = this.getView().getModel();
    const oContextBinding = oModel.bindContext("/diagram(...)");
    oContextBinding.setParameter("xField", xField);
    oContextBinding.setParameter("yField", yField);
    oContextBinding.setParameter("Query", sQuery);
  
    try {
      await oContextBinding.execute();
      const result = oContextBinding.getBoundContext().getObject();
  
      let svg = result.value;
  
      // ✅ Clean markdown-wrapped AI output
      if (svg.startsWith("Sure!") || svg.includes("```html")) {
        svg = svg
          .replace(/^.*?<svg/si, "<svg") // Remove anything before <svg
          .replace(/```/g, "")            // Remove markdown code fences
          .replace(/<\/svg>.*$/si, "</svg>"); // Remove trailing explanation after </svg>
      }
  
      // ✅ Inject cleaned SVG
      sap.ui.getCore().byId("svgOutput").setContent(svg);
  
      // Optional: show raw result
      sap.ui.getCore().byId("debugOutput")?.setValue(svg);
  
    } catch (err) {
      sap.m.MessageToast.show("Failed to render diagram.");
      console.error("Diagram error:", err);
    }
  },
  

  onUploadDialogClose() {
    this._dialog.close();
  }
}));