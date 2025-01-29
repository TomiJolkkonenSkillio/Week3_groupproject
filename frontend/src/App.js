import React, { useState } from "react";
import axios from "axios";

function App() {
  const [consultantName, setConsultantName] = useState("");
  const [customerName, setCustomerName] = useState("");
  const [startTime, setStartTime] = useState("");
  const [endTime, setEndTime] = useState("");
  const [lunchBreak, setLunchBreak] = useState("");
  const [report, setReport] = useState(null);

  const handleAddHours = async () => {
    try {
      await axios.post("http://localhost:5000/time_management/add_hours", {
        consultant_name: consultantName,
        customer_name: customerName,
        start_time: startTime,
        end_time: endTime,
        lunch_break: lunchBreak,
      });
      alert("Hours added successfully!");
    } catch (error) {
      console.error("Error adding hours:", error);
      alert("Failed to add hours.");
    }
  };

  const handleGetDailyReport = async () => {
    try {
      const response = await axios.get("http://localhost:5000/generate_report/daily");
      setReport(response.data);
    } catch (error) {
      console.error("Error fetching daily report:", error);
      alert("Failed to fetch daily report.");
    }
  };

  const handleGetWeeklyReport = async () => {
    try {
      const response = await axios.get("http://localhost:5000/generate_report/weekly");
      setReport(response.data);
    } catch (error) {
      console.error("Error fetching weekly report:", error);
      alert("Failed to fetch weekly report.");
    }
  };

  return (
    <div className="min-h-screen flex flex-col items-center justify-center bg-gray-100">
      <h1 className="text-2xl font-bold mb-4">Consultant Time Management</h1>

      <div className="mb-4">
        <label className="block mb-2 font-medium">Consultant Name</label>
        <input
          type="text"
          value={consultantName}
          onChange={(e) => setConsultantName(e.target.value)}
          className="p-2 border rounded w-64"
        />
      </div>

      <div className="mb-4">
        <label className="block mb-2 font-medium">Customer Name</label>
        <input
          type="text"
          value={customerName}
          onChange={(e) => setCustomerName(e.target.value)}
          className="p-2 border rounded w-64"
        />
      </div>

      <div className="mb-4">
        <label className="block mb-2 font-medium">Start Time</label>
        <input
          type="datetime-local"
          value={startTime}
          onChange={(e) => setStartTime(e.target.value)}
          className="p-2 border rounded w-64"
        />
      </div>

      <div className="mb-4">
        <label className="block mb-2 font-medium">End Time</label>
        <input
          type="datetime-local"
          value={endTime}
          onChange={(e) => setEndTime(e.target.value)}
          className="p-2 border rounded w-64"
        />
      </div>

      <div className="mb-4">
        <label className="block mb-2 font-medium">Lunch Break (in minutes)</label>
        <input
          type="number"
          value={lunchBreak}
          onChange={(e) => setLunchBreak(e.target.value)}
          className="p-2 border rounded w-64"
        />
      </div>

      <div className="flex space-x-4">
        <button
          onClick={handleAddHours}
          className="px-4 py-2 bg-blue-500 text-white rounded hover:bg-blue-600"
        >
          Add Hours
        </button>
        <button
          onClick={handleGetDailyReport}
          className="px-4 py-2 bg-green-500 text-white rounded hover:bg-green-600"
        >
          Get Daily Report
        </button>
        <button
          onClick={handleGetWeeklyReport}
          className="px-4 py-2 bg-orange-500 text-white rounded hover:bg-orange-600"
        >
          Get Weekly Report
        </button>
      </div>

      {report && (
        <div className="mt-6 p-4 bg-white rounded shadow-md w-3/4">
          <h2 className="text-xl font-bold mb-2">Report</h2>
          <pre className="bg-gray-100 p-2 rounded">{JSON.stringify(report, null, 2)}</pre>
        </div>
      )}
    </div>
  );
}

export default App;
