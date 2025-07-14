module.exports = class scenariocharacteristics extends cds.ApplicationService {
  init() {
    this.on("checkAI", (req) => this.onCheckAI(req));
    this.on("diagram", (req) => this.onDiagram(req));
    this.on("showCorrelations", (req) => {req.info(getSuggestedCorrelationsMessage());});
    return super.init();
  }



  async onCheckAI(req) {
    const data = await SELECT.from(this.entities.characteristics);
    if (!data?.length) return req.error(400, "No data available.");

    const headers = Object.keys(data[0]).filter(h => h !== 'CustomerCode');
    let csv = headers.join(',') + '\n';
    data.forEach(row => {
      const line = headers.map(h => row[h]).join(',');
      csv += line + '\n';
    });

    const userInput = req.data.Query;
    const contextPrompt = `
You are a data analysis assistant.

Below is a CSV dataset. Based on the data, answer the following question as precisely as possible.
If the question asks for a statistical result (like correlation, average, regression line), calculate and return the value.
If possible, include the formula or value you used, but keep the explanation brief unless asked otherwise.

Question:
${userInput}`.trim();

    const token = await getToken();
    const response = await doQuery(token, contextPrompt, csv);
    const message = response?.choices?.[0]?.message?.content || "AI did not return a result.";




    console.log("🧠 AI Input:\n", userInput);
    console.log("📥 AI Output:\n", message);

    req.info(message)


    return message;
  }

  async onDiagram(req) {
    const { xField, yField, Query } = req.data;

    const allowedFields = [
      "CustomerNumber", "SumWeight", "SumVolume", "AverageServiceTime",
      "SumArticles", "DrivingTime", "DeliveryTime", "ActiveTime", "VehicleCost", "ConstraintCount",
      "AvgConstraintsPerCustomer", "AvgWeightUsage", "AvgVolumeUsage", "MaxCustomerDistanceKM",
      "VehicleCapacityKG", "VehicleVolumeM3", "avg_customer_spread", "avg_customer_spread_time"
    ];

    if (!allowedFields.includes(xField) || !allowedFields.includes(yField)) {
      return req.error(400, `Invalid field(s): ${xField}, ${yField}`);
    }
    if (xField === yField) {
      return req.error(400, "xField and yField must be different.");
    }

    const rows = await SELECT.from(this.entities.characteristics).columns(xField, yField);
    const jsonData = JSON.stringify(rows, null, 2);

    const defaultPrompt = `
You are a data visualization assistant specialized in generating clean and accurate SVG scatter plots with linear regression lines.

Your task is to generate a complete, valid, and responsive <svg> element using a JSON array of objects with two numeric fields: "${xField}" and "${yField}".

Requirements:

1. Scatter Plot
- Plot each (${xField}, ${yField}) pair as a blue circle (radius between 4 and 6 pixels).
- Dynamically scale X and Y values to fit within a defined plot area inside the canvas.
- Flip the Y-axis so that larger Y-values appear higher on the screen.
- Do not hardcode pixel positions — derive them from actual data min/max ranges.

2. Regression Line
- Perform linear regression using the given data (least squares).
- Compute slope and intercept: y = mx + b.
- Use the min and max X values to compute corresponding Y values via the regression equation.
- Draw a red line through those two endpoints (scaled to canvas).
- Include the regression formula (e.g., y = 1.25x + 34.6) as a red <text> element in the top-right of the plot.

3. Axes and Tick Marks
- Add both X and Y axes as black lines.
- Compute and display at least 3–5 evenly spaced numeric ticks on each axis (scaled and labeled).
- Label the X-axis as "${xField}" and the Y-axis as "${yField}".
- Position X-axis label centered below the axis; position Y-axis label rotated 90 degrees, centered on the left.

4. Layout and Scaling
- Set the canvas to width="600" and height="400".
- Define margins/padding: at least 40px on all sides.
- Use the remaining space (after margins) as the plot area for scaling coordinates.
- Ensure that no points, lines, or labels are clipped.

5. Text and Styling
- Use font-size 10–12px for tick labels and axis labels.
- The regression formula text should be clearly visible and styled in red.

6. Output Rules
- Output only the raw <svg>...</svg> element.
- Do not include any markdown, HTML wrappers, code comments, or explanations.

The result must be mathematically accurate, cleanly labeled, and visually balanced. Output only a single self-contained <svg> element.
`.trim();

  console.log("🚀 Diagram Data Rows:", rows);
    const finalQuery = Query || defaultPrompt;
    const token = await getToken();
    const response = await doDiagramQuery(token, finalQuery, jsonData);

    console.log("🤖 AI raw response:", JSON.stringify(response, null, 2));

    let svg = response?.choices?.[0]?.message?.content || "<p>AI failed to generate chart.</p>";
    if (svg.startsWith("```")) {
      svg = svg.replace(/```(?:html|svg)?/g, "").trim();
    }

    console.log("📈 Generated SVG for:", xField, yField);
    return svg;
  }
};


function getSuggestedCorrelationsMessage() {
  return `
Here are interesting Correlations to look at:

 Customer Count - Various Vehicle Driving Sats

 Geogrpahical Spread - Vehicle Capacities (average Weight and Volume Usage)

 Constraint Amount per Customer and Driving Time 

 Package Statistics and Route Cost

 Constraint Amount - Route Cost

 Geographical Spread - Route Cost


Further Correlations can be freely explored in the Chart. "Generate Scatter Plot" Button
to visualize a regresssion line on the scatter plot of two variables
  `.trim();
}


function renderSVG({ slope, intercept, xMin, xMax, yMin, yMax, normalizedPoints }) {
  const width = 600;
  const height = 400;
  const margin = 40;
  const plotWidth = width - margin * 2;
  const plotHeight = height - margin * 2;

  // Map normalized data points to pixel coordinates
  const pointsSVG = normalizedPoints.map(p => {
    const cx = margin + p.x * plotWidth;
    const cy = margin + (1 - p.y) * plotHeight; // flip y-axis
    return `<circle cx="${cx}" cy="${cy}" r="5" fill="blue" />`;
  }).join('\n');

  // Compute regression line endpoints using min and max X values
  const x1 = xMin;
  const x2 = xMax;
  const y1 = slope * x1 + intercept;
  const y2 = slope * x2 + intercept;

  // Normalize regression points
  const normX1 = (x1 - xMin) / (xMax - xMin);
  const normX2 = (x2 - xMin) / (xMax - xMin);
  const normY1 = (y1 - yMin) / (yMax - yMin);
  const normY2 = (y2 - yMin) / (yMax - yMin);

  const x1p = margin + normX1 * plotWidth;
  const x2p = margin + normX2 * plotWidth;
  const y1p = margin + (1 - normY1) * plotHeight;
  const y2p = margin + (1 - normY2) * plotHeight;

  const regressionLine = `<line x1="${x1p}" y1="${y1p}" x2="${x2p}" y2="${y2p}" stroke="red" />`;
  const formulaText = `<text x="${width - margin - 10}" y="${margin + 10}" text-anchor="end" font-size="12" fill="red">y = ${slope.toFixed(2)}x + ${intercept.toFixed(2)}</text>`;

  // Axes
  const axes = `
    <line x1="${margin}" y1="${margin + plotHeight}" x2="${margin + plotWidth}" y2="${margin + plotHeight}" stroke="black" />
    <line x1="${margin}" y1="${margin}" x2="${margin}" y2="${margin + plotHeight}" stroke="black" />
    <text x="${width / 2}" y="${height - 5}" text-anchor="middle">${'X Axis'}</text>
    <text x="15" y="${height / 2}" text-anchor="middle" transform="rotate(-90, 15, ${height / 2})">${'Y Axis'}</text>
  `;

  return `
<svg width="${width}" height="${height}" xmlns="http://www.w3.org/2000/svg">
  ${axes}
  ${pointsSVG}
  ${regressionLine}
  ${formulaText}
</svg>
`.trim();
}


// --- 🔐 SAP AI Core Token Fetch ---
async function getToken() {
  const url = 'https://btplearning-w4kbx4of.authentication.us10.hana.ondemand.com/oauth/token?grant_type=client_credentials&response_type=token';
  const username = process.env.USERNAME;
  const password = process.env.PASSWORD;

  const headers = {
    'Authorization': 'Basic ' + Buffer.from(username + ':' + password).toString('base64'),
    'Content-Type': 'application/x-www-form-urlencoded'
  };

  const response = await fetch(url, {
    method: 'POST',
    headers
  });

  const data = await response.json();
  return data.access_token;
}

// --- 🧠 SAP AI Core Diagram Generation ---
async function doDiagramQuery(token, query, inputJson) {
  const url = "https://api.ai.prod.us-east-1.aws.ml.hana.ondemand.com/v2/inference/deployments/d85ed0c1b02d8a27/chat/completions?api-version=2023-05-15";

  const headers = {
    "Content-Type": "application/json",
    "AI-Resource-Group": "default",
    "Authorization": "Bearer " + token
  };

  const body = {
    
    messages: [
      {
        role: "system",
        content: "You are a helpful assistant that outputs HTML/SVG for visualizing data. Step 1: Repeat the CSV data you received exactly as it was given."
      },
      {
        role: "user",
        content: `Given the following JSON array:\n\n${inputJson}\n\n${query}`
      }
    ],
    max_tokens: 4000,
    temperature: 0.2
  };

  const response = await fetch(url, {
    method: "POST",
    headers,
    body: JSON.stringify(body)
  });

  return await response.json();
}

// --- 🧠 SAP AI Core Data Q&A ---
async function doQuery(token, query, csvData) {
  const url = "https://api.ai.prod.us-east-1.aws.ml.hana.ondemand.com/v2/inference/deployments/d85ed0c1b02d8a27/chat/completions?api-version=2023-05-15";

  const headers = {
    "Content-Type": "application/json",
    "AI-Resource-Group": "default",
    "Authorization": "Bearer " + token
  };

  const body = {
    messages: [
      {
        role: "system",
        content: "You are a helpful assistant that analyzes CSV data and answers questions."
      },
      {
        role: "user",
        content: `Given the following CSV:\n\n${csvData}\n\n${query}`
      }
    ],
    max_tokens: 1000,
    temperature: 0.0
  };

  const response = await fetch(url, {
    method: "POST",
    headers,
    body: JSON.stringify(body)
  });

  return await response.json();
}

