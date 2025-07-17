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

const startTime = Date.now();





    const token = await getToken();


const afterToken = Date.now();
console.log(" Token fetch time:", afterToken - startTime, "ms");
    const response = await doQuery(token, contextPrompt, csv);

    const afterAI = Date.now();
    console.log(" AI query time:", afterAI - afterToken, "ms");
    console.log(" Total time:", afterAI - startTime, "ms");


    const message = response?.choices?.[0]?.message?.content || "AI did not return a result.";




    console.log(" AI Input:\n", userInput);
    console.log(" AI Output:\n", message);

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
  You are a data assistant. You will be given a JSON array of numeric data points representing two fields: "${xField}" (X axis) and "${yField}" (Y axis).

Perform the following steps carefully and return only a strict JSON object with the results.

### Steps:

1. Compute a **simple linear regression**:
   - Return slope (m)
   - Return intercept (b)
   - Include the formula: y = mx + b
   - align the line of the formula with the axis, e.g that the line goes thorugh the point by interpreting the axis and its valeus as a coordinate system and plotting the formula y =mx +b

2. Determine:
   - xMin and xMax (the minimum and maximum values of "${xField}")
   - yMin and yMax (the minimum and maximum values of "${yField}")

3. Normalize each data point:
   - Use min-max normalization to convert x and y values into the [0,1] range.
   - Formula for normalization:  
     - normalizedX = (x - xMin) / (xMax - xMin)  
     - normalizedY = (y - yMin) / (yMax - yMin)

4. Return the normalized values as a list of points:
   - Structure: { x: <normalizedX>, y: <normalizedY> }

### Example Response Format:
json
{
  "slope": 1.23,
  "intercept": 45.6,
  "formula": "y = 1.23x + 45.6",
  "xMin": 78,
  "xMax": 129,
  "yMin": 1185.99,
  "yMax": 1863.69,
  "normalizedPoints": [
    { "x": 0.0, "y": 0.0 },
    { "x": 0.5, "y": 0.75 },
    { "x": 1.0, "y": 1.0 }
  ]
}
  `.trim();
  
    const finalQuery = Query || defaultPrompt;
    const token = await getToken();
    const response = await doDiagramQuery(token, finalQuery, jsonData);
    
    const raw = response?.choices?.[0]?.message?.content;
    if (!raw) return "<p>AI did not return a result.</p>";
    
    // No response.text() needed!
    let json;
    try {
      const cleaned = raw.replace(/```json|```/g, "").trim();
      json = JSON.parse(cleaned);
    } catch (err) {
      console.error(" Failed to parse AI JSON:", raw);
      return "<p>AI returned invalid data.</p>";
    }
    
    console.log(" Parsed AI JSON:", json);
    const svg = renderSVG(json, xField, yField);
    return svg;
  }};


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


function renderSVG({ slope, intercept, xMin, xMax, yMin, yMax, normalizedPoints }, xLabel, yLabel) {
  const width = 600;
  const height = 400;
  const margin = 40;
  const plotWidth = width - 2 * margin;
  const plotHeight = height - 2 * margin;

  // Filter out invalid (0, 0) point
  const points = normalizedPoints.filter(p => !(p.x === 0 && p.y === 0));

  const pointsSVG = points.map(p => {
    const cx = margin + p.x * plotWidth;
    const cy = margin + (1 - p.y) * plotHeight;
    return `<circle cx="${cx}" cy="${cy}" r="5" fill="blue" />`;
  }).join('\n');

  // Regression line
  const normY1 = (slope * xMin + intercept - yMin) / (yMax - yMin);
  const normY2 = (slope * xMax + intercept - yMin) / (yMax - yMin);
  const x1p = margin;
  const x2p = margin + plotWidth;
  const y1p = margin + (1 - normY1) * plotHeight;
  const y2p = margin + (1 - normY2) * plotHeight;

  const regressionLine = `<line x1="${x1p}" y1="${y1p}" x2="${x2p}" y2="${y2p}" stroke="red" />`;
  const formulaText = `<text x="${width - margin - 10}" y="${margin + 10}" text-anchor="end" font-size="12" fill="red">y = ${slope.toFixed(2)}x + ${intercept.toFixed(2)}</text>`;

  // Tick generation (5 ticks per axis)
  function ticks(min, max, count = 5) {
    const step = (max - min) / (count - 1);
    return Array.from({ length: count }, (_, i) => min + i * step);
  }

  const xTicks = ticks(xMin, xMax);
  const yTicks = ticks(yMin, yMax);

  const xTickLabels = xTicks.map(tick => {
    const x = margin + ((tick - xMin) / (xMax - xMin)) * plotWidth;
    return `<text x="${x}" y="${margin + plotHeight + 15}" text-anchor="middle" font-size="10">${tick.toFixed(0)}</text>`;
  }).join('\n');

  const yTickLabels = yTicks.map(tick => {
    const y = margin + (1 - (tick - yMin) / (yMax - yMin)) * plotHeight;
    return `<text x="${margin - 5}" y="${y + 3}" text-anchor="end" font-size="10">${tick.toFixed(0)}</text>`;
  }).join('\n');

  // Axis lines and labels
  const axes = `
    <line x1="${margin}" y1="${margin + plotHeight}" x2="${margin + plotWidth}" y2="${margin + plotHeight}" stroke="black" />
    <line x1="${margin}" y1="${margin}" x2="${margin}" y2="${margin + plotHeight}" stroke="black" />

    <text x="${margin + plotWidth / 2}" y="${height - 5}" text-anchor="middle" font-size="12">${xLabel}</text>
    <text x="10" y="${margin + plotHeight / 2}" text-anchor="middle" font-size="12" transform="rotate(-90, 10, ${margin + plotHeight / 2})">${yLabel}</text>
  `;

  return `
<svg width="${width}" height="${height}" xmlns="http://www.w3.org/2000/svg">
  ${axes}
  ${xTickLabels}
  ${yTickLabels}
  ${pointsSVG}
  ${regressionLine}
  ${formulaText}
</svg>
`.trim();
}



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


async function doQuery(token, query, input) {
  const url = "https://api.ai.prod.us-east-1.aws.ml.hana.ondemand.com/v2/inference/deployments/d85ed0c1b02d8a27/chat/completions?api-version=2023-05-15";

  const headers = {
    "Content-Type": "application/json",
    "AI-Resource-Group": "default",
    "Authorization": "Bearer " + token
  };

  const body = {
    messages: [
      {
        role: "user",
        content: `Given following data in csv format:\n\n${input}\n\n${query}`
      }
    ],
    max_tokens: 1000,
    temperature: 0.0,
    frequency_penalty: 0,
    presence_penalty: 0,
    stop: "null"
  };

  const response = await fetch(url, {
    method: "POST",
    headers,
    body: JSON.stringify(body)
  });

  console.log(response)
  const contentType = response.headers.get("content-type");
  const raw = await response.text();

  if (!response.ok) {
    console.error(" AI API returned HTTP error:", response.status, raw);
    return { error: `AI API error: ${raw}` };
  }

  if (!contentType || !contentType.includes("application/json")) {
    console.error(" Unexpected content type:", contentType);
    console.error(" Body:", raw);
    return { error: `AI returned unexpected format: ${raw}` };
  }

  try {
    return JSON.parse(raw);
  } catch (err) {
    console.error(" Failed to parse AI JSON:", raw);
    return { error: "AI returned invalid JSON" };
  }}