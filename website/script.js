// website/script.js

// 1. Weather Data Pools for Interactive Widget
const weatherData = {
  kathmandu: {
    city: "Kathmandu",
    country: "Nepal",
    date: "Mon, June 1",
    temp: "24°C",
    desc: "Partly Cloudy",
    icon: '<i class="fa-solid fa-cloud-sun"></i>',
    wind: "12 km/h",
    humidity: "65%",
    uv: "Moderate",
    glow: "radial-gradient(circle, rgba(0, 229, 255, 0.18) 0%, rgba(213, 0, 249, 0.08) 50%, transparent 100%)",
    forecast: [
      { day: "Tue", icon: '<i class="fa-solid fa-cloud-showers-heavy"></i>', desc: "Rain showers", temp: "23° / 17°" },
      { day: "Wed", icon: '<i class="fa-solid fa-cloud-sun"></i>', desc: "Mostly sunny", temp: "25° / 16°" },
      { day: "Thu", icon: '<i class="fa-solid fa-sun"></i>', desc: "Clear & warm", temp: "27° / 18°" },
      { day: "Fri", icon: '<i class="fa-solid fa-cloud"></i>', desc: "Overcast skies", temp: "24° / 17°" }
    ]
  },
  newyork: {
    city: "New York",
    country: "United States",
    date: "Mon, June 1",
    temp: "19°C",
    desc: "Heavy Showers",
    icon: '<i class="fa-solid fa-cloud-showers-water"></i>',
    wind: "22 km/h",
    humidity: "88%",
    uv: "Low",
    glow: "radial-gradient(circle, rgba(0, 140, 255, 0.18) 0%, rgba(120, 0, 249, 0.08) 50%, transparent 100%)",
    forecast: [
      { day: "Tue", icon: '<i class="fa-solid fa-cloud-rain"></i>', desc: "Light rain", temp: "18° / 14°" },
      { day: "Wed", icon: '<i class="fa-solid fa-cloud-sun"></i>', desc: "Scattered sun", temp: "21° / 15°" },
      { day: "Thu", icon: '<i class="fa-solid fa-sun"></i>', desc: "Sunny & bright", temp: "23° / 16°" },
      { day: "Fri", icon: '<i class="fa-solid fa-cloud-sun"></i>', desc: "Partly cloudy", temp: "20° / 14°" }
    ]
  },
  tokyo: {
    city: "Tokyo",
    country: "Japan",
    date: "Mon, June 1",
    temp: "22°C",
    desc: "Sunny Interval",
    icon: '<i class="fa-solid fa-cloud-sun"></i>',
    wind: "9 km/h",
    humidity: "58%",
    uv: "High",
    glow: "radial-gradient(circle, rgba(255, 170, 0, 0.18) 0%, rgba(213, 0, 249, 0.08) 50%, transparent 100%)",
    forecast: [
      { day: "Tue", icon: '<i class="fa-solid fa-sun"></i>', desc: "Warm & sunny", temp: "24° / 16°" },
      { day: "Wed", icon: '<i class="fa-solid fa-sun"></i>', desc: "Clear sky", temp: "25° / 17°" },
      { day: "Thu", icon: '<i class="fa-solid fa-cloud-sun"></i>', desc: "Passing cloud", temp: "23° / 18°" },
      { day: "Fri", icon: '<i class="fa-solid fa-cloud-showers-heavy"></i>', desc: "PM rain", temp: "21° / 15°" }
    ]
  },
  london: {
    city: "London",
    country: "United Kingdom",
    date: "Mon, June 1",
    temp: "15°C",
    desc: "Dense Fog",
    icon: '<i class="fa-solid fa-smog"></i>',
    wind: "14 km/h",
    humidity: "92%",
    uv: "Low",
    glow: "radial-gradient(circle, rgba(100, 116, 139, 0.18) 0%, rgba(50, 50, 80, 0.08) 50%, transparent 100%)",
    forecast: [
      { day: "Tue", icon: '<i class="fa-solid fa-cloud"></i>', desc: "Overcast", temp: "16° / 11°" },
      { day: "Wed", icon: '<i class="fa-solid fa-cloud-rain"></i>', desc: "Drizzle", temp: "15° / 10°" },
      { day: "Thu", icon: '<i class="fa-solid fa-cloud-sun"></i>', desc: "Brief sunshine", temp: "17° / 12°" },
      { day: "Fri", icon: '<i class="fa-solid fa-sun"></i>', desc: "Sunny intervals", temp: "19° / 13°" }
    ]
  },
  sydney: {
    city: "Sydney",
    country: "Australia",
    date: "Mon, June 1",
    temp: "17°C",
    desc: "Windy Skies",
    icon: '<i class="fa-solid fa-wind"></i>',
    wind: "28 km/h",
    humidity: "50%",
    uv: "Low",
    glow: "radial-gradient(circle, rgba(0, 229, 255, 0.15) 0%, rgba(0, 100, 255, 0.1) 50%, transparent 100%)",
    forecast: [
      { day: "Tue", icon: '<i class="fa-solid fa-cloud"></i>', desc: "Partly cloudy", temp: "18° / 12°" },
      { day: "Wed", icon: '<i class="fa-solid fa-sun"></i>', desc: "Mainly clear", temp: "19° / 13°" },
      { day: "Thu", icon: '<i class="fa-solid fa-sun"></i>', desc: "Sun & pleasant", temp: "21° / 14°" },
      { day: "Fri", icon: '<i class="fa-solid fa-cloud-sun"></i>', desc: "Cloudy phases", temp: "18° / 11°" }
    ]
  }
};

