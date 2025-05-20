import React, { useState, useEffect } from 'react';
import axios from 'axios';
import './App.css';

function App() {
  const [readings, setReadings] = useState([]);

  useEffect(() => {
    fetchReadings();
    const interval = setInterval(fetchReadings, 5000);
    return () => clearInterval(interval);
  }, []);

  const fetchReadings = async () => {
    try {
      const response = await axios.get('https://app-dev-backend.onrender.com/data');
      setReadings(response.data);
    } catch (error) {
      console.error('Failed to fetch energy data:', error);
    }
  };

  const latest = readings.length ? readings[readings.length - 1] : {};

  const DataCard = ({ label, value, bg, icon }) => (
    <div className="data-card" style={{ backgroundColor: bg }}>
      <div className="card-header">
        <span className="card-icon">{icon}</span>
        <span className="card-label">{label}</span>
      </div>
      <div className="card-value">{value}</div>
    </div>
  );

  return (
    <div className="app-container">
      <h1>Energy Track</h1>
      <div className="card-grid">
        <DataCard label="Power" value={`${(latest.power || 0).toFixed(2)} W`} bg="#bbdefb" icon="⚡" />
        <DataCard label="Current" value={`${(latest.current || 0).toFixed(2)} A`} bg="#fff9c4" icon="🔌" />
        <DataCard label="Voltage" value={`${(latest.voltage || 0).toFixed(2)} V`} bg="#f8bbd0" icon="🔋" />
        <DataCard label="Energy" value={`${(latest.kwh || 0).toFixed(2)} kWh`} bg="#c8e6c9" icon="💡" />
      </div>

      {/* History Table */}
      <div style={{
        marginTop: '40px',
        padding: '16px',
        backgroundColor: '#e3f2fd',
        borderRadius: '8px',
        maxWidth: '100%',
        overflowX: 'auto'
      }}>
        <h2 style={{ marginBottom: '12px' }}>Data History</h2>
        <table style={{ width: '100%', borderCollapse: 'collapse' }}>
          <thead>
            <tr>
              <th style={thStyle}>ID</th>
              <th style={thStyle}>Voltage</th>
              <th style={thStyle}>Current</th>
              <th style={thStyle}>Power</th>
              <th style={thStyle}>kWh</th>
              <th style={thStyle}>Timestamp</th>
            </tr>
          </thead>
          <tbody>
            {readings.map((item, index) => (
              <tr key={index}>
                <td style={tdStyle}>{item.id ?? 'N/A'}</td>
                <td style={tdStyle}>{(item.voltage ?? 0).toFixed(2)}</td>
                <td style={tdStyle}>{(item.current ?? 0).toFixed(2)}</td>
                <td style={tdStyle}>{(item.power ?? 0).toFixed(2)}</td>
                <td style={tdStyle}>{(item.kwh ?? 0).toFixed(4)}</td>
                <td style={tdStyle}>{item.timestamp ? new Date(item.timestamp).toLocaleString() : 'N/A'}</td>
              </tr>
            ))}
          </tbody>

        </table>
      </div>
    </div>
  );
}

const thStyle = {
  fontSize: '12px',
  fontWeight: 'bold',
  borderBottom: '1px solid #ccc',
  padding: '8px',
  color: '#333',
};

const tdStyle = {
  fontSize: '11px',
  padding: '6px',
  borderBottom: '1px solid #eee',
  textAlign: 'center',
  color: '#333',
};

export default App;
