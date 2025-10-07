import React from 'react';
import { BarChart, Bar, XAxis, YAxis, CartesianGrid, Tooltip, Legend, ResponsiveContainer, PieChart, Pie, Cell } from 'recharts';

const NextStrideVisualization = () => {
  // Severity of mobility difficulties
  const mobilityBotherData = [
    { rating: '5 - large amount', count: 9 },
    { rating: '4', count: 9 },
    { rating: '3', count: 2 }
  ];

  // Satisfaction with ability to move
  const satisfactionData = [
    { rating: '1 - not at all', count: 8 },
    { rating: '2', count: 5 },
    { rating: '3', count: 5 },
    { rating: '4', count: 1 },
    { rating: '5 - large amount', count: 1 }
  ];

  // Daily walking distance
  const walkingDistanceData = [
    { category: 'Only in house', count: 11 },
    { category: 'A block or less', count: 6 },
    { category: 'A mile or less', count: 3 }
  ];

  // Falls in last month
  const fallsData = [
    { category: '0 falls', count: 14 },
    { category: '1-3 falls', count: 3 },
    { category: '5 falls', count: 1 },
    { category: '8 falls', count: 1 },
    { category: '15 falls', count: 1 }
  ];

  // Mobility goals
  const goalsData = [
    { goal: 'All of the above', count: 13 },
    { goal: 'Feel safer/less fear', count: 4 },
    { goal: 'Walk more/further', count: 3 }
  ];

  // Reliance on others
  const relianceData = [
    { level: '5 - large amount', count: 7 },
    { level: '4', count: 6 },
    { level: '3', count: 2 },
    { level: '2', count: 0 },
    { level: '1 - not at all', count: 5 }
  ];

  const COLORS = ['#8884d8', '#82ca9d', '#ffc658', '#ff8042', '#8dd1e1'];

  return (
    <div style={{ padding: '20px', backgroundColor: '#f5f5f5', fontFamily: 'Arial, sans-serif' }}>
      <h1 style={{ textAlign: 'center', color: '#333', marginBottom: '10px' }}>
        NextStride Baseline Assessment
      </h1>
      <p style={{ textAlign: 'center', color: '#666', marginBottom: '30px', fontSize: '14px' }}>
        Survey responses from 20 respondents (July-September 2025)
      </p>

      <div style={{ display: 'grid', gridTemplateColumns: 'repeat(auto-fit, minmax(450px, 1fr))', gap: '20px' }}>
        
        {/* Severity of Mobility Difficulties */}
        <div style={{ backgroundColor: 'white', padding: '20px', borderRadius: '8px', boxShadow: '0 2px 4px rgba(0,0,0,0.1)' }}>
          <h3 style={{ marginTop: 0, color: '#333', fontSize: '16px' }}>Severity: How Much Do Mobility Difficulties Bother You?</h3>
          <ResponsiveContainer width="100%" height={250}>
            <BarChart data={mobilityBotherData}>
              <CartesianGrid strokeDasharray="3 3" />
              <XAxis dataKey="rating" angle={-45} textAnchor="end" height={80} style={{ fontSize: '12px' }} />
              <YAxis />
              <Tooltip />
              <Bar dataKey="count" fill="#8884d8" />
            </BarChart>
          </ResponsiveContainer>
          <p style={{ fontSize: '12px', color: '#666', marginTop: '10px' }}>
            90% of respondents report high severity (ratings 4-5)
          </p>
        </div>

        {/* Satisfaction with Mobility */}
        <div style={{ backgroundColor: 'white', padding: '20px', borderRadius: '8px', boxShadow: '0 2px 4px rgba(0,0,0,0.1)' }}>
          <h3 style={{ marginTop: 0, color: '#333', fontSize: '16px' }}>Satisfaction with Ability to Move Around</h3>
          <ResponsiveContainer width="100%" height={250}>
            <BarChart data={satisfactionData}>
              <CartesianGrid strokeDasharray="3 3" />
              <XAxis dataKey="rating" angle={-45} textAnchor="end" height={80} style={{ fontSize: '12px' }} />
              <YAxis />
              <Tooltip />
              <Bar dataKey="count" fill="#82ca9d" />
            </BarChart>
          </ResponsiveContainer>
          <p style={{ fontSize: '12px', color: '#666', marginTop: '10px' }}>
            40% report being "not at all" satisfied with their mobility
          </p>
        </div>

        {/* Daily Walking Distance */}
        <div style={{ backgroundColor: 'white', padding: '20px', borderRadius: '8px', boxShadow: '0 2px 4px rgba(0,0,0,0.1)' }}>
          <h3 style={{ marginTop: 0, color: '#333', fontSize: '16px' }}>Daily Walking Distance</h3>
          <ResponsiveContainer width="100%" height={250}>
            <PieChart>
              <Pie
                data={walkingDistanceData}
                cx="50%"
                cy="50%"
                labelLine={false}
                label={({ category, count }) => `${category}: ${count}`}
                outerRadius={80}
                fill="#8884d8"
                dataKey="count"
              >
                {walkingDistanceData.map((entry, index) => (
                  <Cell key={`cell-${index}`} fill={COLORS[index % COLORS.length]} />
                ))}
              </Pie>
              <Tooltip />
            </PieChart>
          </ResponsiveContainer>
          <p style={{ fontSize: '12px', color: '#666', marginTop: '10px' }}>
            55% are confined to walking only within their house
          </p>
        </div>

        {/* Falls in Last Month */}
        <div style={{ backgroundColor: 'white', padding: '20px', borderRadius: '8px', boxShadow: '0 2px 4px rgba(0,0,0,0.1)' }}>
          <h3 style={{ marginTop: 0, color: '#333', fontSize: '16px' }}>Falls in the Last Month</h3>
          <ResponsiveContainer width="100%" height={250}>
            <BarChart data={fallsData}>
              <CartesianGrid strokeDasharray="3 3" />
              <XAxis dataKey="category" angle={-45} textAnchor="end" height={80} style={{ fontSize: '12px' }} />
              <YAxis />
              <Tooltip />
              <Bar dataKey="count" fill="#ff8042" />
            </BarChart>
          </ResponsiveContainer>
          <p style={{ fontSize: '12px', color: '#666', marginTop: '10px' }}>
            70% had no falls in the last month, but 30% experienced 1-15 falls
          </p>
        </div>

        {/* Reliance on Others */}
        <div style={{ backgroundColor: 'white', padding: '20px', borderRadius: '8px', boxShadow: '0 2px 4px rgba(0,0,0,0.1)' }}>
          <h3 style={{ marginTop: 0, color: '#333', fontSize: '16px' }}>Reliance on Others While Walking</h3>
          <ResponsiveContainer width="100%" height={250}>
            <BarChart data={relianceData}>
              <CartesianGrid strokeDasharray="3 3" />
              <XAxis dataKey="level" angle={-45} textAnchor="end" height={80} style={{ fontSize: '12px' }} />
              <YAxis />
              <Tooltip />
              <Bar dataKey="count" fill="#ffc658" />
            </BarChart>
          </ResponsiveContainer>
          <p style={{ fontSize: '12px', color: '#666', marginTop: '10px' }}>
            65% report high reliance on others (ratings 4-5) while walking
          </p>
        </div>

        {/* Mobility Goals */}
        <div style={{ backgroundColor: 'white', padding: '20px', borderRadius: '8px', boxShadow: '0 2px 4px rgba(0,0,0,0.1)' }}>
          <h3 style={{ marginTop: 0, color: '#333', fontSize: '16px' }}>Primary Mobility Goals</h3>
          <ResponsiveContainer width="100%" height={250}>
            <BarChart data={goalsData} layout="vertical">
              <CartesianGrid strokeDasharray="3 3" />
              <XAxis type="number" />
              <YAxis dataKey="goal" type="category" width={150} style={{ fontSize: '11px' }} />
              <Tooltip />
              <Bar dataKey="count" fill="#8dd1e1" />
            </BarChart>
          </ResponsiveContainer>
          <p style={{ fontSize: '12px', color: '#666', marginTop: '10px' }}>
            65% want comprehensive improvement ("All of the above")
          </p>
        </div>
      </div>

      {/* Key Insights Box */}
      <div style={{ backgroundColor: 'white', padding: '20px', borderRadius: '8px', boxShadow: '0 2px 4px rgba(0,0,0,0.1)', marginTop: '20px' }}>
        <h3 style={{ marginTop: 0, color: '#333', fontSize: '16px' }}>Key Population Characteristics</h3>
        <div style={{ display: 'grid', gridTemplateColumns: 'repeat(auto-fit, minmax(250px, 1fr))', gap: '15px' }}>
          <div style={{ padding: '10px', backgroundColor: '#f9f9f9', borderRadius: '4px' }}>
            <strong style={{ color: '#8884d8' }}>High Severity:</strong> 90% report mobility difficulties bother them significantly (ratings 4-5)
          </div>
          <div style={{ padding: '10px', backgroundColor: '#f9f9f9', borderRadius: '4px' }}>
            <strong style={{ color: '#82ca9d' }}>Low Satisfaction:</strong> 65% have low satisfaction with mobility (ratings 1-2)
          </div>
          <div style={{ padding: '10px', backgroundColor: '#f9f9f9', borderRadius: '4px' }}>
            <strong style={{ color: '#ffc658' }}>Limited Range:</strong> 85% walk only in house or a block or less daily
          </div>
          <div style={{ padding: '10px', backgroundColor: '#f9f9f9', borderRadius: '4px' }}>
            <strong style={{ color: '#ff8042' }}>Fall Risk:</strong> 30% experienced falls in the last month
          </div>
          <div style={{ padding: '10px', backgroundColor: '#f9f9f9', borderRadius: '4px' }}>
            <strong style={{ color: '#8dd1e1' }}>ADL Impact:</strong> 80% report moderate to severe impact on activities of daily living
          </div>
          <div style={{ padding: '10px', backgroundColor: '#f9f9f9', borderRadius: '4px' }}>
            <strong style={{ color: '#8884d8' }}>Safety Concerns:</strong> Fear of falling is a primary goal for most respondents
          </div>
        </div>
      </div>

      <div style={{ marginTop: '20px', padding: '15px', backgroundColor: '#e8f4f8', borderRadius: '8px', fontSize: '13px', color: '#333' }}>
        <strong>Notable Finding:</strong> One respondent commented: "My PT recommended this previously, but it was too expensive. I'm so happy to be getting it covered through Prudential!" This suggests potential subscriber satisfaction benefit from health plan coverage.
      </div>
    </div>
  );
};

export default NextStrideVisualization;