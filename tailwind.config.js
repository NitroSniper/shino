/** @type {import('tailwindcss').Config} */
module.exports = {
  darkMode: 'selector',
  content: [
    "./templates/**/*.html"
  ],
  theme: {
    extend: {
      keyframes: {
        'go-up-square': {
          '0%': { transform: 'translateY(5000%) rotate(0)' },
          '100%': { transform: 'translateY(0%) rotate(720deg)' },
        }
      },
      animation: {
        'up-square': 'go-up-square 10s linear',
      },
    },
  },
  plugins: [
    require('@tailwindcss/forms'),
    require('@tailwindcss/typography'),
  ],
  safelist: [
    'delay-250',
    'delay-500',
    'delay-750',
  ]
}