// 2. DOM Elements Selection
const cityButtons = document.querySelectorAll('.city-btn');
const widgetCityName = document.getElementById('w-city');
const widgetCountryName = document.getElementById('w-country');
const widgetDateString = document.getElementById('w-date');
const widgetTempString = document.getElementById('w-temp');
const widgetDescString = document.getElementById('w-desc');
const widgetIconContainer = document.getElementById('w-icon');
const widgetWind = document.getElementById('w-wind');
const widgetHumidity = document.getElementById('w-humidity');
const widgetUv = document.getElementById('w-uv');
const widgetForecastList = document.getElementById('w-forecast');
const widgetGlowEl = document.getElementById('widget-glow');

const menuToggle = document.getElementById('menu-toggle');
const navMenu = document.getElementById('nav-menu');
const navLinks = document.querySelectorAll('.nav-link, .nav-btn');

// 3. Populate Widget Function with micro-animations
function updateWeatherWidget(cityKey) {
  const data = weatherData[cityKey];
  if (!data) return;

  // Add a tiny transition bounce to the widget container
  const widget = document.querySelector('.weather-widget');
  widget.style.transform = "scale(0.96) translateY(5px)";
  widget.style.opacity = "0.7";
  widget.style.transition = "all 0.3s cubic-bezier(0.16, 1, 0.3, 1)";

  setTimeout(() => {
    // Modify text content
    widgetCityName.textContent = data.city;
    widgetCountryName.textContent = data.country;
    widgetDateString.textContent = data.date;
    widgetTempString.textContent = data.temp;
    widgetDescString.textContent = data.desc;
    widgetIconContainer.innerHTML = data.icon;
    
    // Modify stats panel
    widgetWind.textContent = data.wind;
    widgetHumidity.textContent = data.humidity;
    widgetUv.textContent = data.uv;
    
    // Modify glowing backdrop colors
    if (widgetGlowEl) {
      widgetGlowEl.style.background = data.glow;
    }

    // Populate Weekly forecasts
    widgetForecastList.innerHTML = "";
    data.forecast.forEach(item => {
      const row = document.createElement('div');
      row.className = "forecast-day-row";
      row.innerHTML = `
        <span class="forecast-day-name">${item.day}</span>
        <span class="forecast-day-icon">${item.icon}</span>
        <span class="forecast-day-desc">${item.desc}</span>
        <span class="forecast-day-temp">${item.temp}</span>
      `;
      widgetForecastList.appendChild(row);
    });

    // Reset styles to standard with pop animation
    widget.style.transform = "scale(1) translateY(0)";
    widget.style.opacity = "1";
  }, 250);
}

// 4. City Switching Click Handlers
cityButtons.forEach(btn => {
  btn.addEventListener('click', () => {
    // Remove active class
    cityButtons.forEach(b => b.classList.remove('active'));
    
    // Add active to current button
    btn.classList.add('active');
    
    // Get key and execute change
    const cityKey = btn.getAttribute('data-city');
    updateWeatherWidget(cityKey);
  });
});

// 5. Mobile Menu Navigation Toggler
if (menuToggle && navMenu) {
  menuToggle.addEventListener('click', () => {
    navMenu.classList.toggle('active');
  });

  // Close navigation menu drawer when any link is clicked
  navLinks.forEach(link => {
    link.addEventListener('click', () => {
      navMenu.classList.remove('active');
    });
  });
}

// 6. Header Glassmorphism Scroll Trigger
window.addEventListener('scroll', () => {
  const navbar = document.querySelector('.navbar');
  if (navbar) {
    if (window.scrollY > 50) {
      navbar.style.padding = "0.75rem 2rem";
      navbar.style.background = "rgba(5, 5, 7, 0.92)";
      navbar.style.boxShadow = "0 10px 30px rgba(0,0,0,0.5)";
    } else {
      navbar.style.padding = "1rem 2rem";
      navbar.style.background = "rgba(8, 8, 10, 0.8)";
      navbar.style.boxShadow = "none";
    }
  }
});

// 7. Initial Load Execution
document.addEventListener('DOMContentLoaded', () => {
  // Populate default city Kathmandu
  updateWeatherWidget('kathmandu');
});
